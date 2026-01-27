import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import '../models/message.dart';
import '../services/storage_service.dart';
import '../services/data_notifier.dart';
import '../theme/visual_effects_config.dart';
import '../widgets/visual_effects_widgets.dart';

class PackScreen extends StatefulWidget {
  const PackScreen({super.key});

  @override
  State<PackScreen> createState() => _PackScreenState();
}

class _PackScreenState extends State<PackScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _storageService = StorageService();
  final _audioRecorder = AudioRecorder();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  bool _isLoading = false;
  bool _isRecording = false;
  String? _audioPath;
  int _recordingDuration = 0;
  String _selectedSecurityLevel = 'Easy';

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          color: CupertinoColors.systemBackground.resolveFrom(context),
          child: Column(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  border: const Border(
                    bottom: BorderSide(
                      color: CupertinoColors.separator,
                      width: 0.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.dateAndTime,
                  initialDateTime: _selectedDate,
                  minimumDate: DateTime.now(),
                  onDateTimeChanged: (DateTime newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveCapsule() async {
    if (_titleController.text.isEmpty) {
      _showAlert('Error', 'Please enter a title');
      return;
    }

    if (_messageController.text.isEmpty && _audioPath == null) {
      _showAlert(
        'Error',
        'Please provide either a text message or voice recording',
      );
      return;
    }

    if (_selectedDate.isBefore(DateTime.now())) {
      _showAlert('Error', 'Unlock date must be in the future');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final capsule = TimeCapsule(
        id: const Uuid().v4(),
        title: _titleController.text,
        message: _messageController.text,
        audioPath: _audioPath,
        createdAt: DateTime.now(),
        unlockAt: _selectedDate,
        securityLevel: _selectedSecurityLevel,
      );

      await _storageService.addCapsule(capsule);

      // Notify other screens that data has changed
      DataNotifier.notifyDataChanged();

      if (mounted) {
        _titleController.clear();
        _messageController.clear();
        setState(() {
          _selectedDate = DateTime.now().add(const Duration(days: 1));
          _audioPath = null;
          _recordingDuration = 0;
          _selectedSecurityLevel = 'Easy';
        });

        // Trigger rebuild of UnpackScreen to show the new capsule
        // This will work through didChangeDependencies
        _showAlert('Success', 'Time capsule created successfully!');
      }
    } catch (e) {
      _showAlert('Error', 'Failed to create time capsule');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showAlert(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleRecording() async {
    if (_isRecording) {
      await _stopRecording();
    } else {
      await _startRecording();
    }
  }

  Future<void> _startRecording() async {
    // Check if microphone permission is granted using record package
    if (await _audioRecorder.hasPermission() == false) {
      // Permission denied or not determined
      _showAlert(
        'Permission Required',
        'Please allow microphone access in Settings to record voice messages.',
      );
      // Try to open settings
      await openAppSettings();
      return;
    }

    // Permission granted, start recording
    try {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${const Uuid().v4()}.m4a';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = 0;
      });

      // Update duration every second
      _updateRecordingDuration();
    } catch (e) {
      _showAlert('Error', 'Failed to start recording: ${e.toString()}');
    }
  }

  void _updateRecordingDuration() {
    if (_isRecording) {
      Future.delayed(const Duration(seconds: 1), () {
        if (_isRecording && mounted) {
          setState(() {
            _recordingDuration++;
          });
          _updateRecordingDuration();
        }
      });
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();

      if (path != null) {
        // Save only the filename, not the full path
        final filename = path.split('/').last;
        setState(() {
          _audioPath = filename;
          _isRecording = false;
        });
      }
    } catch (e) {
      _showAlert('Error', 'Failed to stop recording');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _deleteRecording() async {
    if (_audioPath != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/$_audioPath');
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e) {
        // Ignore deletion errors
      }

      setState(() {
        _audioPath = null;
        _recordingDuration = 0;
      });
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Pack a Message'),
      ),
      child: GradientBackground(
        colors: [
          VisualEffectsConfig.packGradientStart,
          VisualEffectsConfig.packGradientEnd,
        ],
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  showGlow: true,
                  glowColor: VisualEffectsConfig.packGradientEnd,
                  child: Column(
                    children: [
                      ShimmerLoading(
                        isLoading: false,
                        child: Icon(
                          CupertinoIcons.cube_box_fill,
                          size: 60,
                          color: VisualEffectsConfig.packGradientEnd,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Create a Time Capsule',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Send a message to your future self',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Title',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _titleController,
                  placeholder: 'Give your capsule a title',
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Message',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                CupertinoTextField(
                  controller: _messageController,
                  placeholder: 'Write your message to the future...',
                  maxLines: 8,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Voice Recording (Optional)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                if (_audioPath != null)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.systemGreen.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: CupertinoColors.systemGreen,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Voice recording saved',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Duration: ${_formatDuration(_recordingDuration)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 217, 217, 225),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: _deleteRecording,
                          child: const Icon(
                            CupertinoIcons.trash,
                            color: CupertinoColors.systemRed,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _isRecording
                            ? const Color.fromARGB(
                                255,
                                255,
                                114,
                                48,
                              ).withOpacity(0.4)
                            : CupertinoColors.darkBackgroundGray,
                        borderRadius: BorderRadius.circular(12),
                        border: _isRecording
                            ? Border.all(
                                color: CupertinoColors.systemRed.withOpacity(
                                  0.5,
                                ),
                                width: 2,
                              )
                            : Border.all(
                                color: CupertinoColors.white.withOpacity(0.4),
                                width: 1,
                              ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            _isRecording
                                ? CupertinoIcons.stop_circle_fill
                                : CupertinoIcons.mic_circle_fill,
                            size: 48,
                            color: _isRecording
                                ? CupertinoColors.systemRed
                                : CupertinoColors.systemBlue,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _isRecording
                                ? 'Recording... ${_formatDuration(_recordingDuration)}'
                                : 'Tap to record voice message',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isRecording
                                  ? Color.fromARGB(255, 217, 217, 225)
                                  : CupertinoColors.systemGrey,
                            ),
                          ),
                          if (_isRecording)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Tap again to stop',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 217, 217, 225),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Security Level',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.darkBackgroundGray,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: CupertinoColors.white.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: CupertinoSlidingSegmentedControl<String>(
                    groupValue: _selectedSecurityLevel,
                    children: const {
                      'Easy': Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.lock_open, size: 18),
                            SizedBox(width: 6),
                            Text('Easy'),
                          ],
                        ),
                      ),
                      'Medium': Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.lock_shield, size: 18),
                            SizedBox(width: 6),
                            Text('Medium'),
                          ],
                        ),
                      ),
                      'Difficult': Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.lock_fill, size: 18),
                            SizedBox(width: 6),
                            Text('Hard'),
                          ],
                        ),
                      ),
                    },
                    onValueChanged: (value) {
                      setState(() {
                        _selectedSecurityLevel = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Unlock Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _showDatePicker,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CupertinoColors.darkBackgroundGray,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CupertinoColors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} ${_selectedDate.hour}:${_selectedDate.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Icon(
                          CupertinoIcons.calendar,
                          color: CupertinoColors.systemGrey,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                GradientButton(
                  text: 'Pack Time Capsule',
                  onPressed: _saveCapsule,
                  gradientColors: [
                    VisualEffectsConfig.packGradientStart,
                    VisualEffectsConfig.primaryGradientStart,
                  ],
                  showGlow: true,
                  isLoading: _isLoading,
                  height: 56,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

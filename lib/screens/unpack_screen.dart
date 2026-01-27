import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/message.dart';
import '../services/storage_service.dart';
import '../services/data_notifier.dart';
import 'unlock_challenge_screen.dart';
import '../theme/visual_effects_config.dart';
import '../widgets/visual_effects_widgets.dart';

class UnpackScreen extends StatefulWidget {
  const UnpackScreen({super.key});

  @override
  State<UnpackScreen> createState() => _UnpackScreenState();
}

class _UnpackScreenState extends State<UnpackScreen> {
  final _storageService = StorageService();
  final _audioPlayer = AudioPlayer();
  List<TimeCapsule> _capsules = [];
  bool _isLoading = true;
  bool _isPlayingAudio = false;
  bool _isAudioPaused = false;
  String? _currentPlayingId;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadCapsules();

    // Listen for data changes from other screens
    DataNotifier.dataChanged.addListener(_onDataChanged);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlayingAudio = state == PlayerState.playing;
          _isAudioPaused = state == PlayerState.paused;
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
  }

  void _onDataChanged() {
    _loadCapsules();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCapsules();
  }

  @override
  void dispose() {
    DataNotifier.dataChanged.removeListener(_onDataChanged);
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadCapsules() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final capsules = await _storageService.getCapsules();
      if (mounted) {
        setState(() {
          _capsules = capsules
            ..sort((a, b) => b.unlockAt.compareTo(a.unlockAt));
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showCapsuleDetail(TimeCapsule capsule) {
    final isUnlocked =
        DateTime.now().isAfter(capsule.unlockAt) || capsule.isOpened;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Update modal when audio state changes
          _audioPlayer.onPlayerStateChanged.listen((state) {
            if (mounted) {
              setModalState(() {});
            }
          });
          _audioPlayer.onPositionChanged.listen((position) {
            if (mounted) {
              setModalState(() {});
            }
          });
          _audioPlayer.onDurationChanged.listen((duration) {
            if (mounted) {
              setModalState(() {});
            }
          });

          return CupertinoActionSheet(
            title: Text(
              capsule.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            message: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                if (isUnlocked) ...[
                  if (capsule.message.isNotEmpty) ...[
                    Text(capsule.message, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                  ],
                  if (capsule.audioPath != null) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: CupertinoColors.systemBlue.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => _toggleAudioPlayback(capsule),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: CupertinoColors.systemBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isPlayingAudio &&
                                            _currentPlayingId == capsule.id
                                        ? CupertinoIcons.pause_fill
                                        : (_isAudioPaused &&
                                                  _currentPlayingId ==
                                                      capsule.id
                                              ? CupertinoIcons.play_fill
                                              : CupertinoIcons.play_fill),
                                    color: CupertinoColors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentPlayingId == capsule.id
                                          ? (_isPlayingAudio
                                                ? 'Playing...'
                                                : (_isAudioPaused
                                                      ? 'Paused'
                                                      : 'Voice Message'))
                                          : 'Voice Message',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: CupertinoColors.systemBlue,
                                      ),
                                    ),
                                    if (_currentPlayingId == capsule.id &&
                                        _totalDuration.inSeconds > 0)
                                      Text(
                                        '${_formatAudioDuration(_currentPosition)} / ${_formatAudioDuration(_totalDuration)}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: CupertinoColors.systemGrey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (_currentPlayingId == capsule.id &&
                                  (_isPlayingAudio || _isAudioPaused))
                                GestureDetector(
                                  onTap: () => _stopAudioPlayback(),
                                  child: const Icon(
                                    CupertinoIcons.stop_circle,
                                    color: CupertinoColors.systemBlue,
                                    size: 28,
                                  ),
                                ),
                            ],
                          ),
                          if (_currentPlayingId == capsule.id &&
                              _totalDuration.inSeconds > 0) ...[
                            const SizedBox(height: 12),
                            Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: CupertinoColors.systemGrey5,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _totalDuration.inSeconds > 0
                                    ? _currentPosition.inSeconds /
                                          _totalDuration.inSeconds
                                    : 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemBlue,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text(
                    'Created: ${DateFormat('MMM dd, yyyy').format(capsule.createdAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  Text(
                    'Unlocked: ${DateFormat('MMM dd, yyyy').format(capsule.unlockAt)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getSecurityColor(
                        capsule.securityLevel,
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getSecurityIcon(capsule.securityLevel),
                          size: 16,
                          color: _getSecurityColor(capsule.securityLevel),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Security: ${capsule.securityLevel}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getSecurityColor(capsule.securityLevel),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const Icon(
                    CupertinoIcons.lock_fill,
                    size: 48,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This capsule is locked until\n${DateFormat('MMM dd, yyyy HH:mm').format(capsule.unlockAt)}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getTimeRemaining(capsule.unlockAt),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (!isUnlocked)
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    _startUnlockChallenge(capsule);
                  },
                  child: const Text('Unlock Early'),
                ),
              if (isUnlocked && !capsule.isOpened)
                CupertinoActionSheetAction(
                  onPressed: () async {
                    await _markAsOpened(capsule);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Mark as Read'),
                ),
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () {
                  Navigator.pop(context);
                  _confirmDeleteCapsule(capsule);
                },
                child: const Text('Delete'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          );
        },
      ),
    );
  }

  void _startUnlockChallenge(TimeCapsule capsule) async {
    await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => UnlockChallengeScreen(
          securityLevel: capsule.securityLevel,
          unlockDate: capsule.unlockAt,
          onSuccess: () async {
            await _markAsOpened(capsule);
          },
        ),
      ),
    );

    // Reload capsules after returning from challenge
    await _loadCapsules();

    // Get updated capsule and show it immediately
    if (mounted) {
      final updatedCapsules = await _storageService.getCapsules();
      final updatedCapsule = updatedCapsules.firstWhere(
        (c) => c.id == capsule.id,
        orElse: () => capsule,
      );

      if (updatedCapsule.isOpened) {
        // Show success dialog and then the capsule detail
        showCupertinoDialog(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => CupertinoAlertDialog(
            title: const Text('Success!'),
            content: const Text('Time capsule unlocked early!'),
            actions: [
              CupertinoDialogAction(
                child: const Text('Open'),
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _showCapsuleDetail(updatedCapsule);
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _toggleAudioPlayback(TimeCapsule capsule) async {
    if (capsule.audioPath == null) return;

    // Reconstruct full path from filename
    final directory = await getApplicationDocumentsDirectory();
    final fullPath = '${directory.path}/${capsule.audioPath}';
    final file = File(fullPath);

    if (!file.existsSync()) {
      _showAlert('Error', 'Audio file not found');
      return;
    }

    if (_isPlayingAudio && _currentPlayingId == capsule.id) {
      await _audioPlayer.pause();
    } else if (_isAudioPaused && _currentPlayingId == capsule.id) {
      await _audioPlayer.resume();
    } else {
      setState(() {
        _currentPlayingId = capsule.id;
        _currentPosition = Duration.zero;
      });
      await _audioPlayer.play(DeviceFileSource(fullPath));
    }
  }

  Future<void> _stopAudioPlayback() async {
    await _audioPlayer.stop();
    setState(() {
      _currentPlayingId = null;
      _isPlayingAudio = false;
      _isAudioPaused = false;
      _currentPosition = Duration.zero;
      _totalDuration = Duration.zero;
    });
  }

  String _formatAudioDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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

  String _getTimeRemaining(DateTime unlockDate) {
    final now = DateTime.now();
    final difference = unlockDate.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays} days remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes remaining';
    } else {
      return 'Unlocking soon...';
    }
  }

  Future<void> _markAsOpened(TimeCapsule capsule) async {
    await _storageService.updateCapsule(capsule.copyWith(isOpened: true));
    await _loadCapsules();
  }

  Color _getSecurityColor(String level) {
    switch (level) {
      case 'Easy':
        return CupertinoColors.systemGreen;
      case 'Medium':
        return CupertinoColors.systemOrange;
      case 'Difficult':
        return CupertinoColors.systemRed;
      default:
        return CupertinoColors.systemGrey;
    }
  }

  IconData _getSecurityIcon(String level) {
    switch (level) {
      case 'Easy':
        return CupertinoIcons.lock_open;
      case 'Medium':
        return CupertinoIcons.lock_shield;
      case 'Difficult':
        return CupertinoIcons.lock_fill;
      default:
        return CupertinoIcons.lock;
    }
  }

  Future<void> _deleteCapsule(String id) async {
    // Find the capsule to get audio path before deleting
    final capsule = _capsules.firstWhere((c) => c.id == id);

    // Delete audio file if exists
    if (capsule.audioPath != null) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/${capsule.audioPath}');
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (e) {
        // Ignore file deletion errors
      }
    }

    // Stop audio if this capsule is currently playing
    if (_currentPlayingId == id) {
      await _stopAudioPlayback();
    }

    // Delete from storage
    await _storageService.deleteCapsule(id);
    await _loadCapsules();

    // Notify other screens that data has changed
    DataNotifier.notifyDataChanged();
  }

  void _confirmDeleteCapsule(TimeCapsule capsule) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Delete Time Capsule'),
        content: Text(
          'Are you sure you want to delete "${capsule.title}"? This action cannot be undone.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(context);
              await _deleteCapsule(capsule.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getCapsuleColor(TimeCapsule capsule) {
    if (capsule.isOpened) {
      return CupertinoColors.systemGrey;
    } else if (DateTime.now().isAfter(capsule.unlockAt)) {
      return CupertinoColors.systemGreen;
    } else {
      return CupertinoColors.systemOrange;
    }
  }

  IconData _getCapsuleIcon(TimeCapsule capsule) {
    if (capsule.isOpened) {
      return CupertinoIcons.check_mark_circled_solid;
    } else if (DateTime.now().isAfter(capsule.unlockAt)) {
      return CupertinoIcons.lock_open_fill;
    } else {
      return CupertinoIcons.lock_fill;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Unpack Messages'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.refresh),
          onPressed: _loadCapsules,
        ),
      ),
      child: GradientBackground(
        colors: [
          VisualEffectsConfig.unpackGradientStart,
          VisualEffectsConfig.unpackGradientEnd,
        ],
        child: _isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : _capsules.isEmpty
            ? Center(
                child: GlassCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ShimmerLoading(
                        isLoading: false,
                        child: Icon(
                          CupertinoIcons.cube_box,
                          size: 80,
                          color: VisualEffectsConfig.unpackGradientStart,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No time capsules yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your first capsule in the Pack tab',
                        style: TextStyle(
                          fontSize: 14,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : SafeArea(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _capsules.length,
                  itemBuilder: (context, index) {
                    final capsule = _capsules[index];
                    final isUnlocked = DateTime.now().isAfter(capsule.unlockAt);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GlassCard(
                        onTap: () => _showCapsuleDetail(capsule),
                        showGlow: isUnlocked && !capsule.isOpened,
                        glowColor: isUnlocked
                            ? VisualEffectsConfig.successGlowColor
                            : VisualEffectsConfig.lockedGradientStart,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _getCapsuleColor(capsule).withOpacity(0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: _getCapsuleColor(
                                    capsule,
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getCapsuleIcon(capsule),
                                  color: _getCapsuleColor(capsule),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      capsule.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isUnlocked
                                          ? 'Unlocked ${DateFormat('MMM dd, yyyy').format(capsule.unlockAt)}'
                                          : _getTimeRemaining(capsule.unlockAt),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _getCapsuleColor(capsule),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                CupertinoIcons.chevron_right,
                                color: CupertinoColors.systemGrey,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}

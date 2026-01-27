import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../services/storage_service.dart';
import '../services/data_notifier.dart';
import '../theme/visual_effects_config.dart';
import '../widgets/visual_effects_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storageService = StorageService();

  void _showAboutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('About Jest Time-capsule'),
        content: const Text(
          'Version 1.0.0\n\n'
          'Create messages for your future self and unlock them at the perfect time.\n\n'
          'Developed with ❤️ using Flutter',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showClearDataDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Clear All Data'),
        content: const Text(
          'Are you sure you want to delete all time capsules? This action cannot be undone.',
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
              await _clearAllData();
            },
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    try {
      // Get all capsules before clearing
      final capsules = await _storageService.getCapsules();

      // Delete all audio files
      final directory = await getApplicationDocumentsDirectory();
      for (final capsule in capsules) {
        if (capsule.audioPath != null) {
          try {
            final file = File('${directory.path}/${capsule.audioPath}');
            if (file.existsSync()) {
              await file.delete();
            }
          } catch (e) {
            // Continue even if one file fails to delete
          }
        }
      }

      // Clear all data from storage
      await _storageService.saveCapsules([]);

      // Notify other screens that data has changed
      DataNotifier.notifyDataChanged();

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog();
      }
    }
  }

  void _showErrorDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to clear all data. Please try again.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Success'),
        content: const Text('All data has been cleared.'),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: const Text('Could not open the link'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Settings')),
      child: GradientBackground(
        colors: [
          VisualEffectsConfig.settingsGradientStart,
          VisualEffectsConfig.settingsGradientEnd,
        ],
        child: SafeArea(
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Center(
                child: PulsingGlow(
                  glowColor: VisualEffectsConfig.settingsGradientEnd,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          VisualEffectsConfig.settingsGradientStart,
                          VisualEffectsConfig.settingsGradientEnd,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: VisualEffectsConfig.createGlowEffect(
                        color: VisualEffectsConfig.settingsGradientEnd,
                      ),
                    ),
                    child: const Icon(
                      CupertinoIcons.settings_solid,
                      size: 50,
                      color: CupertinoColors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  'Jest Time-Capsule',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Messages for your future self',
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildSectionHeader('General'),
              _buildSettingsTile(
                icon: CupertinoIcons.info_circle_fill,
                title: 'About',
                subtitle: 'App information and version',
                color: CupertinoColors.systemBlue,
                onTap: _showAboutDialog,
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.doc_text_fill,
                title: 'Privacy Policy',
                subtitle: 'View our privacy policy',
                color: CupertinoColors.systemIndigo,
                onTap: () => _openUrl(
                  'https://jesttime-capsule.com/privacy-policy.html',
                ),
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Data Management'),
              _buildSettingsTile(
                icon: CupertinoIcons.trash_fill,
                title: 'Clear All Data',
                subtitle: 'Delete all time capsules',
                color: CupertinoColors.systemRed,
                onTap: _showClearDataDialog,
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Support'),
              _buildSettingsTile(
                icon: CupertinoIcons.question_circle_fill,
                title: 'How to Use',
                subtitle: 'Learn how to create time capsules',
                color: CupertinoColors.systemGreen,
                onTap: () => _showHowToUse(),
              ),
              _buildSettingsTile(
                icon: CupertinoIcons.link,
                title: 'Support Link',
                subtitle: 'Get help and support',
                color: CupertinoColors.systemTeal,
                onTap: () =>
                    _openUrl('https://jesttime-capsule.com/support.html'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: CupertinoColors.systemGrey,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        onTap: onTap,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
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
    );
  }

  void _showHowToUse() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('How to Use'),
        content: const Text(
          '\n📦 Pack Tab:\n'
          'Create new time capsules with messages for your future self. Set a date and time when they will unlock.\n\n'
          '🎁 Unpack Tab:\n'
          'View all your time capsules. Locked capsules will unlock automatically at their scheduled time.\n\n'
          '💡 Wisdom Tab:\n'
          'Get random inspirational advice and motivation.\n\n'
          '⚙️ Settings:\n'
          'Manage your app preferences and data.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Got it!'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

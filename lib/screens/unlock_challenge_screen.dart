import 'package:flutter/cupertino.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class UnlockChallengeScreen extends StatefulWidget {
  final String securityLevel;
  final DateTime unlockDate;
  final VoidCallback onSuccess;

  const UnlockChallengeScreen({
    super.key,
    required this.securityLevel,
    required this.unlockDate,
    required this.onSuccess,
  });

  @override
  State<UnlockChallengeScreen> createState() => _UnlockChallengeScreenState();
}

class _UnlockChallengeScreenState extends State<UnlockChallengeScreen> {
  int _currentChallengeIndex = 0;
  int _currentProgress = 0;
  int _requiredCount = 0;
  List<ChallengeType> _challenges = [];

  StreamSubscription? _accelerometerSubscription;
  StreamSubscription? _gyroscopeSubscription;

  bool _isShaking = false;
  bool _isFlipping = false;
  double _lastZ = 0;

  @override
  void initState() {
    super.initState();
    _initializeChallenges();
    _startCurrentChallenge();
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();
    super.dispose();
  }

  void _initializeChallenges() {
    // Calculate required count based on time remaining
    final now = DateTime.now();
    final difference = widget.unlockDate.difference(now);

    // Base count is 30, add more based on time remaining
    final daysRemaining = difference.inDays;
    final hoursRemaining = difference.inHours;

    if (daysRemaining > 7) {
      _requiredCount = 100;
    } else if (daysRemaining > 3) {
      _requiredCount = 70;
    } else if (daysRemaining > 1) {
      _requiredCount = 50;
    } else if (hoursRemaining > 12) {
      _requiredCount = 40;
    } else {
      _requiredCount = 30;
    }

    // Determine challenges based on security level
    switch (widget.securityLevel) {
      case 'Easy':
        _challenges = [ChallengeType.tap];
        break;
      case 'Medium':
        _challenges = [ChallengeType.shake, ChallengeType.tap];
        break;
      case 'Difficult':
        _challenges = [
          ChallengeType.shake,
          ChallengeType.flip,
          ChallengeType.tap,
        ];
        break;
      default:
        _challenges = [ChallengeType.tap];
    }

    // Shuffle for variety
    _challenges.shuffle();
  }

  void _startCurrentChallenge() {
    _currentProgress = 0;
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();

    final challenge = _challenges[_currentChallengeIndex];

    if (challenge == ChallengeType.shake) {
      _startShakeDetection();
    } else if (challenge == ChallengeType.flip) {
      _startFlipDetection();
    }
  }

  void _startShakeDetection() {
    _accelerometerSubscription = accelerometerEventStream().listen((event) {
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > 20 && !_isShaking) {
        _isShaking = true;
        _incrementProgress();

        Future.delayed(const Duration(milliseconds: 300), () {
          _isShaking = false;
        });
      }
    });
  }

  void _startFlipDetection() {
    _gyroscopeSubscription = gyroscopeEventStream().listen((event) {
      final currentZ = event.z;

      // Detect significant rotation
      if ((currentZ - _lastZ).abs() > 2.0 && !_isFlipping) {
        _isFlipping = true;
        _incrementProgress();

        Future.delayed(const Duration(milliseconds: 500), () {
          _isFlipping = false;
        });
      }

      _lastZ = currentZ;
    });
  }

  void _incrementProgress() {
    if (mounted) {
      setState(() {
        _currentProgress++;

        if (_currentProgress >= _requiredCount) {
          _completeCurrentChallenge();
        }
      });
    }
  }

  void _completeCurrentChallenge() {
    _accelerometerSubscription?.cancel();
    _gyroscopeSubscription?.cancel();

    if (_currentChallengeIndex < _challenges.length - 1) {
      setState(() {
        _currentChallengeIndex++;
        _startCurrentChallenge();
      });
    } else {
      // All challenges completed
      widget.onSuccess();
      Navigator.pop(context);
    }
  }

  String _getChallengeTitle() {
    final challenge = _challenges[_currentChallengeIndex];
    switch (challenge) {
      case ChallengeType.shake:
        return 'Shake Your Device';
      case ChallengeType.flip:
        return 'Flip Your Device';
      case ChallengeType.tap:
        return 'Tap the Area';
    }
  }

  String _getChallengeDescription() {
    final challenge = _challenges[_currentChallengeIndex];
    switch (challenge) {
      case ChallengeType.shake:
        return 'Shake your phone to unlock';
      case ChallengeType.flip:
        return 'Flip your phone back and forth';
      case ChallengeType.tap:
        return 'Tap the glowing area below';
    }
  }

  IconData _getChallengeIcon() {
    final challenge = _challenges[_currentChallengeIndex];
    switch (challenge) {
      case ChallengeType.shake:
        return CupertinoIcons.device_phone_portrait;
      case ChallengeType.flip:
        return CupertinoIcons.rotate_right;
      case ChallengeType.tap:
        return CupertinoIcons.hand_point_right;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _currentProgress / _requiredCount;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          'Challenge ${_currentChallengeIndex + 1}/${_challenges.length}',
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      CupertinoColors.systemPurple,
                      CupertinoColors.systemBlue,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.systemPurple.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  _getChallengeIcon(),
                  size: 60,
                  color: CupertinoColors.white,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _getChallengeTitle(),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _getChallengeDescription(),
                style: const TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Text(
                '$_currentProgress / $_requiredCount',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.systemPurple,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemPurple,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              if (_challenges[_currentChallengeIndex] == ChallengeType.tap)
                GestureDetector(
                  onTap: _incrementProgress,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          CupertinoColors.systemPurple.withOpacity(0.6),
                          CupertinoColors.systemBlue.withOpacity(0.6),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemPurple.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'TAP',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: CupertinoColors.systemGrey4,
                      width: 3,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      _getChallengeIcon(),
                      size: 80,
                      color: CupertinoColors.systemGrey3,
                    ),
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

enum ChallengeType { shake, flip, tap }

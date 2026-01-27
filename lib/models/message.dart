class TimeCapsule {
  final String id;
  final String title;
  final String message;
  final String? audioPath;
  final DateTime createdAt;
  final DateTime unlockAt;
  final bool isOpened;
  final String securityLevel; // 'Easy', 'Medium', 'Difficult'

  TimeCapsule({
    required this.id,
    required this.title,
    required this.message,
    this.audioPath,
    required this.createdAt,
    required this.unlockAt,
    this.isOpened = false,
    this.securityLevel = 'Easy',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'audioPath': audioPath,
      'createdAt': createdAt.toIso8601String(),
      'unlockAt': unlockAt.toIso8601String(),
      'isOpened': isOpened,
      'securityLevel': securityLevel,
    };
  }

  factory TimeCapsule.fromJson(Map<String, dynamic> json) {
    return TimeCapsule(
      id: json['id'],
      title: json['title'],
      message: json['message'] ?? '',
      audioPath: json['audioPath'],
      createdAt: DateTime.parse(json['createdAt']),
      unlockAt: DateTime.parse(json['unlockAt']),
      isOpened: json['isOpened'] ?? false,
      securityLevel: json['securityLevel'] ?? 'Easy',
    );
  }

  TimeCapsule copyWith({
    String? id,
    String? title,
    String? message,
    String? audioPath,
    DateTime? createdAt,
    DateTime? unlockAt,
    bool? isOpened,
    String? securityLevel,
  }) {
    return TimeCapsule(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      audioPath: audioPath ?? this.audioPath,
      createdAt: createdAt ?? this.createdAt,
      unlockAt: unlockAt ?? this.unlockAt,
      isOpened: isOpened ?? this.isOpened,
      securityLevel: securityLevel ?? this.securityLevel,
    );
  }
}

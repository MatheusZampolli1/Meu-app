class SecurityEvent {
  const SecurityEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    this.meta,
  });

  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final Map<String, dynamic>? meta;

  Map<String, dynamic> toMap() => {
        'id': id,
        'type': type,
        'title': title,
        'message': message,
        'createdAt': createdAt.toIso8601String(),
        if (meta != null) 'meta': Map<String, dynamic>.from(meta!),
      };

  factory SecurityEvent.fromMap(Map<String, dynamic> map) {
    final rawMeta = map['meta'];
    return SecurityEvent(
      id: map['id'] as String,
      type: map['type'] as String? ?? 'generic',
      title: map['title'] as String? ?? 'Security event',
      message: map['message'] as String? ?? '',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      meta: rawMeta is Map<String, dynamic>
          ? Map<String, dynamic>.from(rawMeta)
          : null,
    );
  }
}

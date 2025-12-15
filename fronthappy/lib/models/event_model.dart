class EventModel {
  final int id;
  final String title;
  final String description;
  final DateTime eventDate;
  final String location;
  final int maxParticipants;
  final int currentParticipants;
  final String status; // UPCOMING, ONGOING, COMPLETED, CANCELLED
  final DateTime createdAt;
  final DateTime? updatedAt;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.eventDate,
    required this.location,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      eventDate: json['eventDate'] != null
          ? DateTime.parse(json['eventDate'])
          : DateTime.now(),
      location: json['location'] ?? '',
      maxParticipants: json['maxParticipants'] ?? 0,
      currentParticipants: json['currentParticipants'] ?? 0,
      status: json['status'] ?? 'UPCOMING',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'location': location,
      'maxParticipants': maxParticipants,
      'currentParticipants': currentParticipants,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get statusRu {
    switch (status) {
      case 'UPCOMING':
        return 'Предстоящее';
      case 'ONGOING':
        return 'В процессе';
      case 'COMPLETED':
        return 'Завершено';
      case 'CANCELLED':
        return 'Отменено';
      default:
        return status;
    }
  }

  bool get isFull => currentParticipants >= maxParticipants;

  bool get canRegister => status == 'UPCOMING' && !isFull;
}

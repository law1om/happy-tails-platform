class ApplicationModel {
  final int id;
  final int userId;
  final int animalId;
  final int? adoptionProfileId;
  final String status; // PENDING, APPROVED, REJECTED, COMPLETED
  final String? adminComment;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Дополнительные поля для отображения
  final String? userName;
  final String? userEmail;
  final String? animalName;
  final String? animalSpecies;

  ApplicationModel({
    required this.id,
    required this.userId,
    required this.animalId,
    this.adoptionProfileId,
    required this.status,
    this.adminComment,
    required this.createdAt,
    this.updatedAt,
    this.userName,
    this.userEmail,
    this.animalName,
    this.animalSpecies,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      animalId: json['animalId'] ?? 0,
      adoptionProfileId: json['adoptionProfileId'],
      status: json['status'] ?? 'PENDING',
      adminComment: json['adminComment'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      userName: json['userName'],
      userEmail: json['userEmail'],
      animalName: json['animalName'],
      animalSpecies: json['animalSpecies'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'animalId': animalId,
      'adoptionProfileId': adoptionProfileId,
      'status': status,
      'adminComment': adminComment,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get statusRu {
    switch (status) {
      case 'PENDING':
        return 'На рассмотрении';
      case 'APPROVED':
        return 'Одобрена';
      case 'REJECTED':
        return 'Отклонена';
      case 'COMPLETED':
        return 'Завершена';
      default:
        return status;
    }
  }
}

class AdoptionProfileModel {
  final int id;
  final int userId;
  final String housingType; // APARTMENT, HOUSE, OTHER
  final bool hasYard;
  final bool hasOtherPets;
  final String? otherPetsDescription;
  final bool hasChildren;
  final int? childrenCount;
  final String experience; // NONE, SOME, EXTENSIVE
  final String workSchedule;
  final String address;
  final String phone;
  final String? additionalInfo;
  final String status; // PENDING, APPROVED, REJECTED
  final DateTime createdAt;
  final DateTime? updatedAt;

  AdoptionProfileModel({
    required this.id,
    required this.userId,
    required this.housingType,
    required this.hasYard,
    required this.hasOtherPets,
    this.otherPetsDescription,
    required this.hasChildren,
    this.childrenCount,
    required this.experience,
    required this.workSchedule,
    required this.address,
    required this.phone,
    this.additionalInfo,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory AdoptionProfileModel.fromJson(Map<String, dynamic> json) {
    return AdoptionProfileModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? 0,
      housingType: json['housingType'] ?? 'APARTMENT',
      hasYard: json['hasYard'] ?? false,
      hasOtherPets: json['hasOtherPets'] ?? false,
      otherPetsDescription: json['otherPetsDescription'],
      hasChildren: json['hasChildren'] ?? false,
      childrenCount: json['childrenCount'],
      experience: json['experience'] ?? 'NONE',
      workSchedule: json['workSchedule'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      additionalInfo: json['additionalInfo'],
      status: json['status'] ?? 'PENDING',
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
      'userId': userId,
      'housingType': housingType,
      'hasYard': hasYard,
      'hasOtherPets': hasOtherPets,
      'otherPetsDescription': otherPetsDescription,
      'hasChildren': hasChildren,
      'childrenCount': childrenCount,
      'experience': experience,
      'workSchedule': workSchedule,
      'address': address,
      'phone': phone,
      'additionalInfo': additionalInfo,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get housingTypeRu {
    switch (housingType) {
      case 'APARTMENT':
        return 'Квартира';
      case 'HOUSE':
        return 'Дом';
      case 'OTHER':
        return 'Другое';
      default:
        return housingType;
    }
  }

  String get experienceRu {
    switch (experience) {
      case 'NONE':
        return 'Нет опыта';
      case 'SOME':
        return 'Есть опыт';
      case 'EXTENSIVE':
        return 'Большой опыт';
      default:
        return experience;
    }
  }

  String get statusRu {
    switch (status) {
      case 'PENDING':
        return 'На рассмотрении';
      case 'APPROVED':
        return 'Одобрена';
      case 'REJECTED':
        return 'Отклонена';
      default:
        return status;
    }
  }
}

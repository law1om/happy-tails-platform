class AnimalModel {
  final int id;
  final String name;
  final String species; // DOG, CAT (mapped from 'type' in backend)
  final String breed;
  final int age;
  final double weight;
  final String description;
  final String status; // AVAILABLE, RESERVED, ADOPTED
  final List<String> photos;
  final DateTime createdAt;
  final int? shelterId;
  final String? shelterName;

  AnimalModel({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    required this.weight,
    required this.description,
    required this.status,
    required this.photos,
    required this.createdAt,
    this.shelterId,
    this.shelterName,
  });

  factory AnimalModel.fromJson(Map<String, dynamic> json) {
    // Map 'type' from backend to 'species' in frontend
    String speciesValue = json['type'] ?? json['species'] ?? 'DOG';

    // Extract photo URLs from photos array
    List<String> photoUrls = [];
    if (json['photos'] != null && json['photos'] is List) {
      for (var photo in json['photos']) {
        if (photo is String) {
          photoUrls.add(photo);
        } else if (photo is Map && photo['url'] != null) {
          photoUrls.add(photo['url'].toString());
        }
      }
    }

    return AnimalModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      species: speciesValue,
      breed: json['breed'] ?? '',
      age: json['age'] ?? 0,
      weight: (json['weight'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      status: json['status']?.toString() ?? 'AVAILABLE',
      photos: photoUrls,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      shelterId: json['shelterId'],
      shelterName: json['shelterName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': species, // Map back to 'type' for backend
      'breed': breed,
      'age': age,
      'weight': weight,
      'description': description,
      'status': status,
      'photos': photos,
      'createdAt': createdAt.toIso8601String(),
      'shelterId': shelterId,
      'shelterName': shelterName,
    };
  }

  String get speciesRu {
    switch (species) {
      case 'DOG':
        return 'Собака';
      case 'CAT':
        return 'Кошка';
      default:
        return species;
    }
  }

  String get statusRu {
    switch (status) {
      case 'AVAILABLE':
        return 'Доступен';
      case 'RESERVED':
        return 'Забронирован';
      case 'ADOPTED':
        return 'Усыновлен';
      default:
        return status;
    }
  }

  // Default gender (since backend doesn't have this field yet)
  String get gender => 'MALE';

  String get genderRu => 'Самец';

  // Default health status (since backend doesn't have this field yet)
  String get healthStatus => 'Здоров, привит, стерилизован';
}

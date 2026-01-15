import 'package:sca_members_clubs/features/dining/domain/entities/restaurant.dart';

class RestaurantModel extends Restaurant {
  const RestaurantModel({
    required super.id,
    required super.name,
    required super.image,
    required super.description,
    required super.rating,
    required super.deliveryTime,
    required super.clubId,
  });

  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      description: map['description'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      deliveryTime: map['delivery_time'] ?? '',
      clubId: map['club_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'description': description,
      'rating': rating,
      'delivery_time': deliveryTime,
      'club_id': clubId,
    };
  }
}

import 'package:sca_members_clubs/features/dining/domain/entities/menu_item.dart';

class MenuItemModel extends MenuItem {
  const MenuItemModel({
    required super.id,
    required super.restaurantId,
    required super.name,
    required super.description,
    required super.price,
    required super.image,
    required super.category,
  });

  factory MenuItemModel.fromMap(Map<String, dynamic> map) {
    return MenuItemModel(
      id: map['id'] ?? '',
      restaurantId: map['restaurant_id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      image: map['image'] ?? '',
      category: map['category'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurant_id': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
      'category': category,
    };
  }
}

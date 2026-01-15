import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String image;
  final String category;

  const MenuItem({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
  });

  @override
  List<Object?> get props => [id, restaurantId, name];
}

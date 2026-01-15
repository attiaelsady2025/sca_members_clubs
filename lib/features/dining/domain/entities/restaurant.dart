import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String image;
  final String description;
  final double rating;
  final String deliveryTime;
  final String clubId;

  const Restaurant({
    required this.id,
    required this.name,
    required this.image,
    required this.description,
    required this.rating,
    required this.deliveryTime,
    required this.clubId,
  });

  @override
  List<Object?> get props => [id, name, clubId];
}

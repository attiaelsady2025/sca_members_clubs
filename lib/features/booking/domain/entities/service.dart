import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final String id;
  final String title;
  final String price;
  final String type; // 'sports', 'pool', 'gym', etc.

  const Service({
    required this.id,
    required this.title,
    required this.price,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, price, type];
}

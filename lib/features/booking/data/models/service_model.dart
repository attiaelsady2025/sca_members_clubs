import 'package:sca_members_clubs/features/booking/domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.title,
    required super.price,
    required super.type,
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      price: map['price'] ?? '',
      type: map['type'] ?? '',
    );
  }
}

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String membershipType;
  final String status;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.membershipType,
    required this.status,
  });

  @override
  List<Object?> get props => [id, name, email, role, status];
}

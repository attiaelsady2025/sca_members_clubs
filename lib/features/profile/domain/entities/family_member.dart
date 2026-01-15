import 'package:equatable/equatable.dart';

class FamilyMember extends Equatable {
  final String id;
  final String name;
  final String relation;
  final String image;
  final int age;
  final String nationalId;
  final String expiryDate;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.image,
    required this.age,
    required this.nationalId,
    required this.expiryDate,
  });

  @override
  List<Object?> get props => [id, name, relation, nationalId];
}

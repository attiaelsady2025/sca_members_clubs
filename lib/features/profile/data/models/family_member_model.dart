import 'package:sca_members_clubs/features/profile/domain/entities/family_member.dart';

class FamilyMemberModel extends FamilyMember {
  const FamilyMemberModel({
    required super.id,
    required super.name,
    required super.relation,
    required super.image,
    required super.age,
    required super.nationalId,
    required super.expiryDate,
  });

  factory FamilyMemberModel.fromMap(Map<String, dynamic> map) {
    return FamilyMemberModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      relation: map['relation'] ?? '',
      image: map['image'] ?? '',
      age: map['age'] ?? 0,
      nationalId: map['national_id'] ?? '',
      expiryDate: map['expiry_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'image': image,
      'age': age,
      'national_id': nationalId,
      'expiry_date': expiryDate,
    };
  }
}

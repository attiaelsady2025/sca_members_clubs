
import 'package:flutter/material.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import '../widgets/family_member_card.dart';

class FamilyMembersScreen extends StatelessWidget {
  const FamilyMembersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("أفراد الأسرة")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new family member logic
        },
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          FamilyMemberCard(
            name: "منى أحمد",
            relation: "زوجة",
            memberId: "12345678-01",
            imageUrl: "",
          ),
          FamilyMemberCard(
            name: "عمر أحمد",
            relation: "ابن",
            memberId: "12345678-02",
            imageUrl: "",
          ),
          FamilyMemberCard(
            name: "ليلى أحمد",
            relation: "ابنة",
            memberId: "12345678-03",
            imageUrl: "",
          ),
        ],
      ),
    );
  }
}

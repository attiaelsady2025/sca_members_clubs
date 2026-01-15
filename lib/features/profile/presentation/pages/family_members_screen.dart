import 'package:flutter/material.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/family_member_card.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _familyMembers = [
    {
      "name": "منى أحمد",
      "relation": "زوجة",
      "memberId": "12345678-01",
      "imageUrl": "",
    },
    {
      "name": "عمر أحمد",
      "relation": "ابن",
      "memberId": "12345678-02",
      "imageUrl": "",
    },
    {
      "name": "ليلى أحمد",
      "relation": "ابنة",
      "memberId": "12345678-03",
      "imageUrl": "",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Premium Sliver AppBar
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -20,
                      bottom: -20,
                      child: Icon(
                        Icons.family_restroom_rounded,
                        size: 150,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ملف الأسرة",
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "${_familyMembers.length} أفراد",
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Search and List
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: GoogleFonts.cairo(),
                      decoration: InputDecoration(
                        hintText: "ابحث عن فرد من الأسرة...",
                        hintStyle: GoogleFonts.cairo(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Section Header
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "قائمة أفراد العائلة",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Members List
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final member = _familyMembers[index];
                return FamilyMemberCard(
                  name: member["name"]!,
                  relation: member["relation"]!,
                  memberId: member["memberId"]!,
                  imageUrl: member["imageUrl"]!,
                );
              }, childCount: _familyMembers.length),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/add_family_member');
        },
        backgroundColor: AppColors.accent,
        elevation: 8,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          "إضافة فرد",
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

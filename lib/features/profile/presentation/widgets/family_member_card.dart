import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';

class FamilyMemberCard extends StatelessWidget {
  final String name;
  final String relation; // Wife, Son, Daughter
  final String memberId;
  final String imageUrl;

  const FamilyMemberCard({
    super.key,
    required this.name,
    required this.relation,
    required this.memberId,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    Color relationColor;
    IconData relationIcon;

    switch (relation.toLowerCase()) {
      case 'ابن':
        relationColor = const Color(0xFF6366F1);
        relationIcon = Icons.boy_rounded;
        break;
      case 'ابنة':
        relationColor = const Color(0xFFEC4899);
        relationIcon = Icons.girl_rounded;
        break;
      case 'زوجة':
        relationColor = const Color(0xFF8B5CF6);
        relationIcon = Icons.woman_rounded;
        break;
      default:
        relationColor = AppColors.primary;
        relationIcon = Icons.person_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Photo with Badge
                  Stack(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: relationColor.withOpacity(0.1),
                            width: 2,
                          ),
                          image: imageUrl.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(imageUrl),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imageUrl.isEmpty
                            ? Icon(
                                relationIcon,
                                color: relationColor.withOpacity(0.5),
                                size: 35,
                              )
                            : null,
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: relationColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Icon(
                            relationIcon,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                name,
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: relationColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            relation,
                            style: GoogleFonts.cairo(
                              color: relationColor,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.vignette_rounded,
                              size: 12,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              memberId,
                              style: GoogleFonts.cairo(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                                letterSpacing: 0.5,
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

            // Actions Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.background.withOpacity(0.5),
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.05)),
                ),
              ),
              child: Row(
                children: [
                  _buildQuickAction(
                    icon: Icons.qr_code_rounded,
                    label: "بطاقة العضوية",
                    color: AppColors.primary,
                    onTap: () => Navigator.pushNamed(context, '/gate_pass'),
                  ),
                  const Spacer(),
                  _buildQuickAction(
                    icon: Icons.settings_rounded,
                    label: "إدارة",
                    color: Colors.grey,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.cairo(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/features/membership/presentation/widgets/dynamic_qr_widget.dart';
import 'package:sca_members_clubs/features/profile/domain/entities/family_member.dart';

class FamilyMembershipCardScreen extends StatelessWidget {
  final FamilyMember? member;
  const FamilyMembershipCardScreen({super.key, this.member});

  @override
  Widget build(BuildContext context) {
    // Receive family member entity from arguments if not provided in constructor
    final effectiveMember =
        member ?? ModalRoute.of(context)?.settings.arguments as FamilyMember?;
    final clubName = "النادي العام لهيئة قناة السويس";

    if (effectiveMember == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0F172A),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
        body: const Center(
          child: Text(
            "خطأ في تحميل بيانات التابع",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final memberToUse = effectiveMember;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // Darker Navy
      appBar: AppBar(
        title: Text(
          "بطاقة تابع (${memberToUse.relation})",
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          children: [
            // Premium ID Card
            _buildPremiumCarnet(memberToUse, clubName),

            const SizedBox(height: 40),

            // Instructions / Info with Modern Glass Look
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  _buildInfoRow(
                    Icons.qr_code_2_rounded,
                    "هذا الكود مخصص لدخول التابع للمنشآت والنوادي التابعة للهيئة.",
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.white12, height: 1),
                  ),
                  _buildInfoRow(
                    Icons.family_restroom_rounded,
                    "يجب أن يكون التابع مرافقاً للعضو الأساسي أو يحمل تفويضاً سارياً.",
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Divider(color: Colors.white12, height: 1),
                  ),
                  _buildInfoRow(
                    Icons.info_outline_rounded,
                    "يرجى إبراز هذه البطاقة الرقمية لموظفي أمن البوابات عند الطلب.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCarnet(FamilyMember member, String clubName) {
    return AspectRatio(
      aspectRatio: 0.63,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: const LinearGradient(
            colors: [
              Color(0xFF334155),
              Color(0xFF0F172A),
            ], // Slightly different gray-navy for family
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.2),
              blurRadius: 40,
              offset: const Offset(0, 20),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // SCA Watermark (Centered & Ghosted)
            Center(
              child: Opacity(
                opacity: 0.04,
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 380,
                  color: Colors.white,
                  colorBlendMode: BlendMode.srcIn,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.anchor, size: 300, color: Colors.white),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.anchor, color: Colors.white, size: 32),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "هيئة قناة السويس",
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Suez Canal Authority",
                            style: GoogleFonts.inter(
                              color: Colors.white54,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Photo Frame
                  Container(
                    width: 120,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          spreadRadius: -5,
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child:
                        member.image.isNotEmpty &&
                            member.image.startsWith('assets')
                        ? Image.asset(member.image, fit: BoxFit.cover)
                        : const Icon(
                            Icons.person_rounded,
                            color: Colors.grey,
                            size: 80,
                          ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    member.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      height: 1.1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      member.relation,
                      style: GoogleFonts.cairo(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem("رقم التابع", member.id),
                        Container(width: 1, height: 30, color: Colors.white12),
                        _buildStatItem(
                          "تاريخ الانتهاء",
                          member.expiryDate.isNotEmpty
                              ? member.expiryDate
                              : "---",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: DynamicQrWidget(
                      memberId: member.id,
                      size: 80,
                      onlyQr: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(color: Colors.white54, fontSize: 10),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

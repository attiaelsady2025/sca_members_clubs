import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import '../widgets/dynamic_qr_widget.dart';

class GatePassScreen extends StatelessWidget {
  const GatePassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: FirebaseService().getUserProfile(),
      builder: (context, snapshot) {
        final userData = snapshot.data;
        final String memberName = userData?['name'] ?? "أحمد محمد علي";
        final String memberId = userData?['id'] ?? "12345678";
        final String memberType = userData?['membership_type'] ?? "عضو عامل";

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.primary,
          appBar: AppBar(
            title: const Text("بوابة الدخول"),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle: GoogleFonts.cairo(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 24,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Member Info Header
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.verified_user,
                              color: AppColors.success,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "تصريح دخول إلكتروني",
                              style: GoogleFonts.cairo(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 32),

                        Text(
                          memberName,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          memberType,
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Dynamic QR
                        DynamicQrWidget(memberId: memberId),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    "النادي العام لهيئة قناة السويس",
                    style: GoogleFonts.cairo(
                      color: Colors.white70,
                      fontSize: 14,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

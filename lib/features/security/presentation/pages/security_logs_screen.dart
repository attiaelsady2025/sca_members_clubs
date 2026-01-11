import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class SecurityLogsScreen extends StatelessWidget {
  const SecurityLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(
        title: "سجل الدخول اليومي",
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 15,
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Text(
                  "03:${(index * 2).toString().padLeft(2, '0')} م",
                  style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        index % 3 == 0 ? "زائر: محمود أحمد" : "عضو: عطية عبدالله",
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        index % 3 == 0 ? "عن طريق: دعوة كود" : "عن طريق: كارنيه العضوية",
                        style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Icon(
                  index % 3 == 0 ? Icons.login : Icons.badge,
                  color: Colors.grey[300],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

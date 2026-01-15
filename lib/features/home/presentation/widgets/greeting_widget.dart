import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';

class GreetingWidget extends StatelessWidget {
  final String userName;

  const GreetingWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    IconData icon;

    if (hour >= 5 && hour < 12) {
      greeting = "صباح الخير";
      icon = Icons.wb_sunny_rounded;
    } else if (hour >= 12 && hour < 17) {
      greeting = "مساء الخير";
      icon = Icons.wb_cloudy_rounded;
    } else {
      greeting = "مساء الخير";
      icon = Icons.nightlight_round;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$greeting،",
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.0,
                  ),
                ),
                Text(
                  userName,
                  style: GoogleFonts.cairo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('dd MMM', 'ar').format(DateTime.now()),
                style: GoogleFonts.cairo(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              Text(
                DateFormat('EEEE', 'ar').format(DateTime.now()),
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

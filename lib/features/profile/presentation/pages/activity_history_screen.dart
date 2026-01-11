import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';

class ActivityHistoryScreen extends StatelessWidget {
  const ActivityHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {
        "title": "تسجيل دخول ناجح",
        "time": "اليوم، 10:30 ص",
        "icon": Icons.login,
        "color": Colors.blue,
      },
      {
        "title": "حجز ملعب كرة قدم",
        "time": "أمس، 05:45 م",
        "icon": Icons.calendar_today,
        "color": Colors.green,
      },
      {
        "title": "تحديث الملف الشخصي",
        "time": "8 يناير، 12:20 م",
        "icon": Icons.person_outline,
        "color": Colors.orange,
      },
      {
        "title": "دفع فاتورة العضوية",
        "time": "1 يناير، 09:15 ص",
        "icon": Icons.payment,
        "color": Colors.purple,
      },
      {
        "title": "إرسال شكوى",
        "time": "25 ديسمبر، 02:10 م",
        "icon": Icons.message_outlined,
        "color": Colors.red,
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("سجل النشاطات"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: activities.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = activities[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: item['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(item['icon'], color: item['color'], size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title'],
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        item['time'],
                        style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          );
        },
      ),
    );
  }
}

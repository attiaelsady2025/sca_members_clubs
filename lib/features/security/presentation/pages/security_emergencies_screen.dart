import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class SecurityEmergenciesScreen extends StatelessWidget {
  const SecurityEmergenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(
        title: "بلاغات الطوارئ SOS",
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildEmergencyAlert(
            memberName: "عطية عبدالله",
            location: "منطقة حمام السباحة",
            time: "منذ دقيقتين",
            type: "طبي",
          ),
          _buildEmergencyAlert(
            memberName: "محمود يحيى",
            location: "المبنى الاجتماعي - الدور الأول",
            time: "منذ 15 دقيقة",
            type: "أمني",
            isResolved: true,
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyAlert({
    required String memberName,
    required String location,
    required String time,
    required String type,
    bool isResolved = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isResolved ? Colors.transparent : Colors.red.withOpacity(0.3), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isResolved ? Colors.grey[100] : Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    type == "طبي" ? Icons.medical_services : Icons.security,
                    color: isResolved ? Colors.grey : Colors.red,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memberName,
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        location,
                        style: GoogleFonts.cairo(color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.blue),
                    const SizedBox(width: 4),
                    Text(
                      "فتح الموقع على الخريطة",
                      style: GoogleFonts.cairo(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                if (!isResolved)
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(
                      "توجيه فريق",
                      style: GoogleFonts.cairo(color: Colors.white, fontSize: 12),
                    ),
                  )
                else
                  Text(
                    "تمت الاستجابة",
                    style: GoogleFonts.cairo(color: Colors.green, fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

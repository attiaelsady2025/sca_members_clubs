import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ScaAppBar(
        title: "الطوارئ SOS",
        foregroundColor: AppColors.error,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Pulsing Alert Icon
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.15),
                        blurRadius: 30,
                        spreadRadius: 15,
                      ),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.emergency,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Text(
                "هل تحتاج إلى مساعدة عاجلة؟",
                style: GoogleFonts.cairo(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "خدمة المساعدة السريعة متاحة 24/7 لأعضاء هيئة قناة السويس",
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 50),

              // Security Call Button
              _buildEmergencyButton(
                context,
                label: "اتصال بأمن النادي",
                icon: Icons.security,
                color: const Color(0xFF003A8F),
                description: "للبلاغات الأمنية داخل حرم النادي",
                onTap: () {
                  _showCallDialog(context, "أمن النادي", "01000000001");
                },
              ),
              const SizedBox(height: 16),

              // Ambulance Call Button
              _buildEmergencyButton(
                context,
                label: "طلب الإسعاف",
                icon: Icons.medical_services,
                color: AppColors.error,
                description: "للحالات الطبية المستعجلة",
                onTap: () {
                  _showCallDialog(context, "الإسعاف", "123");
                },
              ),

              const SizedBox(height: 40),

              // Location Info
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.my_location, color: Colors.blue),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "موقعك الحالي التقريبي",
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            "النادي الاجتماعي - منطقة حمام السباحة",
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required String description,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: color.withOpacity(0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withOpacity(0.05), width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      description,
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: color.withOpacity(0.3),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCallDialog(BuildContext context, String name, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "تأكيد الاتصال",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "هل أنت متأكد من الاتصال بـ $name؟\n($number)",
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            onPressed: () {
              Navigator.pop(context);
              // In real app: launchUrl("tel:$number")
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("جاري الاتصال...", style: GoogleFonts.cairo()),
                ),
              );
            },
            child: Text("اتصال", style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
}

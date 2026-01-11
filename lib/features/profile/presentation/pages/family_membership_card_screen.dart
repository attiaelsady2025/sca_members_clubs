import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/features/membership/presentation/widgets/dynamic_qr_widget.dart';

class FamilyMembershipCardScreen extends StatefulWidget {
  const FamilyMembershipCardScreen({super.key});

  @override
  State<FamilyMembershipCardScreen> createState() => _FamilyMembershipCardScreenState();
}

class _FamilyMembershipCardScreenState extends State<FamilyMembershipCardScreen> {
  @override
  Widget build(BuildContext context) {
    // Receive family member data from arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ?? {};
    final member = args['member'] as Map<String, dynamic>? ?? args; // Handle both direct member and wrapped args
    final clubName = args['clubName'] as String? ?? "نادي هيئة قناة السويس";

    final Color clubColor = AppColors.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text("كارنيه تابع (${member['relation'] ?? 'قريب'})"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          children: [
            // The ID Card
            _buildCarnet(context, member, clubName, clubColor),
            
            const SizedBox(height: 32),

            // Report Lost Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showReportLostDialog(context, member['name'] ?? "العضو"),
                icon: const Icon(Icons.report_problem_outlined, size: 18),
                label: Text("إبلاغ عن فقدان الكارنيه", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: const BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 32),
            
            // Instructions / Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildInfoRow(Icons.qr_code_scanner, "هذا الكود مخصص لدخول التابع للمنشآت المسموح بها"),
                  const Divider(height: 32),
                  _buildInfoRow(Icons.family_restroom, "هذا الكارنيه مخصص لدرجة القرابة الموضحة"),
                  const Divider(height: 32),
                  _buildInfoRow(Icons.verified_user, "يجب إبراز هذا الكارنيه عند الطلب من أمن النادي"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReportLostDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "إبلاغ عن فقدان",
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.error),
        ),
        content: Text(
          "هل أنت متأكد من الإبلاغ عن فقدان كارنيه ($name)؟ سيتم إيقاف فاعلية الكود الرقمي فوراً.",
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleReportSuccess();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("تأكيد الإبلاغ", style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleReportSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تم تسجيل البلاغ بنجاح. يرجى مراجعة إدارة شؤون العضوية.",
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Widget _buildCarnet(BuildContext context, Map<String, dynamic> member, String clubName, Color color) {
    return AspectRatio(
      aspectRatio: 0.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [color.withBlue(100), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // Watermark Mesh Pattern
            Opacity(
              opacity: 0.12,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
                itemBuilder: (context, index) => const Icon(Icons.anchor, color: Colors.white, size: 50),
              ),
            ),
            
            // Glossy Overlay
            Positioned(
              top: -150,
              right: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [Colors.white.withOpacity(0.2), Colors.transparent],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  // Upper Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.anchor, color: Colors.white, size: 28),
                              const SizedBox(width: 8),
                              Text(
                                "هيئة قناة السويس",
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            clubName.replaceAll(RegExp(r'\(.*\)'), '').trim(),
                            style: GoogleFonts.cairo(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      // Smart Chip Icon
                      Container(
                        width: 48,
                        height: 38,
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [Colors.amber[300]!, Colors.amber[700]!],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(Icons.memory, color: Colors.amber[100], size: 22),
                      ),
                    ],
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // Profile Photo
                  Container(
                    width: 130,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                      image: DecorationImage(
                        image: (member['image'] != null && member['image'] is String && (member['image'] as String).startsWith('assets')) 
                          ? AssetImage(member['image']) as ImageProvider
                          : const AssetImage('assets/images/user_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // User Data
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "كارنيه عائلي (${member['relation'] ?? 'تابع'})",
                          style: GoogleFonts.cairo(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        member['name'] ?? "غير معروف",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildVerticalCardData("رقم العضوية", member['id'] ?? "---"),
                      _buildVerticalCardData("صالح حتى", member['expiry_date'] ?? "12/2026"),
                    ],
                  ),
                  
                  const Spacer(flex: 2),
                  
                  // QR Code
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: DynamicQrWidget(memberId: member['id'] ?? "0000", size: 90, onlyQr: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalCardData(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$label: ",
            style: GoogleFonts.cairo(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ],
      ),
    );
  }
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(
              fontSize: 14, 
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("المساعدة والدعم"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Contact Channels
            Text(
              "تواصل معنا",
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildContactCard(Icons.phone, "اتصل بنا", Colors.blue),
                const SizedBox(width: 16),
                _buildContactCard(Icons.message, "واتساب", Colors.green),
              ],
            ),
            const SizedBox(height: 16),
            _buildContactCard(Icons.email, "البريد الإلكتروني", Colors.red, isFullWidth: true),
            
            const SizedBox(height: 40),
            
            // FAQ Section
            Text(
              "الأسئلة الشائعة",
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFaqItem("كيف يمكنني تجديد العضوية؟", "يمكنك التجديد من خلال قسم المدفوعات في التطبيق أو زيارة مقر النادي."),
            _buildFaqItem("ما هي مواعيد عمل النادي؟", "النادي مفتوح يومياً من الساعة 8 صباحاً وحتى 11 مساءً."),
            _buildFaqItem("هل يمكنني إضافة أفراد جدد للأسرة؟", "نعم، من خلال ملفك الشخصي > أفراد الأسرة > إضافة فرد جديد."),
            _buildFaqItem("كيف أقوم بحجز ملعب؟", "من الشاشة الرئيسية اختر 'حجز الخدمات' ثم حدد الملعب والوقت المتاح."),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String label, Color color, {bool isFullWidth = false}) {
    final card = Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
        ],
      ),
    );

    return isFullWidth 
      ? SizedBox(width: double.infinity, child: card) 
      : Expanded(child: card);
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }
}

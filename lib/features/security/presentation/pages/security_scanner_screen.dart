import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class SecurityScannerScreen extends StatefulWidget {
  const SecurityScannerScreen({super.key});

  @override
  State<SecurityScannerScreen> createState() => _SecurityScannerScreenState();
}

class _SecurityScannerScreenState extends State<SecurityScannerScreen> {
  bool _isScanning = false;

  void _simulateScan(String type) {
    setState(() => _isScanning = true);
    
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _isScanning = false);
      
      _showResultDialog(
        success: type != 'invalid',
        title: type == 'invitation' ? "دعوة صالحة" : (type == 'member' ? "عضوية صالحة" : "كود غير صالح"),
        subtitle: type == 'invitation' ? "الزائر: محمود أحمد\nتاريخ اليوم: 10/01/2026" : "العضو: عطية عبدالله\nرقم العضوية: 12345678",
      );
    });
  }

  void _showResultDialog({required bool success, required String title, required String subtitle}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: success ? Colors.green[50] : Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                success ? Icons.check_circle : Icons.error,
                color: success ? Colors.green : Colors.red,
                size: 80,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.cairo(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: success ? Colors.green[800] : Colors.red[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: success ? Colors.green : Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "تم",
                  style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: const ScaAppBar(
        title: "ماسح بوابة الدخول",
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Scanner Simulation View
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Stack(
                    children: [
                      // Animated scanning line
                      if (_isScanning)
                        TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0, end: 260),
                          duration: const Duration(seconds: 2),
                          builder: (context, value, child) {
                            return Positioned(
                              top: value + 10,
                              left: 10,
                              right: 10,
                              child: Container(
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Colors.greenAccent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.greenAccent.withOpacity(0.5),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      Center(
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 150,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Text(
                  _isScanning ? "جاري المسح..." : "وجه الكاميرا نحو الكود QR",
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
          
          // Test Buttons (Since we are in simulator)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildTestButton("مسح عضوية", Colors.blue, () => _simulateScan('member')),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTestButton("مسح دعوة", Colors.green, () => _simulateScan('invitation')),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTestButton("اختبار كود خطأ", Colors.red, () => _simulateScan('invalid')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(String label, Color color, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: _isScanning ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(
        label,
        style: GoogleFonts.cairo(color: Colors.white, fontSize: 13),
      ),
    );
  }
}

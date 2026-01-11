
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';

class DynamicQrWidget extends StatefulWidget {
  final String memberId;
  final double size;
  final bool onlyQr;

  const DynamicQrWidget({
    super.key, 
    required this.memberId, 
    this.size = 200, 
    this.onlyQr = false,
  });

  @override
  State<DynamicQrWidget> createState() => _DynamicQrWidgetState();
}

class _DynamicQrWidgetState extends State<DynamicQrWidget> {
  late String _qrData;
  late Timer _timer;
  int _secondsRemaining = 30;
  double _progress = 1.0;

  @override
  void initState() {
    super.initState();
    _generateQrData();
    _startTimer();
  }

  void _generateQrData() {
    // In a real app, this would generate a secure token from backend or encryption logic
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    _qrData = "${widget.memberId}_$timestamp";
    setState(() {});
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          _progress = _secondsRemaining / 30;
        } else {
          _secondsRemaining = 30;
          _progress = 1.0;
          _generateQrData();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onlyQr) {
      return QrImageView(
        data: _qrData,
        version: QrVersions.auto,
        size: widget.size,
        backgroundColor: Colors.white,
        errorStateBuilder: (cxt, err) => const Icon(Icons.error),
      );
    }

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Circular Progress Indicator for Timeout
            SizedBox(
              width: widget.size + 80,
              height: widget.size + 80,
              child: CircularProgressIndicator(
                value: _progress,
                color: _progress < 0.2 ? AppColors.error : AppColors.primary,
                backgroundColor: Colors.grey[200],
                strokeWidth: 8,
              ),
            ),
            // QR Code
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                  )
                ],
              ),
              child: QrImageView(
                data: _qrData,
                version: QrVersions.auto,
                size: widget.size,
                backgroundColor: Colors.white,
                embeddedImage: const AssetImage('assets/images/logo_placeholder.png'), // Placeholder
                embeddedImageStyle: const QrEmbeddedImageStyle(
                  size: Size(40, 40),
                ),
                errorStateBuilder: (cxt, err) {
                  return const Center(
                    child: Text(
                      "خطأ في إنشاء الرمز",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          "يتغير الرمز تلقائياً خلال $_secondsRemaining ثانية",
          style: GoogleFonts.cairo(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "يرجى تقديم هذا الرمز لموظف البوابة",
          style: GoogleFonts.cairo(
            color: AppColors.textPrimary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

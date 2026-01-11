
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:sca_members_clubs/core/widgets/custom_text_field.dart';

class AdminBroadcastScreen extends StatefulWidget {
  const AdminBroadcastScreen({super.key});

  @override
  State<AdminBroadcastScreen> createState() => _AdminBroadcastScreenState();
}

class _AdminBroadcastScreenState extends State<AdminBroadcastScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  String? _targetClub;
  bool _isSending = false;
  Map<String, dynamic>? _adminProfile;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await FirebaseService().getUserProfile();
    setState(() {
      _adminProfile = profile;
      if (profile['club_id'] != "global") {
        _targetClub = profile['club_id'];
      }
    });
  }

  Future<void> _sendBroadcast() async {
    if (_titleController.text.isEmpty || _messageController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("يرجى ملء جميع الحقول")));
      return;
    }

    setState(() => _isSending = true);
    await FirebaseService().sendBroadcastNotification(
      _titleController.text,
      _messageController.text,
      targetClubId: _targetClub,
    );
    setState(() => _isSending = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم إرسال الإشعار بنجاح")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isGlobal = _adminProfile?['club_id'] == "global";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "بث إشعار جديد"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "سيصل هذا الإشعار بشكل فوري لجميع المستخدمين في النطاق المحدد.",
                      style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: "عنوان الإشعار",
              controller: _titleController,
              hint: "مثلاً: تحديث هام بشأن الملاعب",
              prefixIcon: Icons.title,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              label: "نص الإشعار",
              controller: _messageController,
              hint: "اكتب تفاصيل الإشعار هنا...",
              prefixIcon: Icons.message,
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            if (isGlobal) ...[
              Text("الجمهور المستهدف", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _buildTargetSelector(),
              const SizedBox(height: 24),
            ],
            PrimaryButton(
              text: "إرسال الإشعار الآن",
              onPressed: _sendBroadcast,
              isLoading: _isSending,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTargetSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _targetClub,
          hint: Text("كافة الأعضاء (عام)", style: GoogleFonts.cairo(fontSize: 14)),
          isExpanded: true,
          onChanged: (val) => setState(() => _targetClub = val),
          items: [
            const DropdownMenuItem(value: null, child: Text("كافة الأعضاء (على مستوى الهيئة)")),
            const DropdownMenuItem(value: "c1", child: Text("أعضاء نادي التجديف فقط")),
            const DropdownMenuItem(value: "c2", child: Text("أعضاء نادي الفيروز فقط")),
          ],
        ),
      ),
    );
  }
}

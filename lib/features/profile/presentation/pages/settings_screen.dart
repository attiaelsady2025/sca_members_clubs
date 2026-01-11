import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = "العربية";

  void _showLanguageSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "اختر اللغة / Select Language",
                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildLanguageItem("العربية", "Arabic", _selectedLanguage == "العربية"),
              _buildLanguageItem("English", "الإنجليزية", _selectedLanguage == "English"),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageItem(String lang, String sub, bool isSelected) {
    return ListTile(
      title: Text(lang, style: GoogleFonts.cairo(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      subtitle: Text(sub, style: GoogleFonts.cairo(fontSize: 12)),
      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
      onTap: () {
        setState(() {
          _selectedLanguage = lang;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم تغيير اللغة إلى $lang (محاكاة)", style: GoogleFonts.cairo()),
            backgroundColor: AppColors.primary,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("الإعدادات"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "العامة",
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildToggleItem(
                Icons.notifications_active_outlined,
                "التنبيهات",
                "تفعيل إشعارات التطبيق",
                _notificationsEnabled,
                (val) => setState(() => _notificationsEnabled = val),
              ),
              _buildNavigationItem(
                Icons.language,
                "لغة التطبيق",
                _selectedLanguage,
                _showLanguageSelector,
              ),
            ]),
            
            const SizedBox(height: 32),
            
            Text(
              "الحساب والأمان",
              style: GoogleFonts.cairo(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingsCard([
              _buildNavigationItem(
                Icons.lock_outline,
                "تغيير كلمة المرور",
                null,
                () => Navigator.pushNamed(context, '/change_password'),
              ),
              _buildNavigationItem(
                Icons.privacy_tip_outlined,
                "سياسة الخصوصية",
                null,
                () {},
              ),
              _buildNavigationItem(
                Icons.info_outline,
                "عن التطبيق",
                "الإصدار 1.0.0",
                () {},
                showDivider: false,
              ),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildToggleItem(IconData icon, String title, String subtitle, bool value, Function(bool) onChanged) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
          subtitle: Text(subtitle, style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
          trailing: Switch.adaptive(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 56),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
      ],
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, String? value, VoidCallback onTap, {bool showDivider = true}) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (value != null)
                Text(value, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
        if (showDivider)
          const Padding(
            padding: EdgeInsets.only(right: 56),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),
      ],
    );
  }
}

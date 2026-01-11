import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/services/permission_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: FirebaseService().getUserProfile(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              if (user != null) {
                PermissionService().setRole(user['role'] ?? 'member');
              }
              final isLoading = snapshot.connectionState == ConnectionState.waiting;
              final isSecurity = PermissionService().role == UserRole.security;
              final name = user?['name'] ?? "جاري التحميل...";
              final membershipType = isSecurity ? "قطاع الأمن" : (user?['membership_type'] ?? "");
              final memberId = user?['id'] ?? "---";
              final nationalId = user?['national_id'] ?? "---";
              final workNumber = user?['work_number'] ?? "---";
              final department = user?['department'] ?? "---";
              final expiryDate = user?['expiry_date'] ?? "---";

              return Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            backgroundColor: AppColors.background,
                            radius: 35,
                            child: isLoading 
                              ? const CircularProgressIndicator()
                              : Icon(
                                  isSecurity ? Icons.admin_panel_settings : Icons.person,
                                  color: AppColors.primary,
                                  size: 40,
                                ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (membershipType.isNotEmpty)
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        membershipType,
                                        style: GoogleFonts.cairo(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                    if (!isSecurity) ...[
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, '/family_members');
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(Icons.people_outline, size: 14, color: AppColors.primary),
                                              const SizedBox(width: 4),
                                              Text(
                                                "أسرتي",
                                                style: GoogleFonts.cairo(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildHeaderInfo(isSecurity ? "كود الموظف" : "رقم العضوية", memberId)),
                              Container(width: 1, height: 30, color: Colors.white24),
                              Expanded(child: _buildHeaderInfo("الرقم القومي", nationalId)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Divider(color: Colors.white24, height: 1),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _buildHeaderInfo(isSecurity ? "جهة العمل" : "رقم العمل", isSecurity ? "نادي التجديف" : workNumber)),
                              Container(width: 1, height: 30, color: Colors.white24),
                              Expanded(child: _buildHeaderInfo(isSecurity ? "حالة العمل" : "الإدارة", isSecurity ? "مناوب حالياً" : department)),
                            ],
                          ),
                          if (!isSecurity) ...[
                            const SizedBox(height: 12),
                            const Divider(color: Colors.white24, height: 1),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(child: _buildHeaderInfo("تاريخ الانتهاء", expiryDate)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                if (PermissionService().role == UserRole.security) ...[
                  _buildDrawerItem(Icons.dashboard, "لوحة تحكم الأمن", () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/security_dashboard');
                  }),
                  _buildDrawerItem(Icons.qr_code_scanner, "ماسح البوابة", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/security_scanner');
                  }),
                  _buildDrawerItem(Icons.list_alt, "التحقق من الدعوات", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/security_invitations');
                  }),
                  _buildDrawerItem(Icons.emergency, "بلاغات الطوارئ", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/security_emergencies');
                  }),
                  _buildDrawerItem(Icons.history, "سجل الدخول", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/security_logs');
                  }),
                ] else ...[
                  _buildDrawerItem(Icons.home, "الرئيسية", () => Navigator.pop(context)),
                  if (PermissionService().role == UserRole.admin)
                  _buildDrawerItem(Icons.admin_panel_settings, "لوحة التحكم (للإدارة)", () {
                    Navigator.pop(context);
                    // Navigation to admin screen
                  }),
                  _buildDrawerItem(Icons.qr_code, "بوابة الدخول (QR)", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/gate_pass');
                  }),
                  _buildDrawerItem(Icons.card_membership, "دعوات الزوار", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/invitations');
                  }),
                  _buildDrawerItem(Icons.person, "حسابي", () {
                    Navigator.pop(context); // Close drawer
                    Navigator.pushNamed(context, '/profile');
                  }),
                  _buildDrawerItem(Icons.swap_horiz, "تغيير النادي", () {
                    Navigator.pushNamedAndRemoveUntil(context, '/clubs', (route) => false);
                  }),
                  _buildDrawerItem(Icons.calendar_month, "حجوزاتي", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/booking');
                  }),
                  _buildDrawerItem(Icons.history, "سجل الدفع", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/payments');
                  }),
                  const Divider(),
                  _buildDrawerItem(Icons.settings, "الإعدادات", () {}),
                  _buildDrawerItem(Icons.support_agent, "الشكاوى والمقترحات", () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/complaints');
                  }),
                ],
                _buildDrawerItem(Icons.logout, "تسجيل الخروج", () {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                }, isDestructive: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "الإصدار 1.0.0",
              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AppColors.error : AppColors.primary),
      title: Text(
        title,
        style: GoogleFonts.cairo(
          color: isDestructive ? AppColors.error : AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  Widget _buildHeaderInfo(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

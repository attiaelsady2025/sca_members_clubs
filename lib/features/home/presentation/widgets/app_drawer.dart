import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/services/permission_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/navigation_cubit.dart';
import 'package:sca_members_clubs/core/routes/app_routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          bottomLeft: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          _buildPremiumHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 12),
              children: [_buildMenuSection(context)],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader() {
    return FutureBuilder<Map<String, dynamic>>(
      future: FirebaseService().getUserProfile(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user != null) {
          PermissionService().setRole(user['role'] ?? 'member');
        }
        final isLoading = snapshot.connectionState == ConnectionState.waiting;
        final isSecurity = PermissionService().role == UserRole.security;

        final name = user?['name'] ?? "جاري التحميل...";
        final membershipType = isSecurity
            ? "قطاع الأمن"
            : (user?['membership_type'] ?? "عضو عامل");
        final memberId = user?['id'] ?? "---";
        final workNumber = user?['work_number'] ?? "---";
        final department = user?['department'] ?? "---";
        final jobTitle = user?['job_title'] ?? "---";

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      radius: 28,
                      backgroundColor: Colors.white,
                      child: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              isSecurity
                                  ? Icons.admin_panel_settings
                                  : Icons.person_rounded,
                              color: AppColors.primary,
                              size: 32,
                            ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, Routes.familyMembers);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.family_restroom_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "أسرتي",
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  membershipType,
                  style: GoogleFonts.cairo(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Structured Table Container
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildHeaderStat("رقم العضوية", memberId),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildHeaderStat("رقم العمل", workNumber),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Divider(
                        color: Colors.white.withOpacity(0.05),
                        height: 1,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildHeaderStat("الإدارة", department),
                        ),
                        Container(
                          width: 1,
                          height: 24,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _buildHeaderStat("الوظيفة", jobTitle)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            color: Colors.white.withOpacity(0.6),
            fontSize: 9,
            height: 1.1,
          ),
        ),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final role = PermissionService().role;

    if (role == UserRole.security) {
      return Column(
        children: [
          _buildDrawerItem(Icons.dashboard_rounded, "لوحة تحكم الأمن", () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, Routes.securityDashboard);
          }),
          _buildDrawerItem(Icons.qr_code_scanner_rounded, "ماسح البوابة", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.securityScanner);
          }),
          _buildDrawerItem(Icons.list_alt_rounded, "التحقق من الدعوات", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.securityInvitations);
          }),
          _buildDrawerItem(Icons.emergency_rounded, "بلاغات الطوارئ", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.securityEmergencies);
          }),
          _buildDrawerItem(Icons.history_rounded, "سجل الدخول", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, Routes.securityLogs);
          }),
          const _DrawerDivider(),
          _buildDrawerItem(Icons.logout_rounded, "تسجيل الخروج", () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.login,
              (route) => false,
            );
          }, isDestructive: true),
        ],
      );
    }

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Column(
          children: [
            _buildDrawerItem(Icons.home_rounded, "الرئيسية", () {
              Navigator.pop(context);
              context.read<NavigationCubit>().setTab(0);
            }, isSelected: currentIndex == 0),
            _buildDrawerItem(Icons.card_membership_rounded, "دعوات الزوار", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.invitations);
            }),
            _buildDrawerItem(Icons.calendar_today_rounded, "حجوزاتي", () {
              Navigator.pop(context);
              context.read<NavigationCubit>().setTab(1);
            }, isSelected: currentIndex == 1),
            _buildDrawerItem(Icons.payments_rounded, "سجل المدفوعات", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.payments);
            }),
            const _DrawerDivider(),
            _buildDrawerItem(Icons.person_rounded, "ملف العضو", () {
              Navigator.pop(context);
              context.read<NavigationCubit>().setTab(2);
            }, isSelected: currentIndex == 2),
            _buildDrawerItem(
              Icons.family_restroom_rounded,
              "إدارة أفراد الأسرة",
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.familyMembers);
              },
            ),
            const _DrawerDivider(),
            _buildDrawerItem(
              Icons.support_agent_rounded,
              "الشكاوى والمقترحات",
              () {
                Navigator.pop(context);
                Navigator.pushNamed(context, Routes.complaints);
              },
            ),
            _buildDrawerItem(Icons.settings_rounded, "الإعدادات", () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.settings);
            }),
            const _DrawerDivider(),
            _buildDrawerItem(Icons.logout_rounded, "تسجيل الخروج", () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.login,
                (route) => false,
              );
            }, isDestructive: true),
          ],
        );
      },
    );
  }

  Widget _buildDrawerItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
    bool isSelected = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        onTap: onTap,
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: isSelected
            ? AppColors.primary.withOpacity(0.08)
            : Colors.transparent,
        leading: Icon(
          icon,
          color: isDestructive
              ? AppColors.error
              : (isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary.withOpacity(0.7)),
          size: 22,
        ),
        title: Text(
          title,
          style: GoogleFonts.cairo(
            color: isDestructive
                ? AppColors.error
                : (isSelected ? AppColors.primary : AppColors.textPrimary),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
        trailing: isSelected
            ? Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
      child: Column(
        children: [
          const Divider(),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 14, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                "الإصدار 1.2.0",
                style: GoogleFonts.cairo(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "هيئة قناة السويس © 2026",
            style: GoogleFonts.cairo(
              color: Colors.grey.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  const _DrawerDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Divider(height: 1, thickness: 0.5),
    );
  }
}

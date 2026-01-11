
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic>? _adminProfile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await FirebaseService().getUserProfile();
    setState(() {
      _adminProfile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    final isGlobal = _adminProfile?['club_id'] == "global";
    final clubName = isGlobal ? "مدير النظام" : "مدير النادي";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ScaAppBar(title: "لوحة تحكم $clubName"),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildStatsOverview(),
            const SizedBox(height: 32),
            _buildSectionTitle("التحكم والعمليات - ${isGlobal ? "كافة النوادي" : "نطاق النادي"}"),
            const SizedBox(height: 16),
            _buildAdminMenu(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isGlobal = _adminProfile?['club_id'] == "global";
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isGlobal 
              ? [AppColors.primary, const Color(0xFF003A8F)]
              : [AppColors.secondary, AppColors.secondary.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: (isGlobal ? AppColors.primary : AppColors.secondary).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(
              isGlobal ? Icons.admin_panel_settings : Icons.location_city, 
              color: Colors.white, 
              size: 35
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _adminProfile?['name'] ?? "أدمن الهيئة",
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  isGlobal ? "صلاحيات كاملة على النظام" : "إدارة مرافق النادي التابع له",
                  style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      children: [
        _buildStatCard("الزوار اليوم", "124", Icons.people, Colors.blue),
        const SizedBox(width: 12),
        _buildStatCard("حجوزات نشطة", "45", Icons.calendar_today, Colors.green),
        const SizedBox(width: 12),
        _buildStatCard("شكاوى مفتوحة", "8", Icons.report_problem, Colors.orange),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Text(label, textAlign: TextAlign.center, style: GoogleFonts.cairo(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
    );
  }

  Widget _buildAdminMenu() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildMenuCard("إدارة الأعضاء", Icons.manage_accounts, Colors.indigo, () {
          Navigator.pushNamed(context, '/admin_members');
        }),
        _buildMenuCard("طلبات الكروت", Icons.card_giftcard, Colors.amber[700]!, () {
          Navigator.pushNamed(context, '/admin_invitations');
        }),
        _buildMenuCard("الأخبار والفعاليات", Icons.newspaper, Colors.purple, () {
          Navigator.pushNamed(context, '/admin_content');
        }),
        _buildMenuCard("إدارة الملاعب", Icons.sports_tennis, Colors.teal, () {
          Navigator.pushNamed(context, '/admin_booking');
        }),
        _buildMenuCard("الشكاوى", Icons.message, Colors.redAccent, () {
          Navigator.pushNamed(context, '/admin_complaints');
        }),
        _buildMenuCard("بث إشعار", Icons.podcasts, Colors.deepPurple, () {
          Navigator.pushNamed(context, '/admin_broadcast');
        }),
        _buildMenuCard("الإحصائيات", Icons.analytics, Colors.blueGrey, () {
           Navigator.pushNamed(context, '/admin_analytics');
        }),
        _buildMenuCard("طاقم العمل", Icons.groups, Colors.brown, () {
           Navigator.pushNamed(context, '/admin_staff');
        }),
        _buildMenuCard("مركز المراجعة", Icons.verified_user, Colors.green, () {
           Navigator.pushNamed(context, '/admin_verification');
        }),
        _buildMenuCard("سجل الحركات", Icons.history_edu, Colors.blueGrey, () {
           Navigator.pushNamed(context, '/admin_logs');
        }),
        _buildMenuCard("ورديات الأمن", Icons.shield, Colors.indigo, () {
           Navigator.pushNamed(context, '/admin_shifts');
        }),
        _buildMenuCard("ضيوف رسميين", Icons.stars, Colors.amber, () {
           Navigator.pushNamed(context, '/admin_official_guests');
        }),
        _buildMenuCard("إدارة المستخدمين", Icons.people_alt, Colors.deepOrange, () {
           Navigator.pushNamed(context, '/admin_users');
        }),
      ],
    );
  }

  Widget _buildMenuCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final isGlobal = _adminProfile?['club_id'] == "global";
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isGlobal 
                    ? [AppColors.primary, const Color(0xFF003A8F)]
                    : [AppColors.secondary, AppColors.secondary.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    isGlobal ? Icons.admin_panel_settings : Icons.location_city,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _adminProfile?['name'] ?? "المدير",
                  style: GoogleFonts.cairo(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  isGlobal ? "مدير النظام" : "مدير النادي",
                  style: GoogleFonts.cairo(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.dashboard, "لوحة التحكم", () {
            Navigator.pop(context);
          }),
          _buildDrawerItem(Icons.manage_accounts, "إدارة الأعضاء", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_members');
          }),
          _buildDrawerItem(Icons.analytics, "الإحصائيات", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_analytics');
          }),
          _buildDrawerItem(Icons.history_edu, "سجل النشاط", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_logs');
          }),
          _buildDrawerItem(Icons.people_alt, "إدارة المستخدمين", () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/admin_users');
          }),
          const Divider(),
          _buildDrawerItem(Icons.logout, "تسجيل الخروج", () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: GoogleFonts.cairo(color: color ?? AppColors.textPrimary)),
      onTap: onTap,
    );
  }
}

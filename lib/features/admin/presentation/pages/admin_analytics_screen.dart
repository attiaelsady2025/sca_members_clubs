
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
  late Future<Map<String, dynamic>> _analyticsFuture;
  Map<String, dynamic>? _adminProfile;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await FirebaseService().getUserProfile();
    _adminProfile = profile;
    _analyticsFuture = FirebaseService().getAnalyticsData(clubId: profile['club_id']);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "الإحصائيات والتقارير"),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _analyticsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final data = snapshot.data!;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickStats(data),
                const SizedBox(height: 24),
                _buildSectionTitle("نشاط الزوار شهرياً"),
                const SizedBox(height: 12),
                _buildActivityChart(data['monthly_activity']),
                const SizedBox(height: 24),
                _buildSectionTitle("توزيع فئات العضوية"),
                const SizedBox(height: 12),
                _buildMembershipPie(data['membership_distribution']),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats(Map<String, dynamic> data) {
    return Row(
      children: [
        Expanded(child: _buildStatCard("زوار اليوم", data['visitors_today'].toString(), Icons.people, Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard("إيرادات الشهر", data['revenue_this_month'], Icons.monetization_on, Colors.green)),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildActivityChart(List<dynamic> points) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: points.map((p) {
          double height = (p as int).toDouble();
          return Container(
            width: 20,
            height: height,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.6),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMembershipPie(List<dynamic> distribution) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: distribution.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Container(width: 12, height: 12, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle)),
                const SizedBox(width: 12),
                Text(item['label'], style: GoogleFonts.cairo(fontSize: 13)),
                const Spacer(),
                Text("${item['value']}%", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 15));
  }
}

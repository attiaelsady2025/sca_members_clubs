import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class ActivitiesScheduleScreen extends StatefulWidget {
  const ActivitiesScheduleScreen({super.key});

  @override
  State<ActivitiesScheduleScreen> createState() =>
      _ActivitiesScheduleScreenState();
}

class _ActivitiesScheduleScreenState extends State<ActivitiesScheduleScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _activitiesFuture;
  late TabController _tabController;
  String? _clubId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clubId = ModalRoute.of(context)?.settings.arguments as String?;
    _activitiesFuture = FirebaseService().getActivities(clubId: _clubId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("مواعيد الأنشطة"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: "الرياضية"),
            Tab(text: "الثقافية والفنية"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildActivityList("sports"), _buildActivityList("arts")],
      ),
    );
  }

  Widget _buildActivityList(String category) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _activitiesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final allActivities = snapshot.data ?? [];
        final activities = allActivities
            .where((a) => a['category'] == category)
            .toList();

        if (activities.isEmpty) {
          return Center(
            child: Text("لا توجد أنشطة متاحة", style: GoogleFonts.cairo()),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: activities.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Container(
              padding: const EdgeInsets.all(16),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        activity['name'],
                        style: GoogleFonts.cairo(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Icon(
                        Icons.sports_handball,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow(
                    Icons.calendar_today,
                    activity['days'].join(" - "),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.access_time, activity['time']),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, activity['location']),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.person, "المدرب: ${activity['coach']}"),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () =>
                          _showSubscriptionDialog(context, activity),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "طلب اشتراك",
                        style: GoogleFonts.cairo(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSubscriptionDialog(
    BuildContext context,
    Map<String, dynamic> activity,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "تأكيد طلب الاشتراك",
          textAlign: TextAlign.center,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "هل ترغب في الاشتراك في ${activity['name']}؟",
              style: GoogleFonts.cairo(),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.person, "المدرب", activity['coach']),
            const SizedBox(height: 8),
            _buildDetailRow(Icons.location_on, "المكان", activity['location']),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _handleSubscriptionSubmit(activity['name']);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text("تأكيد", style: GoogleFonts.cairo(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _handleSubscriptionSubmit(String activityName) {
    // Simulate network delay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم إرسال طلب الاشتراك في $activityName بنجاح. سيتم التواصل معك قريباً.",
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          "$label: ",
          style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13),
        ),
        Text(
          value,
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }
}

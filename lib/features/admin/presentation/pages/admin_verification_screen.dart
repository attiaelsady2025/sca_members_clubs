
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class AdminVerificationScreen extends StatefulWidget {
  const AdminVerificationScreen({super.key});

  @override
  State<AdminVerificationScreen> createState() => _AdminVerificationScreenState();
}

class _AdminVerificationScreenState extends State<AdminVerificationScreen> {
  late Future<List<Map<String, dynamic>>> _verificationsFuture;

  @override
  void initState() {
    super.initState();
    _verificationsFuture = _loadVerifications();
  }

  Future<List<Map<String, dynamic>>> _loadVerifications() async {
    final profile = await FirebaseService().getUserProfile();
    return FirebaseService().getPendingVerifications(clubId: profile['club_id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "مركز مراجعة العضويات"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _verificationsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final items = snapshot.data!;
          if (items.isEmpty) return Center(child: Text("لا توجد طلبات معلقة حالياً", style: GoogleFonts.cairo()));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item['name'], style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                        _buildStatusBadge(item['status']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("نوع العضوية: ${item['membership_type']}", style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700])),
                    Text("الرقم القومي: ${item['national_id']}", style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text("معاينة المستندات", style: GoogleFonts.cairo(fontSize: 12, color: AppColors.primary)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text("تفعيل", style: GoogleFonts.cairo(fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "قيد المراجعة",
        style: GoogleFonts.cairo(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.bold),
      ),
    );
  }
}

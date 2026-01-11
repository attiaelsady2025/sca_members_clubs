
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class AdminComplaintsScreen extends StatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  State<AdminComplaintsScreen> createState() => _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends State<AdminComplaintsScreen> {
  late Future<List<Map<String, dynamic>>> _complaintsFuture;
  String? _clubId;

  @override
  void initState() {
    super.initState();
    _complaintsFuture = _loadData();
  }

  Future<List<Map<String, dynamic>>> _loadData() async {
    final profile = await FirebaseService().getUserProfile();
    _clubId = profile['club_id'];
    return FirebaseService().getComplaints(clubId: _clubId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "مركز الشكاوى والبلاغات"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _complaintsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final complaints = snapshot.data!;
          if (complaints.isEmpty) return Center(child: Text("لا توجد شكاوى حالياً", style: GoogleFonts.cairo()));
          
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final complaint = complaints[index];
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
                        Text("رقم الشكوى: #${complaint['id']}", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary)),
                        _buildStatusChip(complaint['status']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(complaint['category'], style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(complaint['content'], style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey[700])),
                    const SizedBox(height: 12),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(complaint['date'], style: GoogleFonts.cairo(fontSize: 11, color: Colors.grey)),
                        TextButton(
                          onPressed: () {},
                          child: Text("الرد على العضو", style: GoogleFonts.cairo(fontSize: 13, fontWeight: FontWeight.bold)),
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

  Widget _buildStatusChip(String status) {
    Color color = status == "مفتوحة" ? Colors.orange : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
      child: Text(status, style: GoogleFonts.cairo(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }
}

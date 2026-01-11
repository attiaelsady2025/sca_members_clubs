
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class AdminInvitationRequestsScreen extends StatefulWidget {
  const AdminInvitationRequestsScreen({super.key});

  @override
  State<AdminInvitationRequestsScreen> createState() => _AdminInvitationRequestsScreenState();
}

class _AdminInvitationRequestsScreenState extends State<AdminInvitationRequestsScreen> {
  late Future<List<Map<String, dynamic>>> _requestsFuture;
  String? _clubId;

  @override
  void initState() {
    super.initState();
    _requestsFuture = _loadData();
  }

  Future<List<Map<String, dynamic>>> _loadData() async {
    final profile = await FirebaseService().getUserProfile();
    _clubId = profile['club_id'];
    return FirebaseService().getInvitationRequests(clubId: _clubId);
  }

  void _refresh() {
    setState(() {
      _requestsFuture = _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "طلبات الكروت الإضافية"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _requestsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final requests = snapshot.data ?? [];
          if (requests.isEmpty) {
            return Center(child: Text("لا توجد طلبات معلقة", style: GoogleFonts.cairo()));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final req = requests[index];
              final isPending = req['status'] == "pending";
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
                        Text(
                          req['member_name'],
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        _buildStatusBadge(req['status']),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("رقم العضوية: ${req['member_id']}", style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 12),
                    Text(
                      "السبب: ${req['reason']}",
                      style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "الطلب: إضافة ${req['count']} دعوات إضافية",
                      style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    if (isPending) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => _handleAction(req['id'], "approved"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text("قبول", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => _handleAction(req['id'], "rejected"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Text("رفض", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ],
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
    Color color;
    String text;
    if (status == "pending") {
      color = Colors.orange;
      text = "قيد الانتظار";
    } else if (status == "approved") {
      color = Colors.green;
      text = "تم القبول";
    } else {
      color = Colors.red;
      text = "تم الرفض";
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: GoogleFonts.cairo(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
    );
  }

  void _handleAction(String id, String status) async {
    await FirebaseService().updateInvitationRequestStatus(id, status);
    _refresh();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(status == "approved" ? "تم قبول الطلب" : "تم رفض الطلب", style: GoogleFonts.cairo()))
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  late Future<List<Map<String, dynamic>>> _invitationsFuture;
  late Future<int> _visitorsCountFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _invitationsFuture = FirebaseService().getInvitations();
      _visitorsCountFuture = FirebaseService().getCurrentVisitorsCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(
        title: "دعوات الزوار",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Visitors Tracking Widget (New Feature)
            FutureBuilder<int>(
              future: _visitorsCountFuture,
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.people_alt, color: Colors.white, size: 32),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الزوار المتواجدون حالياً",
                              style: GoogleFonts.cairo(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "$count زوار في عهدتك",
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.info_outline, color: Colors.white70),
                    ],
                  ),
                );
              },
            ),

            // Invitation Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "رصيد دعوات السنة (30 دعوة)",
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        "استهلاك: 5/30",
                        style: GoogleFonts.cairo(color: AppColors.primary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 6,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      bool isUsed = index < 5;
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUsed ? Colors.red.withOpacity(0.1) : Colors.grey[100],
                          border: Border.all(
                            color: isUsed ? Colors.red : Colors.grey[300]!,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: isUsed 
                            ? const Icon(Icons.close, size: 16, color: Colors.red)
                            : Text(
                                "${index + 1}",
                                style: GoogleFonts.cairo(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  TextButton.icon(
                    onPressed: () => _handleRequestNewCard(),
                    icon: const Icon(Icons.add_card, size: 18, color: AppColors.primary),
                    label: Text(
                      "طلب كارت دعوات إضافي",
                      style: GoogleFonts.cairo(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Active Invitations Header
            _buildSectionHeader("الدعوات والزيارات"),
            const SizedBox(height: 16),
            
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _invitationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final invitations = snapshot.data ?? [];
                
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invitations.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final inv = invitations[index];
                    return _buildInvitationCard(context, inv);
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PrimaryButton(
          text: "إصدار دعوة جديدة",
          onPressed: () async {
            await Navigator.pushNamed(context, '/create_invitation');
            _loadData(); // Refresh on back
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildInvitationCard(BuildContext context, Map<String, dynamic> inv) {
    final String guestName = inv['guest_name'] ?? "";
    final String date = inv['date'] ?? "";
    final String status = inv['status'] ?? "active";
    final int guestCount = inv['guest_count'] ?? 1;
    final String? expiry = inv['expiry'];

    bool isInside = status == "inside";
    bool isActive = status == "active";
    bool isExpired = status == "expired";

    Color statusColor = isActive ? AppColors.primary : (isInside ? AppColors.success : Colors.grey);
    String statusText = isActive ? "نشط" : (isInside ? "متواجد بالنادي" : "منتهي");

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
        border: (isActive || isInside) ? Border.all(color: statusColor.withOpacity(0.3)) : null,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isInside ? Icons.directions_walk : Icons.person_add_alt_1,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        guestName,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isExpired ? Colors.grey : AppColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.cairo(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      "$date • $guestCount أفراد",
                      style: GoogleFonts.cairo(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    if (expiry != null && isActive)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, size: 10, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              "تنتهي 6 م",
                              style: GoogleFonts.cairo(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (isActive || isInside)
            GestureDetector(
              onTap: () {
                _showInvitationDetails(context, inv);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                     Icon(isInside ? Icons.info_outline : Icons.qr_code, size: 16, color: statusColor),
                     const SizedBox(width: 4),
                     Text(
                      isInside ? "تفاصيل" : "عرض QR",
                      style: GoogleFonts.cairo(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showInvitationDetails(BuildContext context, Map<String, dynamic> inv) {
    final String name = inv['guest_name'] ?? "";
    final String date = inv['date'] ?? "";
    final String status = inv['status'] ?? "active";
    final int guestCount = inv['guest_count'] ?? 1;
    final String? expiry = inv['expiry'];

    bool isInside = status == "inside";
    bool isActive = status == "active";

    showDialog(
      context: context, 
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isInside ? "تفاصيل الزيارة الحالية" : "تصريح دخول مؤقت",
                style: GoogleFonts.cairo(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              if (isActive) ...[
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(
                    child: Icon(Icons.qr_code_2, size: 140, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "كود صالح للاستخدام مرة واحدة",
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, size: 64, color: AppColors.success),
                ),
                const SizedBox(height: 8),
                Text(
                  "الزائر متواجد حالياً داخل النادي",
                  style: GoogleFonts.cairo(fontSize: 14, color: AppColors.success, fontWeight: FontWeight.bold),
                ),
              ],
              
              const SizedBox(height: 24),
              _buildDetailRow(Icons.person, "الاسم", name),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.people, "العدد", "$guestCount أفراد"),
              const SizedBox(height: 12),
              _buildDetailRow(Icons.calendar_today, "التاريخ", date),
              if (expiry != null && isActive) ...[
                const SizedBox(height: 12),
                _buildDetailRow(Icons.timer, "صالح حتى", "06:00 مساءً"),
              ],
              if (isInside) ...[
                const SizedBox(height: 12),
                _buildDetailRow(Icons.login, "وقت الدخول", "10:30 صباحاً"),
              ],
              
              const SizedBox(height: 32),
              
              if (isActive)
                PrimaryButton(
                  text: "مشاركة عبر واتساب ✅",
                  backgroundColor: const Color(0xFF25D366),
                  onPressed: () => _handleShare(context, name),
                ),
              
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "إغلاق",
                    style: GoogleFonts.cairo(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleRequestNewCard() async {
    // Show confirmation dialog or immediate request
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("طلب كارت إضافي", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(
          "هل ترغب في إرسال طلب للإدارة لزيادة رصيد الدعوات الخاص بك؟",
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("إرسال الطلب", style: GoogleFonts.cairo(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Simulate API call
      await FirebaseService().requestAdditionalInvitations();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("تم إرسال طلبك بنجاح. سيتم مراجعته من قبل الإدارة.", style: GoogleFonts.cairo()),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _handleShare(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("تم فتح تطبيق واتساب لمشاركة التصريح مع ($name)", style: GoogleFonts.cairo()),
        backgroundColor: const Color(0xFF25D366),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text("$label: ", style: GoogleFonts.cairo(color: Colors.grey)),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';

class InvitationsHistoryScreen extends StatefulWidget {
  const InvitationsHistoryScreen({super.key});

  @override
  State<InvitationsHistoryScreen> createState() =>
      _InvitationsHistoryScreenState();
}

class _InvitationsHistoryScreenState extends State<InvitationsHistoryScreen> {
  String _searchQuery = "";
  String _selectedStatus = "all";
  late Future<List<Map<String, dynamic>>> _invitationsFuture;

  @override
  void initState() {
    super.initState();
    _invitationsFuture = FirebaseService().getInvitations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "سجل الدعوات"),
      body: Column(
        children: [
          _buildSearchAndFilter(),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _invitationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text("حدث خطأ ما", style: GoogleFonts.cairo()),
                  );
                }

                final allInvs = snapshot.data ?? [];
                final filteredInvs = allInvs.where((inv) {
                  final nameMatch = (inv['guest_name'] ?? "")
                      .toString()
                      .toLowerCase()
                      .contains(_searchQuery.toLowerCase());
                  final statusMatch =
                      _selectedStatus == "all" ||
                      inv['status'] == _selectedStatus;
                  return nameMatch && statusMatch;
                }).toList();

                if (filteredInvs.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: filteredInvs.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _buildHistoryCard(context, filteredInvs[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: "بحث باسم الزائر...",
                hintStyle: GoogleFonts.cairo(fontSize: 13, color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("الكل", "all"),
                const SizedBox(width: 8),
                _buildFilterChip("نشط", "active"),
                const SizedBox(width: 8),
                _buildFilterChip("داخل النادي", "inside"),
                const SizedBox(width: 8),
                _buildFilterChip("منتهي", "expired"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String status) {
    final isSelected = _selectedStatus == status;
    return InkWell(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.cairo(
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard(BuildContext context, Map<String, dynamic> inv) {
    final status = inv['status'] ?? "active";
    final isActive = status == "active";
    final isInside = status == "inside";
    final isExpired = status == "expired";

    Color statusColor = isActive
        ? AppColors.primary
        : (isInside ? AppColors.success : Colors.grey);

    String actionText = isActive ? "عرض QR" : (isInside ? "تفاصيل" : "منتهي");

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isInside
                ? Icons.verified_user_rounded
                : (isActive ? Icons.qr_code_2_rounded : Icons.history_rounded),
            color: statusColor,
          ),
        ),
        title: Text(
          inv['guest_name'] ?? "",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        subtitle: Text(
          "تاريخ: ${inv['date']} • ${inv['guest_count']} أفراد",
          style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isExpired ? Colors.grey[100] : statusColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            actionText,
            style: GoogleFonts.cairo(
              color: isExpired ? Colors.grey : Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onTap: () => _showInvitationDetails(context, inv),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "لا توجد نتائج تطابق بحثك",
            style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Detailed dialog logic
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isActive ? AppColors.primary : AppColors.success,
                        isActive
                            ? AppColors.secondary
                            : AppColors.success.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isActive
                              ? Icons.qr_code_scanner_rounded
                              : Icons.verified_user_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isActive ? "تصريح دخول مؤقت" : "الزائر متواجد حالياً",
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      if (isActive) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 180,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "برجاء إظهار الكود لمسؤول الأمن عند الدخول",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      _buildModernDetailRow(
                        Icons.person_outline,
                        "اسم الزائر",
                        name,
                      ),
                      const Divider(height: 24),
                      _buildModernDetailRow(
                        Icons.people_outline,
                        "عدد الأفراد",
                        "$guestCount أفراد",
                      ),
                      const Divider(height: 24),
                      _buildModernDetailRow(
                        Icons.calendar_today_outlined,
                        "تاريخ الزيارة",
                        date,
                      ),

                      if (expiry != null && isActive) ...[
                        const Divider(height: 24),
                        _buildModernDetailRow(
                          Icons.timer_outlined,
                          "صالح حتى",
                          "06:00 مساءً",
                        ),
                      ],

                      if (isInside) ...[
                        const Divider(height: 24),
                        _buildModernDetailRow(
                          Icons.login_rounded,
                          "وقت الدخول",
                          "10:30 صباحاً",
                        ),
                      ],

                      const SizedBox(height: 32),

                      if (isActive)
                        PrimaryButton(
                          text: "مشاركة عبر واتساب",
                          onPressed: () => _handleShare(context, name),
                          suffixIcon: Icons.share_rounded,
                        ),

                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "إغلاق",
                          style: GoogleFonts.cairo(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.cairo(color: Colors.grey[600], fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  void _handleShare(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تم فتح تطبيق واتساب لمشاركة التصريح مع ($name)",
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: const Color(0xFF25D366),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

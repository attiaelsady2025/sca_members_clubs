
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';

class AdminMembersScreen extends StatefulWidget {
  const AdminMembersScreen({super.key});

  @override
  State<AdminMembersScreen> createState() => _AdminMembersScreenState();
}

class _AdminMembersScreenState extends State<AdminMembersScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _allMembers = [];
  List<Map<String, dynamic>> _filteredMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    // In a real app, this would be a paged search. 
    // For now, we simulate by getting the main profile and some mock variants.
    final profile = await FirebaseService().getUserProfile();
    setState(() {
      _allMembers = [
        profile,
        {...profile, "id": "99999999", "name": "أحمد محمد علي", "national_id": "29010101234567", "status": "نشط"},
        {...profile, "id": "88888888", "name": "منى عبد الحميد", "national_id": "29105051234567", "status": "موقف"},
      ];
      _filteredMembers = _allMembers;
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _filteredMembers = _allMembers.where((m) => 
        m['name'].contains(query) || m['national_id'].contains(query) || m['id'].contains(query)
      ).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "إدارة الأعضاء"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: InputDecoration(
                hintText: "ابحث بالاسم، رقم العضوية أو القومي...",
                hintStyle: GoogleFonts.cairo(fontSize: 13),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _filteredMembers.isEmpty
                ? Center(child: Text("لم يتم العثور على نتائج", style: GoogleFonts.cairo()))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredMembers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final member = _filteredMembers[index];
                      final isActive = member['status'] == "نشط";
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.withOpacity(0.1)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            child: const Icon(Icons.person, color: AppColors.primary),
                          ),
                          title: Text(member['name'], style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("عضوية: ${member['id']}", style: GoogleFonts.cairo(fontSize: 12)),
                              Text(member['department'] ?? "إدارة عامة", style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  member['status'],
                                  style: GoogleFonts.cairo(
                                    fontSize: 10,
                                    color: isActive ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                            ],
                          ),
                          onTap: () => _showMemberDetails(member),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showMemberDetails(Map<String, dynamic> member) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text("تفاصيل العضو", style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _buildDetailRow("الاسم", member['name']),
            _buildDetailRow("رقم العضوية", member['id']),
            _buildDetailRow("الرقم القومي", member['national_id']),
            _buildDetailRow("نوع العضوية", member['membership_type']),
            _buildDetailRow("الحالة", member['status'], isStatus: true),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Toggle status logic
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("تم تغيير حالة العضو بنجاح", style: GoogleFonts.cairo()))
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: member['status'] == "نشط" ? Colors.red : Colors.green,
                      side: BorderSide(color: member['status'] == "نشط" ? Colors.red : Colors.green),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(member['status'] == "نشط" ? "إيقاف العضوية" : "تفعيل العضوية", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text("إغلاق", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.cairo(color: Colors.grey, fontSize: 13)),
          Text(
            value, 
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold, 
              color: isStatus ? (value == "نشط" ? Colors.green : Colors.red) : AppColors.textPrimary
            )
          ),
        ],
      ),
    );
  }
}

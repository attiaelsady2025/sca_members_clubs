import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class SecurityInvitationsScreen extends StatefulWidget {
  const SecurityInvitationsScreen({super.key});

  @override
  State<SecurityInvitationsScreen> createState() => _SecurityInvitationsScreenState();
}

class _SecurityInvitationsScreenState extends State<SecurityInvitationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allInvitations = [];
  List<Map<String, dynamic>> _filteredInvitations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInvitations();
  }

  Future<void> _loadInvitations() async {
    final data = await FirebaseService().getInvitations();
    setState(() {
      _allInvitations = data;
      _filteredInvitations = data;
      _isLoading = false;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredInvitations = _allInvitations;
      } else {
        _filteredInvitations = _allInvitations
            .where((inv) => inv['national_id'].toString().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(
        title: "التحقق من الدعوات",
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "بحث بالرقم القومي...",
                hintStyle: GoogleFonts.cairo(fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ),
          
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredInvitations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              "لا توجد نتائج مطابقة",
                              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: _filteredInvitations.length,
                        itemBuilder: (context, index) {
                          final inv = _filteredInvitations[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: const CircleAvatar(
                                backgroundColor: Color(0xFFE3F2FD),
                                child: Icon(Icons.person, color: Colors.blue),
                              ),
                              title: Text(
                                inv['guest_name'],
                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "التاريخ: ${inv['date']}\nالرقم القومي: ${inv['national_id']}",
                                style: GoogleFonts.cairo(fontSize: 12),
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: inv['status'] == 'active' ? Colors.green[50] : Colors.red[50],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  inv['status'] == 'active' ? "نشطة" : "منتهية",
                                  style: GoogleFonts.cairo(
                                    color: inv['status'] == 'active' ? Colors.green : Colors.red,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/widgets/custom_text_field.dart';

class AdminOfficialGuestsScreen extends StatefulWidget {
  const AdminOfficialGuestsScreen({super.key});

  @override
  State<AdminOfficialGuestsScreen> createState() =>
      _AdminOfficialGuestsScreenState();
}

class _AdminOfficialGuestsScreenState extends State<AdminOfficialGuestsScreen> {
  late Future<List<Map<String, dynamic>>> _guestsFuture;
  String? _clubId;

  @override
  void initState() {
    super.initState();
    _guestsFuture = _loadGuests();
  }

  Future<List<Map<String, dynamic>>> _loadGuests() async {
    final profile = await FirebaseService().getUserProfile();
    _clubId = profile['club_id'];
    return FirebaseService().getOfficialGuests(clubId: _clubId);
  }

  void _refresh() {
    setState(() {
      _guestsFuture = _loadGuests();
    });
  }

  void _showCreateGuestDialog() {
    final nameController = TextEditingController();
    final orgController = TextEditingController();
    final reasonController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "إصدار دعوة رسمية",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: "اسم الضيف",
                controller: nameController,
                hint: "اسم الضيف الرسمي",
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "الجهة",
                controller: orgController,
                hint: "الجهة التابع لها",
                prefixIcon: Icons.business,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "سبب الزيارة",
                controller: reasonController,
                hint: "مثال: زيارة تفقدية",
                prefixIcon: Icons.description,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isEmpty) return;
              await FirebaseService().createOfficialInvitation({
                "guest_name": nameController.text,
                "organization": orgController.text,
                "reason": reasonController.text,
                "date":
                    "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}",
                "club_id": _clubId,
              });
              if (mounted) {
                Navigator.pop(context);
                _loadGuests();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("تم إصدار الدعوة الرسمية بنجاح"),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "إصدار",
              style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "الضيوف الرسميين (VIP)"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _guestsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final guests = snapshot.data!;
          if (guests.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.card_giftcard, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text(
                    "لا توجد دعوات رسمية حالياً",
                    style: GoogleFonts.cairo(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: guests.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final g = guests[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.amber.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.amber.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.stars, color: Colors.amber, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            g['guest_name'],
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "الجهة: ${g['organization']}",
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      "السبب: ${g['reason']}",
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "كود الدخول الذهبي:",
                          style: GoogleFonts.cairo(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            g['entry_code'],
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateGuestDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "دعوة رسمية جديدة",
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

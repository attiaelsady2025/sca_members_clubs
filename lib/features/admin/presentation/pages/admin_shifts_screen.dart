
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/widgets/custom_text_field.dart';

class AdminShiftsScreen extends StatefulWidget {
  const AdminShiftsScreen({super.key});

  @override
  State<AdminShiftsScreen> createState() => _AdminShiftsScreenState();
}

class _AdminShiftsScreenState extends State<AdminShiftsScreen> {
  late Future<List<Map<String, dynamic>>> _staffFuture;
  String? _clubId;

  @override
  void initState() {
    super.initState();
    _staffFuture = _loadStaff();
  }

  Future<List<Map<String, dynamic>>> _loadStaff() async {
    final profile = await FirebaseService().getUserProfile();
    _clubId = profile['club_id'];
    return FirebaseService().getSecurityStaff(clubId: profile['club_id']);
  }

  void _showCreateShiftDialog() {
    final nameController = TextEditingController();
    String selectedGate = "البوابة الرئيسية";
    String selectedShift = "صباحية";

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("إضافة فرد أمن جديد", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: "اسم فرد الأمن",
                  controller: nameController,
                  hint: "مثال: م/ أحمد محمد",
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                Text("البوابة المسؤول عنها", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedGate,
                      isExpanded: true,
                      onChanged: (val) => setDialogState(() => selectedGate = val!),
                      items: const [
                        DropdownMenuItem(value: "البوابة الرئيسية", child: Text("البوابة الرئيسية")),
                        DropdownMenuItem(value: "بوابة الملاعب", child: Text("بوابة الملاعب")),
                        DropdownMenuItem(value: "بوابة المطاعم", child: Text("بوابة المطاعم")),
                        DropdownMenuItem(value: "بوابة حمام السباحة", child: Text("بوابة حمام السباحة")),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text("الوردية", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedShift,
                      isExpanded: true,
                      onChanged: (val) => setDialogState(() => selectedShift = val!),
                      items: const [
                        DropdownMenuItem(value: "صباحية", child: Text("صباحية (6 ص - 2 م)")),
                        DropdownMenuItem(value: "مسائية", child: Text("مسائية (2 م - 10 م)")),
                        DropdownMenuItem(value: "ليلية", child: Text("ليلية (10 م - 6 ص)")),
                      ],
                    ),
                  ),
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
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("يرجى إدخال اسم فرد الأمن")),
                  );
                  return;
                }

                await FirebaseService().addSecurityStaff({
                  "name": nameController.text,
                  "gate": selectedGate,
                  "shift": selectedShift,
                  "club_id": _clubId,
                  "status": "on_duty",
                });

                if (mounted) {
                  Navigator.pop(context);
                  setState(() {
                    _staffFuture = _loadStaff();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم إضافة فرد الأمن بنجاح")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("إضافة", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditShiftDialog(Map<String, dynamic> staff) {
    String selectedGate = staff['gate'];
    String selectedShift = staff['shift'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text("تعديل وردية ${staff['name']}", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("البوابة المسؤول عنها", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedGate,
                    isExpanded: true,
                    onChanged: (val) => setDialogState(() => selectedGate = val!),
                    items: const [
                      DropdownMenuItem(value: "البوابة الرئيسية", child: Text("البوابة الرئيسية")),
                      DropdownMenuItem(value: "بوابة الملاعب", child: Text("بوابة الملاعب")),
                      DropdownMenuItem(value: "بوابة المطاعم", child: Text("بوابة المطاعم")),
                      DropdownMenuItem(value: "بوابة حمام السباحة", child: Text("بوابة حمام السباحة")),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text("الوردية", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedShift,
                    isExpanded: true,
                    onChanged: (val) => setDialogState(() => selectedShift = val!),
                    items: const [
                      DropdownMenuItem(value: "صباحية", child: Text("صباحية (6 ص - 2 م)")),
                      DropdownMenuItem(value: "مسائية", child: Text("مسائية (2 م - 10 م)")),
                      DropdownMenuItem(value: "ليلية", child: Text("ليلية (10 م - 6 ص)")),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseService().updateSecurityShift(staff['id'], selectedShift, selectedGate);
                if (mounted) {
                  Navigator.pop(context);
                  setState(() {
                    _staffFuture = _loadStaff();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم تحديث الوردية بنجاح")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("حفظ", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "تحركات الأمن والورديات"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _staffFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final staff = snapshot.data!;
          if (staff.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  Text("لا يوجد أفراد أمن مسجلين", style: GoogleFonts.cairo(color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text("اضغط على الزر أدناه لإضافة فرد أمن", style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: staff.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final s = staff[index];
              final isOnDuty = s['status'] == 'on_duty';
              
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isOnDuty ? Colors.green : Colors.grey).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.security, color: isOnDuty ? Colors.green : Colors.grey, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['name'], style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 14)),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(s['gate'], style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "وردية ${s['shift']}",
                            style: GoogleFonts.cairo(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 8),
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          color: AppColors.primary,
                          onPressed: () => _showEditShiftDialog(s),
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
        onPressed: _showCreateShiftDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text("إضافة فرد أمن", style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

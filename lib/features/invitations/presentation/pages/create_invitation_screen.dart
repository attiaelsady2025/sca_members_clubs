import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class CreateInvitationScreen extends StatefulWidget {
  const CreateInvitationScreen({super.key});

  @override
  State<CreateInvitationScreen> createState() => _CreateInvitationScreenState();
}

class _CreateInvitationScreenState extends State<CreateInvitationScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Current guest being entered
  DateTime? _currentDate;
  String _currentDuration = "2";
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  bool _saveToFavorites = false;
  
  // List of guests added to the table
  final List<GuestData> _addedGuests = [];

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _currentDate) {
      setState(() {
        _currentDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(
        title: "دعوة جديدة",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "إضافة زائر للقائمة",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton.icon(
                  onPressed: _showFrequentGuestsSheet,
                  icon: const Icon(Icons.star_outline, size: 20, color: AppColors.primary),
                  label: Text("اختر من المفضلة", style: GoogleFonts.cairo(color: AppColors.primary, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            _buildLabel("اسم الزائر (رباعي)"),
            const SizedBox(height: 8),
            _buildTextField(
              hint: "أدخل اسم الزائر كما في البطاقة",
              controller: _nameController,
            ),
            
            const SizedBox(height: 16),
            
            _buildLabel("الرقم القومي للزائر"),
            const SizedBox(height: 8),
            _buildTextField(
              hint: "14 رقم", 
              keyboardType: TextInputType.number,
              controller: _idController,
            ),

            const SizedBox(height: 12),
            
            Row(
              children: [
                Checkbox(
                  value: _saveToFavorites, 
                  onChanged: (val) => setState(() => _saveToFavorites = val ?? false),
                  activeColor: AppColors.primary,
                ),
                Text("حفظ في قائمة الضيوف الدائمين", style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("تاريخ الزيارة"),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () => _selectDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(
                                _currentDate == null 
                                  ? "اختر التاريخ" 
                                  : "${_currentDate!.day}/${_currentDate!.month}/${_currentDate!.year}",
                                style: GoogleFonts.cairo(
                                  fontSize: 12,
                                  color: _currentDate == null ? Colors.grey : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("مدة الصلاحية"),
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
                            value: _currentDuration,
                            isExpanded: true,
                            style: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 12),
                            items: ["2", "6", "12", "24"].map((h) => DropdownMenuItem(
                              value: h,
                              child: Text("$h ساعة", style: GoogleFonts.cairo()),
                            )).toList(),
                            onChanged: (val) => setState(() => _currentDuration = val!),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            OutlinedButton.icon(
              onPressed: _addGuestToList,
              icon: const Icon(Icons.add_circle_outline),
              label: Text("إضافة زائر للقائمة", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                minimumSize: const Size(double.infinity, 0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            if (_addedGuests.isNotEmpty) ...[
              const SizedBox(height: 40),
              Text(
                "قائمة الزوار المضافين (${_addedGuests.length})",
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildGuestTable(),
              
              const SizedBox(height: 24),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "سيتم إصدار ${_addedGuests.length} دعوات منفصلة، وخصم نفس العدد من رصيدك.",
                        style: GoogleFonts.cairo(
                          color: AppColors.textPrimary,
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              
              PrimaryButton(
                text: "إصدار جميع الدعوات",
                onPressed: _issueAllInvitations,
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _showFrequentGuestsSheet() async {
    final favorites = await FirebaseService().getFrequentGuests();
    if (!mounted) return;
    
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الضيوف الدائمين",
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (favorites.isEmpty)
              Center(child: Text("لا توجد أسماء محفوظة", style: GoogleFonts.cairo())),
            ...favorites.map((guest) => ListTile(
              leading: const Icon(Icons.star, color: Colors.amber),
              title: Text(guest['name'], style: GoogleFonts.cairo()),
              subtitle: Text(guest['national_id'], style: GoogleFonts.cairo(fontSize: 12)),
              onTap: () {
                setState(() {
                  _nameController.text = guest['name'];
                  _idController.text = guest['national_id'];
                });
                Navigator.pop(context);
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () async {
                  await FirebaseService().toggleFrequentGuest(guest);
                  Navigator.pop(context);
                  _showFrequentGuestsSheet();
                },
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _addGuestToList() {
    if (_nameController.text.isEmpty || _idController.text.length < 14 || _currentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("برجاء إكمال بيانات الزائر واختيار التاريخ", style: GoogleFonts.cairo()),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_saveToFavorites) {
      FirebaseService().toggleFrequentGuest({
        "name": _nameController.text,
        "national_id": _idController.text,
      });
    }

    setState(() {
      _addedGuests.add(GuestData(
        name: _nameController.text,
        id: _idController.text,
        date: _currentDate!,
        duration: _currentDuration,
      ));
      
      // Clear fields for next entry
      _nameController.clear();
      _idController.clear();
      _saveToFavorites = false;
    });
  }

  Future<void> _issueAllInvitations() async {
    for (var guest in _addedGuests) {
      await FirebaseService().createInvitation({
        "guest_name": guest.name,
        "national_id": guest.id,
        "date": "${guest.date.day}/${guest.date.month}/${guest.date.year}",
        "guest_count": 1,
        "duration": guest.duration,
        "expiry": DateTime.now().add(Duration(hours: int.parse(guest.duration))).toIso8601String(),
      });
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("تم إنشاء ${_addedGuests.length} دعوة بنجاح", style: GoogleFonts.cairo()),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Widget _buildGuestTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingTextStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 13),
          dataTextStyle: GoogleFonts.cairo(color: AppColors.textPrimary, fontSize: 12),
          columns: const [
            DataColumn(label: Text("الاسم")),
            DataColumn(label: Text("التاريخ")),
            DataColumn(label: Text("المدة")),
            DataColumn(label: Text("حذف")),
          ],
          rows: _addedGuests.map((guest) => DataRow(
            cells: [
              DataCell(Text(guest.name)),
              DataCell(Text("${guest.date.day}/${guest.date.month}/${guest.date.year}")),
              DataCell(Text("${guest.duration} ساعة")),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () => setState(() => _addedGuests.remove(guest)),
                ),
              ),
            ],
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.cairo(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({required String hint, TextInputType? keyboardType, TextEditingController? controller}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.cairo(color: Colors.grey[400]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
        ),
      ),
    );
  }
}

class GuestData {
  final String name;
  final String id;
  final DateTime date;
  final String duration;

  GuestData({
    required this.name,
    required this.id,
    required this.date,
    required this.duration,
  });
}

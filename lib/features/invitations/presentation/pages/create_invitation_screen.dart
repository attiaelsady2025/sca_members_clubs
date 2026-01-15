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
      appBar: const ScaAppBar(title: "دعوة جديدة"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSectionTitle("بيانات الزائر"),
                TextButton.icon(
                  onPressed: _showFrequentGuestsSheet,
                  icon: const Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  label: Text(
                    "المفضلة",
                    style: GoogleFonts.cairo(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            _buildLabel("اسم الزائر (رباعي)"),
            _buildTextField(
              hint: "أدخل الاسم كما في البطاقة",
              controller: _nameController,
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 20),

            _buildLabel("الرقم القومي للزائر"),
            _buildTextField(
              hint: "14 رقم قومي",
              keyboardType: TextInputType.number,
              controller: _idController,
              icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: _saveToFavorites,
                    onChanged: (val) =>
                        setState(() => _saveToFavorites = val ?? false),
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "حفظ في قائمة الضيوف الدائمين",
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("تاريخ الزيارة"),
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.calendar_today_rounded,
                                size: 18,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                _currentDate == null
                                    ? "اختر التاريخ"
                                    : "${_currentDate!.day}/${_currentDate!.month}/${_currentDate!.year}",
                                style: GoogleFonts.cairo(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _currentDate == null
                                      ? Colors.grey
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            PrimaryButton(
              text: "إضافة للقائمة",
              onPressed: _addGuestToList,
              icon: Icons.person_add_rounded,
              backgroundColor: AppColors.secondary,
            ),

            const SizedBox(height: 48),

            _buildSectionTitle("قائمة الانتظار (${_addedGuests.length})"),
            const SizedBox(height: 16),
            _buildGuestCards(),

            if (_addedGuests.isNotEmpty) ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "سيتم خصم (${_addedGuests.length}) دعوات من رصيدك عند التأكيد.",
                        style: GoogleFonts.cairo(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: "تأكيد وإصدار التصاريح",
                onPressed: _issueAllInvitations,
                suffixIcon: Icons.check_circle_rounded,
              ),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Future<void> _showFrequentGuestsSheet() async {
    final favorites = await FirebaseService().getFrequentGuests();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الضيوف الدائمين",
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (favorites.isEmpty)
              Center(
                child: Text("لا توجد أسماء محفوظة", style: GoogleFonts.cairo()),
              ),
            ...favorites.map(
              (guest) => ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text(guest['name'], style: GoogleFonts.cairo()),
                subtitle: Text(
                  guest['national_id'],
                  style: GoogleFonts.cairo(fontSize: 12),
                ),
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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addGuestToList() {
    if (_nameController.text.isEmpty ||
        _idController.text.length < 14 ||
        _currentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "برجاء إكمال بيانات الزائر واختيار التاريخ",
            style: GoogleFonts.cairo(),
          ),
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
      _addedGuests.add(
        GuestData(
          name: _nameController.text,
          id: _idController.text,
          date: _currentDate!,
        ),
      );

      // Clear fields for next entry
      _nameController.clear();
      _idController.clear();
      _saveToFavorites = false;
    });
  }

  Future<void> _issueAllInvitations() async {
    for (var guest in _addedGuests) {
      // Expiry is at the end of the selected day (11:59:59 PM)
      final expiryDate = DateTime(
        guest.date.year,
        guest.date.month,
        guest.date.day,
        23,
        59,
        59,
      );

      await FirebaseService().createInvitation({
        "guest_name": guest.name,
        "national_id": guest.id,
        "date": "${guest.date.day}/${guest.date.month}/${guest.date.year}",
        "guest_count": 1,
        "expiry": expiryDate.toIso8601String(),
      });
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "تم إنشاء ${_addedGuests.length} دعوة بنجاح",
            style: GoogleFonts.cairo(),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Widget _buildTextField({
    required String hint,
    TextInputType? keyboardType,
    TextEditingController? controller,
    IconData? icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null
              ? Icon(icon, color: AppColors.primary, size: 20)
              : null,
          hintStyle: GoogleFonts.cairo(color: Colors.grey[400], fontSize: 13),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildGuestCards() {
    if (_addedGuests.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Icon(Icons.person_add_outlined, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              "لم يتم إضافة زوار بعد",
              style: GoogleFonts.cairo(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _addedGuests.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final guest = _addedGuests[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      guest.name,
                      style: GoogleFonts.cairo(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "تاريخ: ${guest.date.day}/${guest.date.month}/${guest.date.year}",
                      style: GoogleFonts.cairo(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red,
                ),
                onPressed: () => setState(() => _addedGuests.remove(guest)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.textPrimary.withOpacity(0.8),
        ),
      ),
    );
  }
}

class GuestData {
  final String name;
  final String id;
  final DateTime date;

  GuestData({required this.name, required this.id, required this.date});
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class AddFamilyMemberScreen extends StatelessWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>(),
      child: const AddFamilyMemberForm(),
    );
  }
}

class AddFamilyMemberForm extends StatefulWidget {
  const AddFamilyMemberForm({super.key});

  @override
  State<AddFamilyMemberForm> createState() => _AddFamilyMemberFormState();
}

class _AddFamilyMemberFormState extends State<AddFamilyMemberForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  String _selectedRelation = "زوجة";
  bool _isLoading = false;

  final List<String> _relations = ["زوجة", "ابن", "ابنة", "أخرى"];

  @override
  void initState() {
    super.initState();
    _nationalIdController.addListener(_onNationalIdChanged);
  }

  @override
  void dispose() {
    _nationalIdController.removeListener(_onNationalIdChanged);
    _nationalIdController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }

  void _onNationalIdChanged() {
    final text = _nationalIdController.text;
    if (text.length == 14) {
      _extractDataFromNationalId(text);
    }
  }

  void _extractDataFromNationalId(String id) {
    try {
      int centuryDigit = int.parse(id.substring(0, 1));
      int year = int.parse(id.substring(1, 3));
      int month = int.parse(id.substring(3, 5));
      int day = int.parse(id.substring(5, 7));

      int fullYear = (centuryDigit == 2 ? 1900 : 2000) + year;

      final birthDate = DateTime(fullYear, month, day);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month ||
          (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      setState(() {
        _ageController.text = age.toString();
        _birthDateController.text =
            "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$fullYear";
      });
    } catch (e) {
      // Invalid logic
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newMember = {
        "id": "f${DateTime.now().millisecondsSinceEpoch}",
        "name": _nameController.text,
        "relation": _selectedRelation,
        "age": int.tryParse(_ageController.text) ?? 0,
        "national_id": _nationalIdController.text,
        "birth_date": _birthDateController.text,
        "image": "assets/images/user_placeholder.png",
      };

      await context.read<ProfileCubit>().addFamilyMember(newMember);

      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تمت إضافة فرد الأسرة بنجاح",
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "إضافة فرد جديد",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "بيانات فرد الأسرة",
                style: GoogleFonts.cairo(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "يرجى إدخال البيانات الشخصية بدقة كما هي في الرقم القومي.",
                style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "الاسم رباعي",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) =>
                    value!.isEmpty ? "من فضلك أدخل الاسم" : null,
              ),
              const SizedBox(height: 20),

              // Relation Dropdown
              DropdownButtonFormField<String>(
                initialValue: _selectedRelation,
                items: _relations
                    .map(
                      (r) => DropdownMenuItem(
                        value: r,
                        child: Text(r, style: GoogleFonts.cairo()),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _selectedRelation = value!),
                decoration: InputDecoration(
                  labelText: "صلة القرابة",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: const Icon(Icons.family_restroom_outlined),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // National ID
              TextFormField(
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                decoration: InputDecoration(
                  labelText: "الرقم القومي (14 رقم)",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: const Icon(Icons.badge_outlined),
                  counterText: "",
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value!.isEmpty) return "من فضلك أدخل الرقم القومي";
                  if (value.length != 14) return "يجب أن يتكون من 14 رقم";
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Birth Date (Read-only)
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "تاريخ الميلاد (يستخرج تلقائياً)",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: const Icon(Icons.cake_outlined),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
              ),
              const SizedBox(height: 20),

              // Age (Auto-filled)
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "العمر",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                validator: (value) =>
                    value!.isEmpty ? "من فضلك أدخل العمر" : null,
              ),

              const SizedBox(height: 48),

              _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    )
                  : PrimaryButton(text: "حفظ البيانات", onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}

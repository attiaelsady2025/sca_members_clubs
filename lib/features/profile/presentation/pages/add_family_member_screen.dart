import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class AddFamilyMemberScreen extends StatefulWidget {
  const AddFamilyMemberScreen({super.key});

  @override
  State<AddFamilyMemberScreen> createState() => _AddFamilyMemberScreenState();
}

class _AddFamilyMemberScreenState extends State<AddFamilyMemberScreen> {
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
      // Egyptian National ID logic
      int centuryDigit = int.parse(id.substring(0, 1));
      int year = int.parse(id.substring(1, 3));
      int month = int.parse(id.substring(3, 5));
      int day = int.parse(id.substring(5, 7));

      int fullYear = (centuryDigit == 2 ? 1900 : 2000) + year;
      
      final birthDate = DateTime(fullYear, month, day);
      final today = DateTime.now();
      int age = today.year - birthDate.year;
      if (today.month < birthDate.month || (today.month == birthDate.month && today.day < birthDate.day)) {
        age--;
      }

      setState(() {
        _ageController.text = age.toString();
        _birthDateController.text = "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$fullYear";
      });
    } catch (e) {
      // Invalid logic or digit
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final newMember = {
        "id": "f${DateTime.now().millisecondsSinceEpoch}", // temporary ID
        "name": _nameController.text,
        "relation": _selectedRelation,
        "age": int.tryParse(_ageController.text) ?? 0,
        "national_id": _nationalIdController.text,
        "birth_date": _birthDateController.text,
        "image": "assets/images/user_placeholder.png",
      };

      await FirebaseService().addFamilyMember(newMember);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text("تمت الإضافة بنجاح", style: GoogleFonts.cairo())),
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
        title: const Text("إضافة فرد جديد"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("بيانات الفرد", style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              
              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "الاسم رباعي",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) => value!.isEmpty ? "من فضلك أدخل الاسم" : null,
              ),
              const SizedBox(height: 16),
              
              // Relation Dropdown
              DropdownButtonFormField<String>(
                value: _selectedRelation,
                items: _relations.map((r) => DropdownMenuItem(value: r, child: Text(r, style: GoogleFonts.cairo()))).toList(),
                onChanged: (value) => setState(() => _selectedRelation = value!),
                decoration: InputDecoration(
                  labelText: "صلة القرابة",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.family_restroom),
                ),
              ),
              const SizedBox(height: 16),

              // National ID (New)
              TextFormField(
                controller: _nationalIdController,
                keyboardType: TextInputType.number,
                maxLength: 14,
                decoration: InputDecoration(
                  labelText: "الرقم القومي (14 رقم)",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.badge),
                  counterText: "",
                ),
                validator: (value) {
                  if (value!.isEmpty) return "من فضلك أدخل الرقم القومي";
                  if (value.length != 14) return "يجب أن يتكون من 14 رقم";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Birth Date (Read-only, auto-filled)
              TextFormField(
                controller: _birthDateController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "تاريخ الميلاد (يستخرج تلقائياً)",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.event),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 16),

              // Age (Auto-filled)
              TextFormField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "العمر",
                  labelStyle: GoogleFonts.cairo(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) => value!.isEmpty ? "من فضلك أدخل العمر" : null,
              ),

              const SizedBox(height: 40),

              _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : PrimaryButton(text: "حفظ البيانات", onPressed: _submit),

            ],
          ),
        ),
      ),
    );
  }
}

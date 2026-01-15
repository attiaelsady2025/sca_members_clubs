import 'package:flutter/material.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Header Background
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: SafeArea(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        Expanded(
                          child: Text(
                            "إنشاء عضوية جديدة",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48), // Balance for back button
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Body Content
          SafeArea(
            child: Container(
              margin: const EdgeInsets.only(top: 80), // Overlap header
              child: Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primary,
                  ),
                  canvasColor: AppColors.background,
                ),
                child: Stepper(
                  type: StepperType.horizontal,
                  elevation: 0,
                  currentStep: _currentStep,
                  onStepContinue: () {
                    if (_currentStep < 2) {
                      setState(() => _currentStep += 1);
                    } else {
                      // Submit Logic
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        (route) => false,
                      );
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() => _currentStep -= 1);
                    }
                  },
                  controlsBuilder: (context, details) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: details.onStepContinue,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: Text(
                                _currentStep == 2 ? "تأكيد التسجيل" : "التالي",
                                style: GoogleFonts.cairo(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (_currentStep > 0) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: details.onStepCancel,
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  side: const BorderSide(color: Colors.grey),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "السابق",
                                  style: GoogleFonts.cairo(
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                  steps: [
                    Step(
                      title: const Text("البيانات"),
                      content: _buildCard([
                        _buildTextField("الاسم الرباعي", Icons.person),
                        const SizedBox(height: 16),
                        _buildTextField("الرقم القومي", Icons.badge),
                        const SizedBox(height: 16),
                        _buildTextField("رقم الهاتف", Icons.phone),
                      ]),
                      isActive: _currentStep >= 0,
                      state: _currentStep > 0
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text("العضوية"),
                      content: _buildCard([
                        _buildTextField(
                          "رقم العضوية (إن وجد)",
                          Icons.card_membership,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField("رقم العمل", Icons.work),
                        const SizedBox(height: 16),
                        _buildDropdown("نوع العضوية", Icons.category, [
                          "عضو عامل",
                          "عضو تابع",
                          "عضو معاشات",
                          "عضو خارجى",
                        ]),
                        const SizedBox(height: 16),
                        _buildTextField("البريد الإلكتروني", Icons.email),
                      ]),
                      isActive: _currentStep >= 1,
                      state: _currentStep > 1
                          ? StepState.complete
                          : StepState.indexed,
                    ),
                    Step(
                      title: const Text("كلمة المرور"),
                      content: _buildCard([
                        _buildTextField(
                          "كلمة المرور",
                          Icons.lock,
                          isPassword: true,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          "تأكيد كلمة المرور",
                          Icons.lock_clock,
                          isPassword: true,
                        ),
                      ]),
                      isActive: _currentStep >= 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField(
    String label,
    IconData icon, {
    bool isPassword = false,
  }) {
    return TextFormField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.cairo(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildDropdown(String label, IconData icon, List<String> items) {
    return DropdownButtonFormField<String>(
      initialValue: items.first,
      items: items
          .map(
            (item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: GoogleFonts.cairo()),
            ),
          )
          .toList(),
      onChanged: (val) {},
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.cairo(color: Colors.grey[600]),
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}

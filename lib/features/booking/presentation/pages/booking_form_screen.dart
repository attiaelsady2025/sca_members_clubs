
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_form_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_form_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class BookingFormScreen extends StatelessWidget {
  final Map<String, dynamic> service;

  const BookingFormScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingFormCubit>(),
      child: BookingFormView(service: service),
    );
  }
}

class BookingFormView extends StatelessWidget {
  final Map<String, dynamic> service;
  final TextEditingController _notesController = TextEditingController();

  BookingFormView({super.key, required this.service});

  final List<String> _timeSlots = [
    "10:00 ص", "11:00 ص", "12:00 م", "01:00 م", 
    "02:00 م", "05:00 م", "06:00 م", "07:00 م", "08:00 م"
  ];

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      context.read<BookingFormCubit>().updateDate(picked);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: AppColors.success, size: 80),
            const SizedBox(height: 20),
            Text(
              "تم استلام طلب الحجز",
              style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "يمكنك متابعة حالة الطلب من شاشة حجوزاتي",
              textAlign: TextAlign.center,
              style: GoogleFonts.cairo(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context, true); // Go back to booking list
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("حسناً", style: GoogleFonts.cairo(color: Colors.white)),
              ),
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
      appBar: AppBar(
        title: const Text("تأكيد الحجز"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: BlocConsumer<BookingFormCubit, BookingFormState>(
        listener: (context, state) {
          if (state is BookingFormSuccess) {
            _showSuccessDialog(context);
          }
           if (state is BookingFormError) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(state.message, style: GoogleFonts.cairo())),
             );
           }
        },
        builder: (context, state) {
          if (state is BookingFormSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final formState = state is BookingFormInitial ? state : null;
          if (formState == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Card Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      )
                    ]
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.calendar_month, color: AppColors.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(service['title'], 
                              style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(service['price'], 
                              style: GoogleFonts.cairo(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Date Selection
                Text("اختر التاريخ", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectDate(context, formState.selectedDate),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat('yyyy-MM-dd').format(formState.selectedDate),
                          style: GoogleFonts.cairo(fontSize: 16),
                        ),
                        const Spacer(),
                        const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Time Slots
                Text("اختر الوقت المتاح", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _timeSlots.map((time) {
                    final isSelected = formState.selectedTime == time;
                    return InkWell(
                      onTap: () => context.read<BookingFormCubit>().updateTime(time),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : Colors.grey[200]!,
                          ),
                        ),
                        child: Text(
                          time,
                          style: GoogleFonts.cairo(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Notes
                Text("ملاحظات إضافية", style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "أضف أي تفاصيل أخرى هنا...",
                    hintStyle: GoogleFonts.cairo(fontSize: 14, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () => context.read<BookingFormCubit>().submitBooking(service, _notesController.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Text(
                      "تأكيد الحجز",
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

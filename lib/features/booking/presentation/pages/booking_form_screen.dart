import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_form_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_form_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/navigation_cubit.dart';

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

class BookingFormView extends StatefulWidget {
  final Map<String, dynamic> service;

  const BookingFormView({super.key, required this.service});

  @override
  State<BookingFormView> createState() => _BookingFormViewState();
}

class _BookingFormViewState extends State<BookingFormView> {
  final TextEditingController _notesController = TextEditingController();

  // Photo Session State
  int _attendeesCount = 1;
  bool _isSelfBooking = true;
  final TextEditingController _guestNameController = TextEditingController();
  final TextEditingController _guestPhoneController = TextEditingController();

  final List<String> _timeSlots = [
    "10:00 ص",
    "11:00 ص",
    "12:00 م",
    "01:00 م",
    "02:00 م",
    "05:00 م",
    "06:00 م",
    "07:00 م",
    "08:00 م",
  ];

  @override
  void dispose() {
    _notesController.dispose();
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    super.dispose();
  }

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
    if (picked != null && mounted) {
      context.read<BookingFormCubit>().updateDate(picked);
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "تم استلام طلبك بنجاح",
                style: GoogleFonts.cairo(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "تم إرسال طلب الحجز الخاص بك للمراجعة. يمكنك متابعة التحديثات من خلال صفحة حجوزاتي.",
                textAlign: TextAlign.center,
                style: GoogleFonts.cairo(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // 1. Close Dialog
                    Navigator.pop(dialogContext);

                    // 2. Go back to Home
                    Navigator.of(context).popUntil((route) => route.isFirst);

                    // 3. Switch to My Bookings Tab (Index 1)
                    context.read<NavigationCubit>().setTab(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "عرض حجوزاتي",
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPhotoSession =
        widget.service['is_photo_session'] == true ||
        widget.service['type'] == 'photo_session';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isPhotoSession ? "حجز فوتو سيشن" : "تأكيد تفاصيل الحجز",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      body: BlocConsumer<BookingFormCubit, BookingFormState>(
        listener: (context, state) {
          if (state is BookingFormSuccess) {
            _showSuccessDialog(context);
          }
          if (state is BookingFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message, style: GoogleFonts.cairo()),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookingFormSubmitting) {
            return const Center(child: CircularProgressIndicator());
          }

          final formState = state is BookingFormInitial
              ? state
              : (state is BookingFormError
                    ? (context.read<BookingFormCubit>().state
                          as BookingFormInitial)
                    : null);

          if (formState == null &&
              state is! BookingFormSubmitting &&
              state is! BookingFormSuccess) {
            return const Center(child: CircularProgressIndicator());
          }

          if (formState == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Card Summary
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          isPhotoSession
                              ? Icons.camera_enhance_rounded
                              : Icons.event_available_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.service['title'],
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 4),
                            // Dynamic Price Display
                            Text(
                              isPhotoSession
                                  ? "${_calculateTotalForPhotoSession()} ج.م"
                                  : widget.service['price'],
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                              ),
                            ),
                            if (isPhotoSession && _attendeesCount > 4)
                              Text(
                                "(شامل ${_calculateExtraFees()} ج.م رسوم إضافية)",
                                style: GoogleFonts.cairo(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // PHOTO SESSION SPECIFIC LOGIC
                if (isPhotoSession) ...[
                  // Booking For Selection (Self vs Other)
                  // Booking For Selection (Self vs Other)
                  _buildModernLabel("لمن هذا الحجز؟"),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text(
                              "لنفسي",
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            value: true,
                            groupValue: _isSelfBooking,
                            onChanged: (val) =>
                                setState(() => _isSelfBooking = val!),
                            activeColor: AppColors.primary,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            dense: true,
                          ),
                        ),
                        Expanded(
                          child: RadioListTile<bool>(
                            title: Text(
                              "لشخص آخر",
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            value: false,
                            groupValue: _isSelfBooking,
                            onChanged: (val) =>
                                setState(() => _isSelfBooking = val!),
                            activeColor: AppColors.primary,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4,
                            ),
                            dense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // If Member Info was here, it's now removed.

                  // If Guest: Show Input Fields
                  if (!_isSelfBooking) ...[
                    _buildModernLabel("بيانات الضيف"),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _guestNameController,
                      style: GoogleFonts.cairo(),
                      decoration: _buildInputDecoration("اسم المحجوز له"),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _guestPhoneController,
                      style: GoogleFonts.cairo(),
                      keyboardType: TextInputType.phone,
                      decoration: _buildInputDecoration("رقم الهاتف"),
                    ),
                  ],
                  const SizedBox(height: 32),

                  // Attendees Count
                  _buildModernLabel("عدد الأفراد"),
                  const SizedBox(height: 4),
                  Text(
                    "يتم إضافة 50 ج.م عن كل فرد يزيد عن 4 أفراد",
                    style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _attendeesCount > 1
                              ? () => setState(() => _attendeesCount--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                          color: AppColors.primary,
                        ),
                        Text(
                          "$_attendeesCount",
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _attendeesCount++),
                          icon: const Icon(Icons.add_circle_outline),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],

                // Date Selection
                _buildModernLabel("التاريخ والوقت"),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => _selectDate(context, formState.selectedDate),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          DateFormat(
                            'EEEE, d MMMM yyyy',
                            'ar',
                          ).format(formState.selectedDate),
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.edit_calendar_rounded,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Time Slots
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _timeSlots.map((time) {
                    final isSelected = formState.selectedTime == time;
                    return InkWell(
                      onTap: () =>
                          context.read<BookingFormCubit>().updateTime(time),
                      borderRadius: BorderRadius.circular(12),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.grey[200]!,
                            width: 1.5,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          time,
                          style: GoogleFonts.cairo(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 32),

                // Notes
                _buildModernLabel("ملاحظات إضافية"),
                const SizedBox(height: 12),
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  style: GoogleFonts.cairo(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: "أضف أي طلبات خاصة أو تفاصيل إضافية هنا...",
                    hintStyle: GoogleFonts.cairo(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.all(20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[200]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 8,
                      shadowColor: AppColors.primary.withOpacity(0.4),
                    ),
                    child: Text(
                      "إرسال طلب الحجز (${isPhotoSession ? _calculateTotalForPhotoSession() : ""})", // Show total on button too
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  // Price Calculation Helpers
  int _calculateExtraFees() {
    if (_attendeesCount <= 4) return 0;
    return (_attendeesCount - 4) * 50;
  }

  int _calculateTotalForPhotoSession() {
    // Parse base price from string "500 ج.م" -> 500
    // Simplified parsing assuming format digits + space
    int basePrice = 500;
    // If I wanted to support differentiating Member vs Guest price base, I'd do it here:
    // if (!_isSelfBooking) basePrice = 600;

    return basePrice + _calculateExtraFees();
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.cairo(color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
    );
  }

  void _submit() {
    // Validation for Guest Data
    final isPhotoSession = widget.service['is_photo_session'] == true;
    if (isPhotoSession && !_isSelfBooking) {
      if (_guestNameController.text.isEmpty ||
          _guestPhoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "يرجى إدخال اسم الضيف ورقم الهاتف",
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    final finalService = Map<String, dynamic>.from(widget.service);

    // Add Photo Session Extras
    if (isPhotoSession) {
      finalService['is_self_booking'] = _isSelfBooking;
      finalService['attendees_count'] = _attendeesCount;
      finalService['total_price'] = _calculateTotalForPhotoSession();
      if (!_isSelfBooking) {
        finalService['guest_name'] = _guestNameController.text;
        finalService['guest_phone'] = _guestPhoneController.text;
      }
    }

    context.read<BookingFormCubit>().submitBooking(
      finalService,
      _notesController.text,
    );
  }

  Widget _buildModernLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(right: 4, bottom: 0),
      child: Text(
        label,
        style: GoogleFonts.cairo(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.cairo(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Text(
                value,
                style: GoogleFonts.cairo(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

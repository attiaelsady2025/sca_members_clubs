
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/live_booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/live_booking_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class LiveBookingScreen extends StatelessWidget {
  const LiveBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<LiveBookingCubit>()..loadCourts(),
      child: const LiveBookingView(),
    );
  }
}

class LiveBookingView extends StatelessWidget {
  const LiveBookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "حجز الملاعب المباشر"),
      body: BlocConsumer<LiveBookingCubit, LiveBookingState>(
        listener: (context, state) {
          if (state is LiveBookingSuccess) {
            _showSuccessDialog(context);
          }
           if (state is LiveBookingError) {
             ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(state.message, style: GoogleFonts.cairo())),
             );
           }
        },
        builder: (context, state) {
          if (state is LiveBookingLoading || state is LiveBookingInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LiveBookingCourtsLoaded) {
            return _buildContent(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, LiveBookingCourtsLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1: Court Selection
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "اختر الملعب",
            style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: state.courts.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final court = state.courts[index];
              final isSelected = state.selectedCourt?['id'] == court['id'];
              return InkWell(
                onTap: () => context.read<LiveBookingCubit>().selectCourt(court),
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.withOpacity(0.2)),
                    boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10)] : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        court['type'] == 'tennis' ? Icons.sports_tennis : 
                        court['type'] == 'padel' ? Icons.sports_tennis_rounded : Icons.sports_soccer,
                        color: isSelected ? Colors.white : AppColors.primary,
                        size: 30,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        court['name'],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Section 2: Slot Selection
        Expanded(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            ),
            child: state.selectedCourt == null 
              ? Center(child: Text("يرجى اختيار ملعب لعرض المواعيد المتاحة", style: GoogleFonts.cairo(color: Colors.grey)))
              : state.isLoadingSlots 
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "المواعيد المتاحة لليوم",
                            style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.info_outline, size: 18, color: Colors.grey),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (state.slots.isEmpty)
                        Center(child: Text("لا توجد مواعيد متاحة حالياً لليوم", style: GoogleFonts.cairo(color: Colors.grey)))
                      else
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: state.slots.length,
                            itemBuilder: (context, index) {
                              final slot = state.slots[index];
                              final isAvailable = slot['is_available'];
                              final isSelected = state.selectedSlot == slot;
                              
                              return InkWell(
                                onTap: isAvailable ? () => context.read<LiveBookingCubit>().selectSlot(slot) : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected 
                                        ? AppColors.primary 
                                        : isAvailable ? Colors.white : Colors.grey[100],
                                    border: Border.all(
                                      color: isSelected 
                                          ? AppColors.primary 
                                          : isAvailable ? AppColors.primary.withOpacity(0.3) : Colors.transparent
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      slot['time'],
                                      style: GoogleFonts.cairo(
                                        color: isSelected 
                                            ? Colors.white 
                                            : isAvailable ? AppColors.textPrimary : Colors.grey,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      
                      if (state.selectedSlot != null) ...[
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: AppColors.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "لقد اخترت ${state.selectedCourt!['name']} الساعة ${state.selectedSlot!['time']} بسعر ${state.selectedSlot!['price']}.",
                                  style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textPrimary),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        PrimaryButton(
                          text: "تأكيد الحجز والدفع",
                          onPressed: () => context.read<LiveBookingCubit>().confirmBooking(),
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("تم الحجز بنجاح", textAlign: TextAlign.center, style: GoogleFonts.cairo(color: AppColors.success)),
        content: Text("يمكنك مراجعة حجوزاتك من قائمة الحجوزات أو الصفحة الرئيسية.", textAlign: TextAlign.center, style: GoogleFonts.cairo()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Dismiss dialog
              Navigator.pop(context); // Return
            },
            child: Text("حسناً", style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

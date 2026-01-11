
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';
import '../widgets/service_card.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingCubit>()..loadBookingData(),
      child: const BookingView(),
    );
  }
}

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("حجوزاتي"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          centerTitle: true,
          bottom: TabBar(
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "سجل الحجوزات"),
              Tab(text: "حجز جديد"),
            ],
          ),
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is BookingError) {
              return Center(child: Text(state.message, style: GoogleFonts.cairo()));
            }
            if (state is BookingLoaded) {
              return Column(
                children: [
                  // Membership Type Selector
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.card_membership, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Text("نوع العضوية:", style: GoogleFonts.cairo(color: AppColors.textPrimary)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: state.currentMembership,
                              isDense: true,
                              style: GoogleFonts.cairo(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                              items: state.membershipTypes.map((type) {
                                return DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  context.read<BookingCubit>().updateMembership(val);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("تم تغيير نوع العضوية إلى: $val", style: GoogleFonts.cairo())),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildMyBookings(state.myBookings),
                        _buildServiceList(context),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildMyBookings(List<Map<String, dynamic>> bookings) {
    if (bookings.isEmpty) {
      return Center(child: Text("لا توجد حجوزات سابقة", style: GoogleFonts.cairo()));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final booking = bookings[index];
        final isCompleted = booking['status'] == "مكتمل";
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border(right: BorderSide(
              color: isCompleted ? Colors.grey : AppColors.success,
              width: 4
            )),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    booking['service_name'],
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isCompleted ? Colors.grey[200] : AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      booking['status'],
                      style: GoogleFonts.cairo(
                        fontSize: 12,
                        color: isCompleted ? Colors.grey : AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(booking['date'], style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey)),
                  const SizedBox(width: 16),
                  if (booking['time'] != "---") ...[
                    const Icon(Icons.access_time, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(booking['time'], style: GoogleFonts.cairo(fontSize: 14, color: Colors.grey)),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              Text(
                booking['price'],
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildServiceList(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ServiceCard(
          title: "ملعب كرة قدم خماسي",
          price: "150 ج.م / ساعة",
          imageUrl: "assets/images/club_social.jpg",
          onTap: () async {
            final result = await Navigator.pushNamed(
              context, 
              '/booking_form',
              arguments: {"title": "ملعب كرة قدم خماسي", "price": "150 ج.م / ساعة"}
            );
            if (result == true) {
              context.read<BookingCubit>().loadBookingData();
            }
          },
        ),
        ServiceCard(
          title: "حمام السباحة الأوليمبي",
          price: "50 ج.م / فرد",
          imageUrl: "assets/images/pool.jpg",
          onTap: () async {
            final result = await Navigator.pushNamed(
              context, 
              '/booking_form',
              arguments: {"title": "حمام السباحة الأوليمبي", "price": "50 ج.م / فرد"}
            );
            if (result == true) {
              context.read<BookingCubit>().loadBookingData();
            }
          },
        ),
        ServiceCard(
          title: "قاعة المناسبات",
          price: "تبدأ من 2000 ج.م",
          imageUrl: "assets/images/club_rowing.jpg",
          onTap: () async {
            final result = await Navigator.pushNamed(
              context, 
              '/booking_form',
              arguments: {"title": "قاعة المناسبات", "price": "تبدأ من 2000 ج.م"}
            );
            if (result == true) {
              context.read<BookingCubit>().loadBookingData();
            }
          },
        ),
      ],
    );
  }
}

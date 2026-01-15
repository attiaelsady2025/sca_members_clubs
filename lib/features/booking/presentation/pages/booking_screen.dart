import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/service.dart';
import 'package:sca_members_clubs/core/routes/app_routes.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "حجز خدمة جديدة",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is BookingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(state.message, style: GoogleFonts.cairo()),
                ],
              ),
            );
          }
          if (state is BookingLoaded) {
            return _buildContent(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, BookingLoaded state) {
    // Services are now coming from the state (Repository), not hardcoded.
    final services = state.services;

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceActionCard(context, service);
      },
    );
  }

  Widget _buildServiceActionCard(BuildContext context, Service service) {
    final Color color = _getServiceColor(service.type);
    final IconData icon = _getServiceIcon(service.type);

    return InkWell(
      onTap: () {
        if (service.type == 'activities_schedule') {
          Navigator.pushNamed(
            context,
            Routes.clubSelection,
            arguments: {
              'targetRoute': Routes.activities,
              'title': 'مواعيد الأنشطة',
            },
          );
          return;
        }
        if (service.type == 'dining') {
          Navigator.pushNamed(
            context,
            Routes.clubSelection,
            arguments: {
              'targetRoute': Routes.dining,
              'title': 'المطاعم والكافيهات',
            },
          );
          return;
        }

        Navigator.pushNamed(
          context,
          '/booking_form',
          arguments: {
            "id": service.id,
            "title": service.title,
            "price": service.price,
            "type": service.type,
            "icon": icon,
            "color": color,
            "is_photo_session": service.type == 'photo_session',
          },
        );
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                service.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mapper helpers for UI presentation logic
  Color _getServiceColor(String type) {
    switch (type) {
      case 'photo_session':
        return Colors.purple;
      case 'football':
        return Colors.green;
      case 'pool':
        return Colors.blue;
      case 'events_hall':
        return Colors.orange;
      case 'table_tennis':
        return Colors.redAccent;
      case 'squash':
        return Colors.teal;
      case 'activities_schedule':
        return Colors.amber;
      case 'dining':
        return Colors.red;
      default:
        return AppColors.primary;
    }
  }

  IconData _getServiceIcon(String type) {
    switch (type) {
      case 'photo_session':
        return Icons.camera_enhance_rounded;
      case 'football':
        return Icons.sports_soccer_rounded;
      case 'pool':
        return Icons.pool_rounded;
      case 'events_hall':
        return Icons.celebration_rounded;
      case 'table_tennis':
        return Icons.sports_tennis_rounded;
      case 'squash':
        return Icons.sports_handball_rounded;
      case 'activities_schedule':
        return Icons.sports_kabaddi_rounded;
      case 'dining':
        return Icons.restaurant_rounded;
      default:
        return Icons.event;
    }
  }
}

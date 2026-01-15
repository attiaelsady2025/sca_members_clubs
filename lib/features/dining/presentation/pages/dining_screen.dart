import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/dining/presentation/cubit/dining_cubit.dart';
import 'package:sca_members_clubs/features/dining/presentation/cubit/dining_state.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/restaurant.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class DiningScreen extends StatelessWidget {
  const DiningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clubId =
        ModalRoute.of(context)?.settings.arguments as String? ?? "c1";

    return BlocProvider(
      create: (context) => sl<DiningCubit>()..loadRestaurants(clubId: clubId),
      child: const DiningView(),
    );
  }
}

class DiningView extends StatelessWidget {
  const DiningView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("المطاعم والكافيهات"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<DiningCubit, DiningState>(
        builder: (context, state) {
          if (state is DiningLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DiningError) {
            return Center(
              child: Text(state.message, style: GoogleFonts.cairo()),
            );
          }
          if (state is DiningLoaded) {
            final restaurants = state.restaurants;

            if (restaurants.isEmpty) {
              return Center(
                child: Text(
                  "لا توجد مطاعم متاحة حالياً",
                  style: GoogleFonts.cairo(),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: restaurants.length,
              separatorBuilder: (context, index) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final restaurant = restaurants[index];
                return _buildRestaurantCard(context, restaurant);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildRestaurantCard(BuildContext context, Restaurant restaurant) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/menu', arguments: restaurant);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Image Placeholder
            Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.restaurant, size: 50, color: Colors.grey),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        restaurant.name,
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "${restaurant.rating}",
                              style: GoogleFonts.cairo(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    restaurant.description,
                    style: GoogleFonts.cairo(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.deliveryTime,
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.delivery_dining,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "توصيل مجاني",
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/dining/presentation/cubit/dining_cubit.dart';
import 'package:sca_members_clubs/features/dining/presentation/cubit/dining_state.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/restaurant.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/menu_item.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurant = ModalRoute.of(context)!.settings.arguments as Restaurant;

    return BlocProvider(
      create: (context) => sl<DiningCubit>()..loadMenu(restaurant.id),
      child: MenuView(restaurant: restaurant),
    );
  }
}

class MenuView extends StatelessWidget {
  final Restaurant restaurant;
  const MenuView({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  restaurant.name,
                  style: GoogleFonts.cairo(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(color: Colors.grey[400]), // Image Placeholder
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: BlocBuilder<DiningCubit, DiningState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is DiningError) {
              return Center(
                child: Text("خطأ في التحميل", style: GoogleFonts.cairo()),
              );
            }
            if (state is MenuLoaded) {
              final menuItems = state.menu;
              if (menuItems.isEmpty) {
                return Center(
                  child: Text(
                    "لا توجد أصناف في القائمة",
                    style: GoogleFonts.cairo(),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: menuItems.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return _buildMenuItem(item);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          // Safe Area for iPhone X+
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الإجمالي",
                      style: GoogleFonts.cairo(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "0.00 ج.م",
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  text: "إتمام الطلب (0)",
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "سيتم تفعيل الطلب قريباً",
                          style: GoogleFonts.cairo(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(MenuItem item) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.description,
                  style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  "${item.price} ج.م",
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              // Add to cart logic
            },
            icon: const Icon(
              Icons.add_circle,
              color: AppColors.primary,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

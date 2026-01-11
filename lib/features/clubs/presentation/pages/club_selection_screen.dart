import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/clubs/presentation/cubit/club_selection_cubit.dart';
import 'package:sca_members_clubs/features/clubs/presentation/cubit/club_selection_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class ClubSelectionScreen extends StatelessWidget {
  const ClubSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ClubSelectionCubit>()..loadCities(),
      child: const ClubSelectionView(),
    );
  }
}

class ClubSelectionView extends StatelessWidget {
  const ClubSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClubSelectionCubit, ClubSelectionState>(
      builder: (context, state) {
        String? selectedCity;
        if (state is ClubSelectionClubsLoaded) {
          selectedCity = state.selectedCity;
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "مرحباً بك، عطية",
                        style: GoogleFonts.cairo(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (selectedCity != null)
                        IconButton(
                          icon: const Icon(Icons.refresh, color: AppColors.primary),
                          onPressed: () => context.read<ClubSelectionCubit>().resetSelection(),
                          tooltip: "تغيير المدينة",
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedCity == null ? "اختر المدينة" : "اختر النادي لـ $selectedCity",
                    style: GoogleFonts.cairo(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Expanded(
                    child: _buildBody(context, state),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ClubSelectionState state) {
    if (state is ClubSelectionLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ClubSelectionCitiesLoaded) {
      return _buildCityGrid(context, state.cities);
    }
    if (state is ClubSelectionClubsLoaded) {
      return _buildClubGrid(context, state.clubs);
    }
    if (state is ClubSelectionError) {
      return Center(child: Text(state.message, style: GoogleFonts.cairo()));
    }
    return const SizedBox.shrink();
  }

  Widget _buildCityGrid(BuildContext context, List<Map<String, dynamic>> cities) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 20,
        childAspectRatio: 2.5,
      ),
      itemCount: cities.length,
      itemBuilder: (context, index) {
        final city = cities[index];
        return InkWell(
          onTap: () => context.read<ClubSelectionCubit>().selectCity(city['name']),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primary.withBlue(150)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(
                    city['icon'],
                    size: 100,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(city['icon'], color: Colors.white, size: 30),
                      const SizedBox(width: 16),
                      Text(
                        city['name'],
                        style: GoogleFonts.cairo(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildClubGrid(BuildContext context, List<Map<String, dynamic>> clubs) {
    if (clubs.isEmpty) {
      return Center(
        child: Text(
          "لا توجد نوادي متاحة حالياً في هذه المدينة",
          style: GoogleFonts.cairo(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: clubs.length,
      itemBuilder: (context, index) {
        final club = clubs[index];
        return InkWell(
          onTap: () {
            Navigator.pushReplacementNamed(
              context,
              '/home',
              arguments: club['name'],
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: (club['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    club['icon'] as IconData,
                    size: 40,
                    color: club['color'] as Color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  club['name'] as String,
                  style: GoogleFonts.cairo(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:sca_members_clubs/features/profile/presentation/cubit/profile_state.dart';
import 'package:sca_members_clubs/core/routes/app_routes.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class FamilyListScreen extends StatelessWidget {
  const FamilyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: const FamilyListView(),
    );
  }
}

class FamilyListView extends StatelessWidget {
  const FamilyListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "أفراد الأسرة",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          if (state is ProfileError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "خطأ في تحميل البيانات",
                    style: GoogleFonts.cairo(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => context.read<ProfileCubit>().loadProfile(),
                    child: Text("إعادة المحاولة", style: GoogleFonts.cairo()),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileLoaded) {
            final members = state.familyMembers;

            if (members.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.family_restroom_rounded,
                      size: 64,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "لا يوجد أفراد مضافين حالياً",
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: members.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final member = members[index];
                return InkWell(
                  onTap: () {
                    // Pass the entity directly
                    Navigator.pushNamed(
                      context,
                      Routes.familyMembershipCard,
                      arguments: member,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: Colors.grey[100]!),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            image:
                                member.image.isNotEmpty &&
                                    member.image.startsWith('assets')
                                ? DecorationImage(
                                    image: AssetImage(member.image),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child:
                              member.image.isEmpty ||
                                  !member.image.startsWith('assets')
                              ? const Icon(
                                  Icons.person_rounded,
                                  color: Colors.grey,
                                  size: 30,
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.name,
                                style: GoogleFonts.cairo(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                member.relation,
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${member.age} سنة",
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, '/add_family_member');
          // In real app, we would refresh profile cubit here
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text(
          "إضافة فرد",
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

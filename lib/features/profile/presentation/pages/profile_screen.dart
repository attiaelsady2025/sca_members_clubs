import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:sca_members_clubs/features/profile/presentation/cubit/profile_state.dart';
import 'package:sca_members_clubs/features/auth/domain/entities/user_entity.dart';
import 'package:sca_members_clubs/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..loadProfile(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: state is ProfileLoading
              ? const Center(child: CircularProgressIndicator())
              : state is ProfileError
              ? Center(child: Text(state.message, style: GoogleFonts.cairo()))
              : state is ProfileLoaded
              ? _buildContent(context, state.userProfile)
              : const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, UserEntity profile) {
    return Stack(
      children: [
        // Header Background
        Container(
          height: 280,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
        ),

        SafeArea(
          child: Column(
            children: [
              // App Bar
              AppBar(
                title: const Text("حسابي"),
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                automaticallyImplyLeading: false,
              ),

              const SizedBox(height: 10),

              // Profile Info
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.background,
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    profile.name,
                    style: GoogleFonts.cairo(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "عضوية رقم: ${profile.id}",
                    style: GoogleFonts.cairo(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Content List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        _buildSection([
                          _buildProfileItem(
                            context,
                            Icons.family_restroom,
                            "أفراد الأسرة",
                            () {
                              Navigator.pushNamed(context, '/family_members');
                            },
                          ),
                          _buildProfileItem(
                            context,
                            Icons.history,
                            "سجل النشاطات",
                            () {
                              Navigator.pushNamed(context, '/activity_history');
                            },
                          ),
                        ]),

                        const SizedBox(height: 20),

                        _buildSection([
                          _buildProfileItem(
                            context,
                            Icons.settings,
                            "الإعدادات",
                            () {
                              Navigator.pushNamed(context, '/settings');
                            },
                          ),
                          _buildProfileItem(
                            context,
                            Icons.lock,
                            "تغيير كلمة المرور",
                            () {
                              Navigator.pushNamed(context, '/change_password');
                            },
                          ),
                          _buildProfileItem(
                            context,
                            Icons.language,
                            "اللغة",
                            () {
                              Navigator.pushNamed(context, '/settings');
                            },
                          ),
                        ]),

                        const SizedBox(height: 20),

                        _buildSection([
                          _buildProfileItem(
                            context,
                            Icons.help,
                            "المساعدة والدعم",
                            () {
                              Navigator.pushNamed(context, '/support');
                            },
                          ),
                          _buildProfileItem(
                            context,
                            Icons.logout,
                            "تسجيل الخروج",
                            () {
                              context.read<AuthCubit>().logout();
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (route) => false,
                              );
                            },
                            isDestructive: true,
                            showDivider: false,
                          ),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildProfileItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    bool isDestructive = false,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDestructive
                  ? AppColors.error.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: isDestructive ? AppColors.error : AppColors.primary,
              size: 22,
            ),
          ),
          title: Text(
            title,
            style: GoogleFonts.cairo(
              color: isDestructive ? AppColors.error : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 20,
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.only(
              right: 60,
            ), // Indent divider to align with text
            child: Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
          ),
      ],
    );
  }
}

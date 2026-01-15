import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/promo_banner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/navigation_cubit.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';
import '../widgets/greeting_widget.dart';
import '../widgets/membership_shortcut.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clubName =
        ModalRoute.of(context)?.settings.arguments as String? ??
        "النادى العام هيئة قناة السويس";

    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: HomeView(clubName: clubName),
    );
  }
}

class HomeView extends StatefulWidget {
  final String clubName;
  const HomeView({super.key, required this.clubName});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          extendBodyBehindAppBar: true,
          appBar: HomeAppBar(
            clubName: widget.clubName,
            onMapTap: () => _showMapSimulation(context, widget.clubName),
            onNotificationsTap: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          drawer: const AppDrawer(),
          body: RefreshIndicator(
            onRefresh: () => context.read<HomeCubit>().loadHomeData(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: kToolbarHeight + 20),

                  // Dynamic Greeting
                  FutureBuilder<Map<String, dynamic>>(
                    future: FirebaseService().getUserProfile(),
                    builder: (context, snapshot) {
                      final name = snapshot.data?['name'] ?? "عضو الهيئة";
                      return GreetingWidget(userName: name);
                    },
                  ),

                  // Promo Banner
                  if (state is HomeLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 160,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    )
                  else if (state is HomeLoaded)
                    Column(
                      children: [
                        PromoBanner(promos: state.promos),
                        const SizedBox(height: 24),
                        MembershipShortcut(clubName: widget.clubName),
                      ],
                    )
                  else
                    const SizedBox.shrink(),

                  const SizedBox(height: 32),

                  // Quick Actions Section
                  _buildSectionHeader("الخدمات السريعة"),
                  const SizedBox(height: 16),

                  // Grid
                  Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.82,
                            ),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          final services = [
                            _ServiceData(
                              Icons.mail_outline_rounded,
                              "دعوات الزوار",
                              AppColors.primary,
                              () {
                                Navigator.pushNamed(context, '/invitations');
                              },
                            ),
                            _ServiceData(
                              Icons.calendar_today_rounded,
                              "حجز خدمات",
                              const Color(0xFF0EA5E9),
                              () {
                                Navigator.pushNamed(context, '/booking');
                              },
                            ),
                            _ServiceData(
                              Icons.history_rounded,
                              "سجل الحجوزات",
                              const Color(0xFF8B5CF6),
                              () {
                                context.read<NavigationCubit>().setTab(1);
                              },
                            ),
                            _ServiceData(
                              Icons.payment_rounded,
                              "المدفوعات",
                              const Color(0xFF10B981),
                              () {
                                Navigator.pushNamed(context, '/payments');
                              },
                            ),
                            _ServiceData(
                              Icons.newspaper_rounded,
                              "الأخبار",
                              const Color(0xFFF59E0B),
                              () {
                                Navigator.pushNamed(context, '/news');
                              },
                            ),
                          ];
                          final s = services[index];
                          return _buildActionCard(
                            icon: s.icon,
                            label: s.label,
                            color: s.color,
                            onTap: s.onTap,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Recent News Section
                  if (state is HomeLoaded && state.news.isNotEmpty) ...[
                    _buildSectionHeader(
                      "أحدث الأخبار",
                      onSeeAllTap: () {
                        Navigator.pushNamed(context, '/news');
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 310,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        scrollDirection: Axis.horizontal,
                        itemCount: state.news.length,
                        itemBuilder: (context, index) {
                          final newsItem = state.news[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/article_detail',
                                arguments: newsItem,
                              );
                            },
                            child: Container(
                              width: 280,
                              margin: const EdgeInsets.only(left: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(24),
                                    ),
                                    child: Stack(
                                      children: [
                                        Image.network(
                                          newsItem.image,
                                          height: 150,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          loadingBuilder:
                                              (context, child, progress) {
                                                if (progress == null) {
                                                  return child;
                                                }
                                                return Container(
                                                  height: 150,
                                                  color: Colors.grey[50],
                                                  child: const Center(
                                                    child: SizedBox(
                                                      width: 24,
                                                      height: 24,
                                                      child:
                                                          CircularProgressIndicator(
                                                            strokeWidth: 2,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Container(
                                                  height: 150,
                                                  width: double.infinity,
                                                  color: Colors.grey[100],
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .image_not_supported_outlined,
                                                        color: Colors.grey[300],
                                                        size: 40,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        "الصورة غير متاحة",
                                                        style:
                                                            GoogleFonts.cairo(
                                                              fontSize: 10,
                                                              color: Colors
                                                                  .grey[400],
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                        ),
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(
                                                0.5,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              newsItem.date,
                                              style: GoogleFonts.cairo(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          newsItem.title,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.cairo(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                            height: 1.2,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          newsItem.description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.cairo(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                            height: 1.4,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            Text(
                                              "اقرأ المزيد",
                                              style: GoogleFonts.cairo(
                                                fontSize: 12,
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 10,
                                              color: AppColors.primary,
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
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, '/emergency');
            },
            backgroundColor: Colors.red[600],
            elevation: 8,
            icon: const Icon(
              Icons.emergency_share_rounded,
              color: Colors.white,
            ),
            label: Text(
              "طوارئ",
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onSeeAllTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          if (onSeeAllTap != null)
            TextButton(
              onPressed: onSeeAllTap,
              child: Text(
                "عرض المزيد",
                style: GoogleFonts.cairo(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cairo(
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  color: AppColors.textPrimary,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMapSimulation(BuildContext context, String clubName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "جاري فتح موقع ($clubName) على خرائط جوجل...",
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

class _ServiceData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  _ServiceData(this.icon, this.label, this.color, this.onTap);
}

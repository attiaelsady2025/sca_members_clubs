import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/app_drawer.dart';
import '../widgets/promo_banner.dart';
import '../widgets/home_bottom_nav.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/home_cubit.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/home_state.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clubName = ModalRoute.of(context)?.settings.arguments as String? ?? "النادي الاجتماعي";

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
  int _currentIndex = 0;

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
              padding: const EdgeInsets.only(top: 120),
              child: Column(
                children: [
            const SizedBox(height: 10),
             
            // Promo Banner
            if (state is HomeLoading)
              const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))
            else if (state is HomeLoaded)
              PromoBanner(promos: state.promos)
            else
              const SizedBox.shrink(),
            
            const SizedBox(height: 24),
            
            // Quick Actions Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                children: [
                  Text(
                    "الخدمات السريعة",
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.3,
              children: [
                _buildActionCard(
                  icon: Icons.people_outline,
                  label: "قائمة أسرتي",
                  color: Colors.pink,
                  onTap: () {
                    Navigator.pushNamed(context, '/family_members');
                  },
                ),
                _buildActionCard(
                  icon: Icons.mail_outline,
                  label: "دعوات الزوار",
                  color: AppColors.primary,
                  onTap: () {
                    Navigator.pushNamed(context, '/invitations');
                  },
                ),
                _buildActionCard(
                  icon: Icons.calendar_today,
                  label: "حجز الخدمات",
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(context, '/live_booking');
                  },
                ),
                _buildActionCard(
                  icon: Icons.payment,
                  label: "المدفوعات",
                  color: Colors.green,
                  onTap: () {
                    Navigator.pushNamed(context, '/payments');
                  },
                ),
                _buildActionCard(
                  icon: Icons.newspaper,
                  label: "الأخبار والفعاليات",
                  color: Colors.purple,
                  onTap: () {
                    Navigator.pushNamed(context, '/news');
                  },
                ),
                _buildActionCard(
                  icon: Icons.sports_handball,
                  label: "الأنشطة",
                  color: Colors.orange,
                  onTap: () {
                    Navigator.pushNamed(context, '/activities');
                  },
                ),
                _buildActionCard(
                  icon: Icons.map,
                  label: "خريطة النادي",
                  color: Colors.teal,
                  onTap: () {
                    Navigator.pushNamed(context, '/club_map');
                  },
                ),
                _buildActionCard(
                  icon: Icons.restaurant_menu,
                  label: "المطاعم",
                  color: Colors.redAccent,
                  onTap: () {
                    Navigator.pushNamed(context, '/dining');
                  },
                ),
                _buildActionCard(
                  icon: Icons.vignette,
                  label: "كارنيه العضوية",
                  color: Colors.indigo,
                  onTap: () {
                    Navigator.pushNamed(context, '/membership_card', arguments: widget.clubName);
                  },
                ),
                _buildActionCard(
                  icon: Icons.settings,
                  label: "الإعدادات",
                  color: Colors.grey,
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ),
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) Navigator.pushNamed(context, '/booking');
          if (index == 2) Navigator.pushNamed(context, '/profile');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/emergency');
        },
        backgroundColor: Colors.red[700],
        child: const Icon(Icons.emergency_share, color: Colors.white),
      ),
    );
  },
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
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              label,
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
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
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "فتح",
          textColor: Colors.white,
          onPressed: () {
            // Placeholder for real URL launching
          },
        ),
      ),
    );
  }
}

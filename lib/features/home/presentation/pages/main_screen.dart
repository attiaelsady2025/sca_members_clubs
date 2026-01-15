import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/home_bottom_nav.dart';
import 'home_screen.dart';
import '../../../booking/presentation/pages/my_bookings_screen.dart';
import '../../../profile/presentation/pages/profile_screen.dart';
import '../cubit/navigation_cubit.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    HomeScreen(),
    MyBookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(index: currentIndex, children: _pages),
          bottomNavigationBar: HomeBottomNav(
            currentIndex: currentIndex,
            onTap: (index) => context.read<NavigationCubit>().setTab(index),
          ),
        );
      },
    );
  }
}

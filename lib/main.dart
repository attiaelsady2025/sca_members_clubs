
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/auth/presentation/pages/register_screen.dart';
import 'features/home/presentation/pages/home_screen.dart';
import 'features/booking/presentation/pages/booking_screen.dart';
import 'features/booking/presentation/pages/booking_form_screen.dart';
import 'features/payments/presentation/pages/payments_screen.dart';
import 'features/notifications/presentation/pages/notifications_screen.dart';
import 'features/profile/presentation/pages/profile_screen.dart';
import 'features/profile/presentation/pages/family_members_screen.dart';
import 'features/membership/presentation/pages/gate_pass_screen.dart';
import 'features/invitations/presentation/pages/invitations_screen.dart';
import 'features/invitations/presentation/pages/create_invitation_screen.dart';
import 'features/news/presentation/pages/news_screen.dart';
import 'features/emergency/presentation/pages/emergency_screen.dart';
import 'features/complaints/presentation/pages/complaints_screen.dart';
import 'features/clubs/presentation/pages/club_selection_screen.dart';
import 'features/dining/presentation/pages/dining_screen.dart';
import 'features/dining/presentation/pages/menu_screen.dart';
import 'features/profile/presentation/pages/family_list_screen.dart';
import 'features/profile/presentation/pages/add_family_member_screen.dart';
import 'features/clubs/presentation/pages/club_map_screen.dart';
import 'features/activities/presentation/pages/activities_schedule_screen.dart';
import 'features/profile/presentation/pages/family_membership_card_screen.dart';
import 'features/membership/presentation/pages/membership_card_screen.dart';
import 'features/auth/presentation/pages/change_password_screen.dart';
import 'features/profile/presentation/pages/activity_history_screen.dart';
import 'features/profile/presentation/pages/support_screen.dart';
import 'features/news/presentation/pages/article_detail_screen.dart';
import 'features/profile/presentation/pages/settings_screen.dart';
import 'features/security/presentation/pages/security_scanner_screen.dart';
import 'features/security/presentation/pages/security_dashboard.dart';
import 'features/security/presentation/pages/security_invitations_screen.dart';
import 'features/security/presentation/pages/security_emergencies_screen.dart';
import 'features/security/presentation/pages/security_logs_screen.dart';
import 'features/booking/presentation/pages/live_booking_screen.dart';
import 'features/admin/presentation/pages/admin_dashboard.dart';
import 'features/admin/presentation/pages/admin_members_screen.dart';
import 'features/admin/presentation/pages/admin_invitation_screen.dart';
import 'features/admin/presentation/pages/admin_content_screen.dart';
import 'features/admin/presentation/pages/admin_booking_screen.dart';
import 'features/admin/presentation/pages/admin_complaints_screen.dart';
import 'features/admin/presentation/pages/admin_broadcast_screen.dart';
import 'features/admin/presentation/pages/admin_analytics_screen.dart';
import 'features/admin/presentation/pages/admin_logs_screen.dart';
import 'features/admin/presentation/pages/admin_staff_screen.dart';
import 'features/admin/presentation/pages/admin_verification_screen.dart';
import 'features/admin/presentation/pages/admin_shifts_screen.dart';
import 'features/admin/presentation/pages/admin_official_guests_screen.dart';
import 'features/admin/presentation/pages/admin_users_screen.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const SCAMembersApp());
}

class SCAMembersApp extends StatelessWidget {
  const SCAMembersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appNameEn,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      locale: const Locale('ar', 'EG'),
      supportedLocales: const [
        Locale('ar', 'EG'),
        Locale('en', 'US'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/booking': (context) => const BookingScreen(),
        '/payments': (context) => const PaymentsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/gate_pass': (context) => const GatePassScreen(),
        '/invitations': (context) => const InvitationsScreen(),
        '/create_invitation': (context) => const CreateInvitationScreen(),
        '/live_booking': (context) => const LiveBookingScreen(),
        '/admin': (context) => const AdminDashboard(),
        '/admin_members': (context) => const AdminMembersScreen(),
        '/admin_invitations': (context) => const AdminInvitationRequestsScreen(),
        '/admin_content': (context) => const AdminContentScreen(),
        '/admin_booking': (context) => const AdminBookingScreen(),
        '/admin_complaints': (context) => const AdminComplaintsScreen(),
        '/admin_broadcast': (context) => const AdminBroadcastScreen(),
        '/admin_analytics': (context) => const AdminAnalyticsScreen(),
        '/admin_logs': (context) => const AdminLogsScreen(),
        '/admin_staff': (context) => const AdminStaffScreen(),
        '/admin_verification': (context) => const AdminVerificationScreen(),
        '/admin_shifts': (context) => const AdminShiftsScreen(),
        '/admin_official_guests': (context) => const AdminOfficialGuestsScreen(),
        '/admin_users': (context) => const AdminUsersScreen(),
        '/news': (context) => const NewsScreen(),
        '/emergency': (context) => const EmergencyScreen(),
        '/complaints': (context) => const ComplaintsScreen(),
        '/clubs': (context) => const ClubSelectionScreen(),
        '/dining': (context) => const DiningScreen(),
        '/menu': (context) => const MenuScreen(),
        '/family_members': (context) => const FamilyListScreen(),
        '/add_family_member': (context) => const AddFamilyMemberScreen(),
        '/club_map': (context) => const ClubMapScreen(),
        '/activities': (context) => const ActivitiesScheduleScreen(),
        '/settings': (context) => SettingsScreen(),
        '/membership_card': (context) => const MembershipCardScreen(),
        '/family_membership_card': (context) => const FamilyMembershipCardScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/activity_history': (context) => const ActivityHistoryScreen(),
        '/support': (context) => const SupportScreen(),
        '/article_detail': (context) => const ArticleDetailScreen(),
        '/security_scanner': (context) => const SecurityScannerScreen(),
        '/security_dashboard': (context) => const SecurityDashboard(),
        '/security_invitations': (context) => const SecurityInvitationsScreen(),
        '/security_emergencies': (context) => const SecurityEmergenciesScreen(),
        '/security_logs': (context) => const SecurityLogsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/booking_form') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => BookingFormScreen(service: args),
          );
        }
        return null; // Let standard routes handle it
      },
    );
  }
}

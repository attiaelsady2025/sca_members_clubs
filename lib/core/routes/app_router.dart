import 'package:flutter/material.dart';
import 'package:sca_members_clubs/features/auth/presentation/pages/splash_screen.dart';
import 'package:sca_members_clubs/features/auth/presentation/pages/login_screen.dart';
import 'package:sca_members_clubs/features/auth/presentation/pages/register_screen.dart';
import 'package:sca_members_clubs/features/home/presentation/pages/main_screen.dart';
import 'package:sca_members_clubs/features/booking/presentation/pages/booking_screen.dart';
import 'package:sca_members_clubs/features/booking/presentation/pages/my_bookings_screen.dart';
import 'package:sca_members_clubs/features/booking/presentation/pages/booking_form_screen.dart';
import 'package:sca_members_clubs/features/payments/presentation/pages/payments_screen.dart';
import 'package:sca_members_clubs/features/notifications/presentation/pages/notifications_screen.dart';
import 'package:sca_members_clubs/features/profile/presentation/pages/profile_screen.dart';
import 'package:sca_members_clubs/features/membership/presentation/pages/gate_pass_screen.dart';
import 'package:sca_members_clubs/features/invitations/presentation/pages/invitations_screen.dart';
import 'package:sca_members_clubs/features/invitations/presentation/pages/invitations_history_screen.dart';
import 'package:sca_members_clubs/features/invitations/presentation/pages/create_invitation_screen.dart';
import 'package:sca_members_clubs/features/news/presentation/pages/news_screen.dart';
import 'package:sca_members_clubs/features/emergency/presentation/pages/emergency_screen.dart';
import 'package:sca_members_clubs/features/complaints/presentation/pages/complaints_screen.dart';
import 'package:sca_members_clubs/features/dining/presentation/pages/dining_screen.dart';
import 'package:sca_members_clubs/features/dining/presentation/pages/menu_screen.dart';
import 'package:sca_members_clubs/features/profile/presentation/pages/family_list_screen.dart';
import 'package:sca_members_clubs/features/profile/presentation/pages/add_family_member_screen.dart';
import 'package:sca_members_clubs/features/activities/presentation/pages/activities_schedule_screen.dart';
import 'package:sca_members_clubs/features/profile/domain/entities/family_member.dart';
import 'package:sca_members_clubs/features/home/presentation/pages/club_selection_screen.dart';
import 'package:sca_members_clubs/features/profile/presentation/pages/family_membership_card_screen.dart';
import 'package:sca_members_clubs/features/membership/presentation/pages/membership_card_screen.dart';
import 'package:sca_members_clubs/features/auth/presentation/pages/change_password_screen.dart';
import 'package:sca_members_clubs/features/profile/presentation/pages/activity_history_screen.dart';
import 'package:sca_members_clubs/features/profile/presentation/pages/support_screen.dart';
import 'package:sca_members_clubs/features/news/presentation/pages/article_detail_screen.dart';
import 'package:sca_members_clubs/features/profile/presentation/pages/settings_screen.dart';
import 'package:sca_members_clubs/features/security/presentation/pages/security_scanner_screen.dart';
import 'package:sca_members_clubs/features/security/presentation/pages/security_dashboard.dart';
import 'package:sca_members_clubs/features/security/presentation/pages/security_invitations_screen.dart';
import 'package:sca_members_clubs/features/security/presentation/pages/security_emergencies_screen.dart';
import 'package:sca_members_clubs/features/security/presentation/pages/security_logs_screen.dart';
import 'package:sca_members_clubs/features/booking/presentation/pages/live_booking_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_members_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_invitation_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_content_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_booking_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_complaints_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_broadcast_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_analytics_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_logs_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_staff_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_verification_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_shifts_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_official_guests_screen.dart';
import 'package:sca_members_clubs/features/admin/presentation/pages/admin_users_screen.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Defines Routes that need arguments here if specific handling is required
    if (settings.name == Routes.bookingForm) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => BookingFormScreen(service: args),
      );
    }

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case Routes.booking:
        return MaterialPageRoute(builder: (_) => const BookingScreen());
      case Routes.myBookings:
        return MaterialPageRoute(builder: (_) => const MyBookingsScreen());
      case Routes.payments:
        return MaterialPageRoute(builder: (_) => const PaymentsScreen());
      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.gatePass:
        return MaterialPageRoute(builder: (_) => const GatePassScreen());
      case Routes.invitations:
        return MaterialPageRoute(builder: (_) => const InvitationsScreen());
      case Routes.createInvitation:
        return MaterialPageRoute(
          builder: (_) => const CreateInvitationScreen(),
        );
      case Routes.invitationsHistory:
        return MaterialPageRoute(
          builder: (_) => const InvitationsHistoryScreen(),
        );
      case Routes.liveBooking:
        return MaterialPageRoute(builder: (_) => const LiveBookingScreen());
      case Routes.admin:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case Routes.adminMembers:
        return MaterialPageRoute(builder: (_) => const AdminMembersScreen());
      case Routes.adminInvitations:
        return MaterialPageRoute(
          builder: (_) => const AdminInvitationRequestsScreen(),
        );
      case Routes.adminContent:
        return MaterialPageRoute(builder: (_) => const AdminContentScreen());
      case Routes.adminBooking:
        return MaterialPageRoute(builder: (_) => const AdminBookingScreen());
      case Routes.adminComplaints:
        return MaterialPageRoute(builder: (_) => const AdminComplaintsScreen());
      case Routes.adminBroadcast:
        return MaterialPageRoute(builder: (_) => const AdminBroadcastScreen());
      case Routes.adminAnalytics:
        return MaterialPageRoute(builder: (_) => const AdminAnalyticsScreen());
      case Routes.adminLogs:
        return MaterialPageRoute(builder: (_) => const AdminLogsScreen());
      case Routes.adminStaff:
        return MaterialPageRoute(builder: (_) => const AdminStaffScreen());
      case Routes.adminVerification:
        return MaterialPageRoute(
          builder: (_) => const AdminVerificationScreen(),
        );
      case Routes.adminShifts:
        return MaterialPageRoute(builder: (_) => const AdminShiftsScreen());
      case Routes.adminOfficialGuests:
        return MaterialPageRoute(
          builder: (_) => const AdminOfficialGuestsScreen(),
        );
      case Routes.adminUsers:
        return MaterialPageRoute(builder: (_) => const AdminUsersScreen());
      case Routes.news:
        return MaterialPageRoute(builder: (_) => const NewsScreen());
      case Routes.emergency:
        return MaterialPageRoute(builder: (_) => const EmergencyScreen());
      case Routes.complaints:
        return MaterialPageRoute(builder: (_) => const ComplaintsScreen());
      case Routes.dining:
        return MaterialPageRoute(builder: (_) => const DiningScreen());
      case Routes.menu:
        return MaterialPageRoute(builder: (_) => const MenuScreen());
      case Routes.familyMembers:
        return MaterialPageRoute(builder: (_) => const FamilyListScreen());
      case Routes.addFamilyMember:
        return MaterialPageRoute(builder: (_) => const AddFamilyMemberScreen());
      case Routes.activities:
        return MaterialPageRoute(
          builder: (_) => const ActivitiesScheduleScreen(),
        );
      case Routes.clubSelection:
        return MaterialPageRoute(
          builder: (_) => const ClubSelectionScreen(),
          settings: settings,
        );
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => SettingsScreen());
      case Routes.membershipCard:
        return MaterialPageRoute(builder: (_) => const MembershipCardScreen());
      case Routes.familyMembershipCard:
        final member = settings.arguments as FamilyMember?;
        return MaterialPageRoute(
          builder: (_) => FamilyMembershipCardScreen(member: member),
          settings: settings,
        );
      case Routes.changePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      case Routes.activityHistory:
        return MaterialPageRoute(builder: (_) => const ActivityHistoryScreen());
      case Routes.support:
        return MaterialPageRoute(builder: (_) => const SupportScreen());
      case Routes.articleDetail:
        return MaterialPageRoute(
          builder: (_) => const ArticleDetailScreen(),
          settings: settings,
        );
      case Routes.securityScanner:
        return MaterialPageRoute(builder: (_) => const SecurityScannerScreen());
      case Routes.securityDashboard:
        return MaterialPageRoute(builder: (_) => const SecurityDashboard());
      case Routes.securityInvitations:
        return MaterialPageRoute(
          builder: (_) => const SecurityInvitationsScreen(),
        );
      case Routes.securityEmergencies:
        return MaterialPageRoute(
          builder: (_) => const SecurityEmergenciesScreen(),
        );
      case Routes.securityLogs:
        return MaterialPageRoute(builder: (_) => const SecurityLogsScreen());

      // Default Route
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}

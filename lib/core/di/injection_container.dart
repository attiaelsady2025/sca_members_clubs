
import 'package:get_it/get_it.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/home_cubit.dart';
import 'package:sca_members_clubs/features/clubs/presentation/cubit/club_selection_cubit.dart';
import 'package:sca_members_clubs/features/news/presentation/cubit/news_cubit.dart';
import 'package:sca_members_clubs/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:sca_members_clubs/features/dining/presentation/cubit/dining_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/live_booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_form_cubit.dart';

final sl = GetIt.instance; // sl: Service Locator

Future<void> init() async {
  // Services
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());

  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => HomeCubit(sl()));
  sl.registerFactory(() => ClubSelectionCubit(sl()));
  sl.registerFactory(() => NewsCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));
  sl.registerFactory(() => DiningCubit(sl()));
  sl.registerFactory(() => BookingCubit(sl()));
  sl.registerFactory(() => LiveBookingCubit(sl()));
  sl.registerFactory(() => BookingFormCubit(sl()));
}

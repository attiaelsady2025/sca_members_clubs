import 'package:get_it/get_it.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/home_cubit.dart';
import 'package:sca_members_clubs/features/news/presentation/cubit/news_cubit.dart';
import 'package:sca_members_clubs/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:sca_members_clubs/features/dining/presentation/cubit/dining_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/live_booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_form_cubit.dart';

// Repositories
import 'package:sca_members_clubs/features/booking/domain/repositories/booking_repository.dart';
import 'package:sca_members_clubs/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:sca_members_clubs/features/auth/domain/repositories/auth_repository.dart';
import 'package:sca_members_clubs/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:sca_members_clubs/features/profile/domain/repositories/profile_repository.dart';
import 'package:sca_members_clubs/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:sca_members_clubs/features/news/domain/repositories/news_repository.dart';
import 'package:sca_members_clubs/features/news/data/repositories/news_repository_impl.dart';
import 'package:sca_members_clubs/features/dining/domain/repositories/dining_repository.dart';
import 'package:sca_members_clubs/features/dining/data/repositories/dining_repository_impl.dart';

// Data Sources
import 'package:sca_members_clubs/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:sca_members_clubs/features/auth/data/datasources/auth_remote_data_source_impl.dart';

final sl = GetIt.instance; // sl: Service Locator

Future<void> init() async {
  // Services
  sl.registerLazySingleton<FirebaseService>(() => FirebaseService());

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );

  // Repositories
  sl.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<NewsRepository>(() => NewsRepositoryImpl(sl()));
  sl.registerLazySingleton<DiningRepository>(() => DiningRepositoryImpl(sl()));

  // Cubits
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => HomeCubit(sl()));
  sl.registerFactory(() => NewsCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));
  sl.registerFactory(() => DiningCubit(sl()));
  sl.registerFactory(() => BookingCubit(sl()));
  sl.registerFactory(() => LiveBookingCubit(sl()));
  sl.registerFactory(() => BookingFormCubit(sl()));
}

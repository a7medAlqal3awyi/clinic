import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/api_client.dart';

// Auth
import '../../features/authentication/data/datasource/auth_local_data_source.dart';
import '../../features/authentication/data/repositories/auth_repository_impl.dart';
import '../../features/authentication/domain/repositories/auth_repository.dart';
import '../../features/authentication/domain/usecases/auth_usecases.dart';
import '../../features/authentication/presentation/cubit/auth_cubit.dart';

// Nutrition Plan
import '../../features/nutrition_plan/data/datasource/nutrition_plan_local_data_source.dart';
import '../../features/nutrition_plan/data/repositories/nutrition_plan_repository_impl.dart';
import '../../features/nutrition_plan/domain/repositories/nutrition_plan_repository.dart';
import '../../features/nutrition_plan/domain/usecases/nutrition_plan_usecases.dart';
import '../../features/nutrition_plan/presentation/cubit/nutrition_plan_cubit.dart';

// Progress
import '../../features/progress_tracking/data/datasource/progress_local_data_source.dart';
import '../../features/progress_tracking/data/repositories/progress_repository_impl.dart';
import '../../features/progress_tracking/domain/repositories/progress_repository.dart';
import '../../features/progress_tracking/domain/usecases/progress_usecases.dart';
import '../../features/progress_tracking/presentation/cubit/progress_cubit.dart';

// Communication
import '../../features/communication/data/datasource/communication_local_data_source.dart';
import '../../features/communication/data/repositories/communication_repository_impl.dart';
import '../../features/communication/domain/repositories/communication_repository.dart';
import '../../features/communication/domain/usecases/communication_usecases.dart';
import '../../features/communication/presentation/cubit/communication_cubit.dart';

// Subscriptions
import '../../features/subscriptions/data/datasource/subscription_local_data_source.dart';
import '../../features/subscriptions/data/repositories/subscription_repository_impl.dart';
import '../../features/subscriptions/domain/repositories/subscription_repository.dart';
import '../../features/subscriptions/domain/usecases/subscription_usecases.dart';
import '../../features/subscriptions/presentation/cubit/subscription_cubit.dart';

// Followup
import '../../features/online_followup/data/datasource/online_followup_local_data_source.dart';
import '../../features/online_followup/data/repositories/online_followup_repository_impl.dart';
import '../../features/online_followup/domain/repositories/online_followup_repository.dart';
import '../../features/online_followup/domain/usecases/online_followup_usecases.dart';
import '../../features/online_followup/presentation/cubit/online_followup_cubit.dart';

// Notifications
import '../../features/notifications/data/datasource/notification_local_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/domain/usecases/notification_usecases.dart';
import '../../features/notifications/presentation/cubit/notification_cubit.dart';

// Profile
import '../../features/profile/presentation/cubit/profile_cubit.dart';

final sl = GetIt.instance;

Future<void> initServiceLocator() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Data Sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NutritionPlanLocalDataSource>(
    () => NutritionPlanLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ProgressLocalDataSource>(
    () => ProgressLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<CommunicationLocalDataSource>(
    () => CommunicationLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<SubscriptionLocalDataSource>(
    () => SubscriptionLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<OnlineFollowupLocalDataSource>(
    () => OnlineFollowupLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<NotificationLocalDataSource>(
    () => NotificationLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<NutritionPlanRepository>(
    () => NutritionPlanRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<CommunicationRepository>(
    () => CommunicationRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<OnlineFollowupRepository>(
    () => OnlineFollowupRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(localDataSource: sl()),
  );

  // UseCases - Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterOnlineUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));

  // UseCases - Nutrition
  sl.registerLazySingleton(() => GetCurrentPlanUseCase(sl()));
  sl.registerLazySingleton(() => ToggleMealCompletionUseCase(sl()));
  sl.registerLazySingleton(() => UpdateMealNotesUseCase(sl()));

  // UseCases - Progress
  sl.registerLazySingleton(() => GetWeightHistoryUseCase(sl()));
  sl.registerLazySingleton(() => AddWeightUseCase(sl()));
  sl.registerLazySingleton(() => GetInBodyReportsUseCase(sl()));
  sl.registerLazySingleton(() => AddInBodyReportUseCase(sl()));
  sl.registerLazySingleton(() => GetClinicVisitsUseCase(sl()));

  // UseCases - Communication
  sl.registerLazySingleton(() => GetChatMessagesUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(sl()));

  // UseCases - Subscriptions
  sl.registerLazySingleton(() => GetPackagesUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentRequestsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitBankTransferUseCase(sl()));

  // UseCases - Online Followup
  sl.registerLazySingleton(() => GetFollowupsUseCase(sl()));
  sl.registerLazySingleton(() => SubmitFollowupUseCase(sl()));

  // UseCases - Notifications
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationAsReadUseCase(sl()));
  sl.registerLazySingleton(() => MarkAllNotificationsAsReadUseCase(sl()));

  // Cubits (Factory registration for UI reactivity)
  sl.registerFactory(() => AuthCubit(
        loginUseCase: sl(),
        registerOnlineUseCase: sl(),
        getCurrentUserUseCase: sl(),
        logoutUseCase: sl(),
        updateProfileUseCase: sl(),
      ));

  sl.registerFactory(() => NutritionPlanCubit(
        getCurrentPlanUseCase: sl(),
        toggleMealCompletionUseCase: sl(),
        updateMealNotesUseCase: sl(),
      ));

  sl.registerFactory(() => ProgressCubit(
        getWeightHistoryUseCase: sl(),
        addWeightUseCase: sl(),
        getInBodyReportsUseCase: sl(),
        addInBodyReportUseCase: sl(),
        getClinicVisitsUseCase: sl(),
      ));

  sl.registerFactory(() => CommunicationCubit(
        getChatMessagesUseCase: sl(),
        sendMessageUseCase: sl(),
      ));

  sl.registerFactory(() => SubscriptionCubit(
        getPackagesUseCase: sl(),
        getPaymentRequestsUseCase: sl(),
        submitBankTransferUseCase: sl(),
      ));

  sl.registerFactory(() => OnlineFollowupCubit(
        getFollowupsUseCase: sl(),
        submitFollowupUseCase: sl(),
      ));

  sl.registerFactory(() => NotificationCubit(
        getNotificationsUseCase: sl(),
        markNotificationAsReadUseCase: sl(),
        markAllNotificationsAsReadUseCase: sl(),
      ));

  sl.registerLazySingleton(() => ProfileCubit(sharedPreferences: sl()));
}

part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();

  // Supabase initialization
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  serviceLocator.registerLazySingleton(() => supabase.client);
// Hive initialization
  if (kIsWeb) {
    // Web: Hive uses IndexedDB, no path required
    await Hive.initFlutter();
  } else {
    // Mobile/Desktop: provide directory path
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
  }

// ✅ Open the blogs box before registering
  final blogsBox = await Hive.openBox('blogs');
  serviceLocator.registerLazySingleton(() => blogsBox);

  // Other core dependencies
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  // Internet connection (external package)
  serviceLocator.registerLazySingleton(() => InternetConnection());

  // ✅ Register ConnectionChecker abstraction and implementation
  serviceLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
}

// ----------------- Auth -----------------
void _initAuth() {
  serviceLocator
    // Data source
    ..registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImp(serviceLocator()))
    // Repository
    ..registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(serviceLocator(), serviceLocator()))
    // Use cases
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => CurrentUser(serviceLocator()))
    // Bloc
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}

// ----------------- Blog -----------------
void _initBlog() {
  serviceLocator
    // Data source
    ..registerFactory<BlogRemoteDataSource>(
        () => BlogRemoteDataSourceImpl(serviceLocator()))
    ..registerFactory<BlogLocalDataSource>(
        () => BlogLocalDataSourceImpl(serviceLocator()))
    // Repository
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(
          serviceLocator(),
          serviceLocator(),
          serviceLocator(),
        ))
    // Use cases
    ..registerFactory(() => UploadBlog(serviceLocator()))
    ..registerFactory(() => GetAllBlogs(serviceLocator()))
    // Bloc
    ..registerLazySingleton(() => BlogBloc(
          uploadBlog: serviceLocator(),
          getAllBlogs: serviceLocator(),
        ));
}

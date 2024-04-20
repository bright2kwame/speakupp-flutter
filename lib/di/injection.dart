import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speakupp/api/auth/auth_call.dart';
import 'package:speakupp/api/auth/auth_call_impl.dart';
import 'package:speakupp/api/network_module.dart';
import 'package:speakupp/api/request_interceptor.dart';
import 'package:speakupp/model/user/user_item_provider.dart';
import 'package:speakupp/model/user/user_item_provider_impl.dart';
import 'package:speakupp/persistence/app_database.dart';
import 'package:speakupp/persistence/shared_preference_module.dart';
import 'package:sqflite/sqlite_api.dart';

Future<void> init() async {
  final sl = GetIt.instance;
  sl.registerSingletonAsync<SharedPreferences>(
      () => SharedPreferences.getInstance());
  sl.registerSingletonAsync<Database>(() => AppDatabase.init());

  sl.registerSingletonWithDependencies<SharedPreferenceModule>(
      () => SharedPreferenceModule(pref: sl<SharedPreferences>()),
      dependsOn: [SharedPreferences]);

  //interceptor
  sl.registerSingletonWithDependencies<RequestInterceptor>(
      () => RequestInterceptor(pref: sl()),
      dependsOn: [SharedPreferenceModule]);

  //module
  sl.registerLazySingleton<Dio>(
      () => NetworkModule(requestInterceptor: sl()).provideDio());

  //sql datasource
  sl.registerLazySingleton<UserItemProvider>(
      () => UserItemProviderImpl(appDatabase: sl()));

  //api datasource
  sl.registerLazySingleton<AuthCall>(() => AuthCallImpl(sl()));
}

import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:finshyt/core/secrets/app_secrets.dart';

@module
abstract class InjectionModule {
  @preResolve // Tells injectable to await this async method before registering
  Future<Supabase> get supabase async => await Supabase.initialize(
        url: AppSecrets.supabaseUrl,
        anonKey: AppSecrets.supabaseAnonKey,
      );

  @lazySingleton
  SupabaseClient get supabaseClient => Supabase.instance.client;
}

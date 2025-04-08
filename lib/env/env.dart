import 'package:envied/envied.dart';

part 'env.g.dart'; // This will be generated

@Envied(path: '.env') // Path to your .env file
abstract class Env {
  @EnviedField(varName: 'SUPABASE_URL')
  static const String supabaseUrl = _Env.supabaseUrl;

  @EnviedField(varName: 'SUPABASE_ANON_KEY')
  static const String supabaseAnonKey = _Env.supabaseAnonKey;
}


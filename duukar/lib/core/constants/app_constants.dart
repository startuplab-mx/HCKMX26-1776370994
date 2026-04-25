
import 'package:flutter_dotenv/flutter_dotenv.dart';
class AppConstants {
  const AppConstants._();
  static String get supabaseUrl => _getEnv('SUPABASE_URL');
  static String get supabaseAnonKey => _getEnv('SUPABASE_ANON_KEY');
  static String get openAiApiKey => _getEnv('OPENAI_API_KEY');
  static String get openAiModel => dotenv.env['OPENAI_MODEL'] ?? 'gpt-4o-mini';
  static String _getEnv(String key) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      throw Exception('Falta la variable de entorno: $key');
    }
    return value;
  }
}
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _supabaseClient;

  static Future<void> initialize() async {
    await dotenv.load();

    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseKey = dotenv.env['SUPABASE_ANON_KEY'];

    if (supabaseUrl == null || supabaseKey == null) {
      throw Exception("Supabase URL or Key not found in .env file");
    }

    _supabaseClient = SupabaseClient(supabaseUrl, supabaseKey);
  }

  static SupabaseClient? get client => _supabaseClient;
}

class AuthService {
  static Future<void> signUp(String email, String password) async {
    try {
      // Utilisez SupabaseService pour créer un nouvel utilisateur
      final response = await SupabaseService.client!.auth
          .signUp(email: email, password: password);

      print('Sign up response: $response');

      // Récupérez l'ID utilisateur à partir de la réponse de création de compte
      final userId = response.user?.id;
      print('User ID: $userId');

      // Enregistrez le profil utilisateur associé à cet utilisateur
      if (userId != null) {
        await createProfile(userId);
        print('Profile created successfully');
      }
    } catch (error) {
      print('Error signing up: $error');
      throw error;
    }
  }

  static Future<void> createProfile(String userId) async {
    try {
      // Utilisez SupabaseService pour créer un profil utilisateur associé à l'ID utilisateur
      await SupabaseService.client!.from('profiles').upsert([
        {
          'id':
              'gen_random_uuid()', // Utilisez la fonction pour générer un UUID
          'user_id': userId,
          // Autres champs de profil que vous pourriez vouloir inclure
        }
      ]);
    } catch (error) {
      print('Error creating user profile: $error');
      throw error;
    }
  }

  static Future<void> signIn(String email, String password) async {
    try {
      // Utilisez Supabase pour connecter l'utilisateur
      await SupabaseService.client!.auth
          .signInWithPassword(email: email, password: password);
    } catch (error) {
      print('Error signing in: $error');
      throw error;
    }
  }

  static Future<void> signOut() async {
    try {
      // Utilisez Supabase pour déconnecter l'utilisateur
      await SupabaseService.client!.auth.signOut();
    } catch (error) {
      print('Error signing out: $error');
      throw error;
    }
  }
}

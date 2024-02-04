import 'package:croc_top/page/profile_setup.dart';
import 'package:flutter/material.dart';
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

class AuthResponse {
  final bool success;
  final String? error;

  AuthResponse(this.success, {this.error});
}

class AuthService {
/* Fonction de création d'utilisateur seulement id, email et password */
  static Future<AuthResponse> signUp(
      String email, String password, BuildContext context) async {
    try {
      await SupabaseService.client!.auth
          .signUp(email: email, password: password);

      final isAuthenticated = await AuthService.isAuthenticated();

      if (isAuthenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
        );
      }

      return AuthResponse(true);
    } catch (error) {
      print('Error signing up: $error');
      return AuthResponse(false, error: error.toString());
    }
  }

/* Fonction pour mettre a jour les data d'un profile d'utilisateur lors que son inscription */

static Future<void> updateUserProfile() async { 

  final currentUser = SupabaseService.client!.auth.currentUser;
  print(currentUser);
}

  static Future<AuthResponse> signIn(String email, String password) async {
    try {
      await SupabaseService.client!.auth
          .signInWithPassword(email: email, password: password);
      return AuthResponse(true);
    } catch (error) {
      print('Error signing in: $error');
      return AuthResponse(false, error: error.toString());
    }
  }

  static Future<AuthResponse> signOut() async {
    try {
      await SupabaseService.client!.auth.signOut();
      return AuthResponse(true);
    } catch (error) {
      print('Error signing out: $error');
      return AuthResponse(false, error: error.toString());
    }
  }

  static Future<bool> isAuthenticated() async {
    final currentUser = SupabaseService.client!.auth.currentUser;
    return currentUser != null;
  }

  static Future<String?> getUserId() async {
    final currentUser = SupabaseService.client!.auth.currentUser;
    return currentUser?.id;
  }
}

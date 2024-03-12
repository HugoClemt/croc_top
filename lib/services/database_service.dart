import 'package:croc_top/auth/supabase_service.dart';

class DatabaseService {
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    final response = await SupabaseService.client!
        .from('profiles')
        .select()
        .eq('id', userId)
        .single()
        .execute();
    return response.data;
  }
}

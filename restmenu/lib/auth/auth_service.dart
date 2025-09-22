import 'package:supabase_flutter/supabase_flutter.dart';

class Auth {
  final supabase = Supabase.instance.client;

  Future<void> signUpWithEmailPassword(String email, String password) async {
    await supabase.auth.signUp(email: email, password: password);
  }

  Future<void> signInWithEmailPassword(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}

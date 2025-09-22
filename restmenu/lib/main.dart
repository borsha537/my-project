import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:restmenu/page/signin.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://ilgvxzqrgfgmpzdjzzqo.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlsZ3Z4enFyZ2ZnbXB6ZGp6enFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1MDI0OTQsImV4cCI6MjA3MzA3ODQ5NH0.17S2DldRFssGxyjot42a4tfK2KHR6bXfdl-bMkWU2Lo",
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignInPage(),
    );
  }
}

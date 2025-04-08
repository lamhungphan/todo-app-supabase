import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:todo_supabase/env/env.dart';
import 'package:todo_supabase/my_app.dart';

//dinh nghia nhung thu truoc khi run app
// env, db, locator, DI
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  runApp(MyApp());
}

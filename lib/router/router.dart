import 'package:go_router/go_router.dart';
import 'package:todo_supabase/pages/forgot_pass_page.dart';
import 'package:todo_supabase/pages/forgot_pass_verify_page.dart';
import 'package:todo_supabase/pages/wrapper/auth_wrapper.dart';
import 'package:todo_supabase/pages/wrapper/home_page.dart';
import 'package:todo_supabase/pages/wrapper/login_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => AuthWrapper(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/forgot', builder: (_, __) => const ForgotPassScreen()),
        GoRoute(path: '/reset', builder: (_, __) => const ForgotPassVerifyPage()),
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
      ],
    ),
  ],
);


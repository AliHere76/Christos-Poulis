import 'package:flutter/material.dart';
import '../screens/patient/patient_dashboard.dart';
import '../screens/profile/profile_setup_page.dart';
import '../screens/launch/starter_page.dart';
import '../screens/launch/splash_screen.dart';
import '../screens/auth/authentication_page.dart';
import '../screens/auth/login_page.dart';
import '../screens/auth/signup_page.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/doctor/doctor_dashboard.dart';
import '../screens/courses/course_details_screen.dart';
import '../widgets/auth_wrapper.dart';

class AppPages {
  // Route names
  static const String splash = '/splash';
  static const String authWrapper = '/authWrapper';
  static const String starterPage = '/starterPage';
  static const String auth = '/auth';
  static const String signUp = '/signUp';
  static const String login = '/login';
  static const String profileSetup = '/profileSetup';
  static const String doctorDashboard = '/doctorDashboard';
  static const String patientDashboard = '/patientDashboard';
  static const String chat = '/chat';
  static const String courseDetails = '/courseDetails';

  // Static routes
  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashScreen(),
    authWrapper: (context) => const AuthWrapper(),
    starterPage: (context) => const StarterPage(),
    auth: (context) => AuthenticationPage(),
    signUp: (context) => const SignUpScreen(),
    login: (context) => const LoginScreen(),
    profileSetup: (context) => const ProfileSetupScreen(),
    doctorDashboard: (context) => const DoctorDashboard(),
    patientDashboard: (context) => const PatientDashboard(),
  };

  // Generate route for dynamic routes
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == chat) {
      final arguments = settings.arguments as Map<String, dynamic>?;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder:
            (context, animation, secondaryAnimation) =>
                ChatScreen(arguments: arguments),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    }

    if (settings.name == courseDetails) {
      final String courseId = settings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => CourseDetailsScreen(courseId: courseId),
      );
    }

    return null;
  }
}

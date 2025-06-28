// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';

// import '../services/auth/auth_service.dart';
// import '../screens/doctor/doctor_dashboard.dart';
// import '../screens/launch/starter_page.dart';
// import '../screens/patient/patient_dashboard.dart';
// import '../screens/profile/profile_setup_page.dart';

// class AuthWrapper extends StatelessWidget {
//   const AuthWrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final AuthService authService = AuthService();

//     return StreamBuilder(
//       stream: authService.authStateChanges,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Scaffold(
//             body: Center(
//               child: SpinKitDoubleBounce(color: Color(0xFF0A2D7B), size: 40.0),
//             ),
//           );
//         }

//         if (snapshot.hasData && snapshot.data != null) {
//           return FutureBuilder(
//             future: authService.fetchUserData(),
//             builder: (context, userSnapshot) {
//               if (userSnapshot.connectionState == ConnectionState.waiting) {
//                 return const Scaffold(
//                   backgroundColor: Colors.white,
//                   body: Center(
//                     child: SpinKitDoubleBounce(
//                       color: Color(0xFF0A2D7B),
//                       size: 40.0,
//                     ),
//                   ),
//                 );
//               }

//               if (userSnapshot.hasData && userSnapshot.data != null) {
//                 final user = userSnapshot.data!;
//                 if (user.displayName.isEmpty) {
//                   return const ProfileSetupScreen();
//                 }
//                 return user.role == 'Doctor'
//                     ? const DoctorDashboard()
//                     : const PatientDashboard();
//               } else {
//                 return const ProfileSetupScreen();
//               }
//             },
//           );
//         } else {
//           return const StarterPage();
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../providers/auth_providers.dart';
import '../screens/doctor/doctor_dashboard.dart';
import '../screens/launch/starter_page.dart';
import '../screens/patient/patient_dashboard.dart';
import '../screens/profile/profile_setup_page.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return switch (authState.status) {
      AuthStatus.loading => const Scaffold(
        body: Center(
          child: SpinKitDoubleBounce(color: Color(0xFF0A2D7B), size: 40.0),
        ),
      ),

      AuthStatus.authenticated =>
        authState.user!.role == 'Doctor'
            ? const DoctorDashboard()
            : const PatientDashboard(),

      AuthStatus.needsProfileSetup => const ProfileSetupScreen(),

      AuthStatus.unauthenticated => const StarterPage(),

      AuthStatus.error => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                'Authentication Error',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                authState.error ?? 'An unknown error occurred',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(authStateProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    };
  }
}

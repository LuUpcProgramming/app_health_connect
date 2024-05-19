
import 'package:app_health_connect/presentation/screens/chat/chat_screen.dart';
import 'package:app_health_connect/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:app_health_connect/presentation/screens/welcome/health_info_screen.dart';
import 'package:app_health_connect/presentation/screens/welcome/personal_info_screen.dart';
import 'package:app_health_connect/presentation/screens/welcome/welcome_screen.dart';
import 'package:app_health_connect/presentation/screens/welcome/work_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    
    GoRoute(
      path: '/:nombre',
      name: WelcomeScreen.name,
      pageBuilder: (context, state) => buildSlideTransitionPage(const WelcomeScreen()) 
      //builder: (context, state) => const WelcomeScreen()
    ),

    GoRoute(
      path: '/personal',
      name: PersonalInfoScreen.name,
      pageBuilder: (context, state) => buildSlideTransitionPage(const PersonalInfoScreen())    
      //builder: (context, state) => const PersonalInfoScreen()
    ),

    GoRoute(
      path: '/work',
      name: WorkInfoScreen.name,
      //builder: (context, state) => const WorkInfoScreen(),
      pageBuilder: (context, state) => buildSlideTransitionPage(const WorkInfoScreen())    
    ),

    GoRoute(
      path: '/health',
      name: HealthInfoScreen.name,
      //builder: (context, state) => const HealthInfoScreen(),
      pageBuilder: (context, state) => buildSlideTransitionPage(const HealthInfoScreen())   
    ),

    GoRoute(
      path: '/dashboard',
      name: DashboardScreen.name,
      //builder: (context, state) => const DashboardScreen(),
      pageBuilder: (context, state) => buildSlideTransitionPage(const DashboardScreen()) 
    ),

    GoRoute(
      path: '/chat',
      name: ChatScreen.name,
      //builder: (context, state) => const ChatScreen(),
      pageBuilder: (context, state) => buildSlideTransitionPage(const ChatScreen()) 
    ),
    


  ]
);


CustomTransitionPage buildSlideTransitionPage(Widget child) {
  return CustomTransitionPage(
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
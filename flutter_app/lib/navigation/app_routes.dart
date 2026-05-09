import 'package:flutter/material.dart';
import '../features/welcome/welcome_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/voice/voice_check_screen.dart';
import '../features/typing/typing_test_screen.dart';
import '../features/gait/gait_test_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String welcome = '/';
  static const String dashboard = '/dashboard';
  static const String voiceCheck = '/voice-check';
  static const String typingTest = '/typing-test';
  static const String gaitTest = '/gait-test';

  static Map<String, WidgetBuilder> get routes => {
        welcome: (_) => const WelcomeScreen(),
        dashboard: (_) => const DashboardScreen(),
        voiceCheck: (_) => const VoiceCheckScreen(),
        typingTest: (_) => const TypingTestScreen(),
        gaitTest: (_) => const GaitTestScreen(),
      };
}

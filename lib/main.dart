// Copyright 2024. All rights reserved.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_theme.dart';
import 'providers/app_state.dart';
import 'screens/main_shell_screen.dart';

void main() {
  runApp(const NexusEcommerceApp());
}

class NexusEcommerceApp extends StatelessWidget {
  const NexusEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: Consumer<AppState>(
        builder: (context, appState, _) {
          return MaterialApp(
            title: 'Nexus Commerce',
            debugShowCheckedModeBanner: false,
            themeMode: appState.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const MainShellScreen(),
          );
        },
      ),
    );
  }
}

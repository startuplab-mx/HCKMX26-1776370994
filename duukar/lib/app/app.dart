import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class DuukarApp extends StatelessWidget {
  const DuukarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Duukar',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

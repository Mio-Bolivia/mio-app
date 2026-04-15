import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/services/app_lifecycle_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLifecycleService().initialize();

  runApp(const ProviderScope(child: MIOApp()));
}

class MIOApp extends ConsumerWidget {
  const MIOApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'MIO',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.lightTheme, //AppTheme.darkTheme
      themeMode: ThemeMode.system,
      routerConfig: routerProvider,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/services/session_service.dart';
import 'app_drawer.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;

  const MainScaffold({
    super.key,
    required this.title,
    required this.body,
  });

  Future<void> _logout(BuildContext context) async {
    await SessionService.instance.clearSession();
    if (context.mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          // Dark mode toggle
          IconButton(
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          // Çıkış
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: () => _logout(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: const AppDrawer(),
      body: body,
    );
  }
}

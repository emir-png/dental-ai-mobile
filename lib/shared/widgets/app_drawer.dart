import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_cubit.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;
    final currentRoute = GoRouterState.of(context).uri.toString();

    return Drawer(
      backgroundColor: AppColors.sidebarDark,
      child: Column(
        children: [
          // Logo / Başlık
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            color: AppColors.sidebarDark,
            child: const Text(
              'Menü',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 8),

          // İŞLEMLER
          _sectionHeader('İŞLEMLER'),
          _drawerItem(
            context,
            icon: Icons.upload_file,
            title: 'Röntgen Yükle',
            route: '/upload',
            currentRoute: currentRoute,
          ),

          const SizedBox(height: 8),

          // ANALİZLER
          _sectionHeader('ANALİZLER'),
          _drawerItem(
            context,
            icon: Icons.list_alt,
            title: 'Röntgen Sonuçları',
            route: '/history',
            currentRoute: currentRoute,
          ),

          const SizedBox(height: 8),

          // S.S.S
          _sectionHeader('S.S.S'),
          _drawerItem(
            context,
            icon: Icons.info_outline,
            title: 'Hakkımızda',
            route: '/about',
            currentRoute: currentRoute,
          ),
          _drawerItem(
            context,
            icon: Icons.mail_outline,
            title: 'İletişim',
            route: '/contact',
            currentRoute: currentRoute,
          ),

          const Spacer(),
          const Divider(color: Colors.white24, height: 1),

          // Dark mode toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: Colors.white70,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Karanlık Mod',
                  style: TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                Switch(
                  value: isDark,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
          ),

          // Kullanıcı bilgisi
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: const [
                Icon(Icons.person, color: Colors.white54, size: 16),
                SizedBox(width: 8),
                Text(
                  'Şu kişi olarak giriş yapıldı: admin',
                  style: TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _drawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String route,
        required String currentRoute,
      }) {
    final isActive = currentRoute == route;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? AppColors.primary : Colors.white70,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.primary : Colors.white70,
            fontSize: 14,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          context.go(route);
        },
      ),
    );
  }
}
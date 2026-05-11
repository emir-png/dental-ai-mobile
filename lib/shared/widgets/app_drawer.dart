import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/theme_cubit.dart';
import '../../core/services/session_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;
    final currentRoute = GoRouterState.of(context).uri.toString();
    final session = SessionService.instance;
    final isAdmin = session.isAdmin;

    final bgColor = isDark ? AppColors.sidebarDark : AppColors.surfaceLight;
    final headerBg = isDark ? AppColors.sidebarDark : AppColors.primary;
    final titleColor = isDark ? Colors.white : Colors.white;
    final textColor = isDark ? Colors.white70 : Colors.black87;
    final sectionColor = isDark ? Colors.white38 : Colors.black38;
    final dividerColor = isDark ? Colors.white24 : Colors.black12;
    final iconColor = isDark ? Colors.white70 : Colors.black54;
    final userTextColor = isDark ? Colors.white54 : Colors.black45;

    return Drawer(
      backgroundColor: bgColor,
      child: Column(
        children: [
          // Logo / Başlık
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
            color: headerBg,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Menü',
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isAdmin)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(color: dividerColor, height: 1),
          const SizedBox(height: 8),

          // Admin-only section
          if (isAdmin) ...[
            _sectionHeader('YÖNETİM', sectionColor),
            _drawerItem(
              context,
              icon: Icons.admin_panel_settings,
              title: 'Admin Paneli',
              route: '/admin',
              currentRoute: currentRoute,
              textColor: textColor,
              iconColor: iconColor,
            ),
            _drawerItem(
              context,
              icon: Icons.list_alt,
              title: 'Tüm Röntgenler',
              route: '/history',
              currentRoute: currentRoute,
              textColor: textColor,
              iconColor: iconColor,
            ),
            const SizedBox(height: 8),
          ],

          // User-only section
          if (!isAdmin) ...[
            _sectionHeader('İŞLEMLER', sectionColor),
            _drawerItem(
              context,
              icon: Icons.upload_file,
              title: 'Röntgen Yükle',
              route: '/upload',
              currentRoute: currentRoute,
              textColor: textColor,
              iconColor: iconColor,
            ),
            const SizedBox(height: 8),

            _sectionHeader('ANALİZLER', sectionColor),
            _drawerItem(
              context,
              icon: Icons.list_alt,
              title: 'Röntgen Sonuçları',
              route: '/history',
              currentRoute: currentRoute,
              textColor: textColor,
              iconColor: iconColor,
            ),
            const SizedBox(height: 8),
          ],

          // S.S.S
          _sectionHeader('S.S.S', sectionColor),
          _drawerItem(
            context,
            icon: Icons.info_outline,
            title: 'Hakkımızda',
            route: '/about',
            currentRoute: currentRoute,
            textColor: textColor,
            iconColor: iconColor,
          ),
          _drawerItem(
            context,
            icon: Icons.mail_outline,
            title: 'İletişim',
            route: '/contact',
            currentRoute: currentRoute,
            textColor: textColor,
            iconColor: iconColor,
          ),
          _drawerItem(
            context,
            icon: Icons.privacy_tip_outlined,
            title: 'Gizlilik Politikası',
            route: '/privacy',
            currentRoute: currentRoute,
            textColor: textColor,
            iconColor: iconColor,
          ),

          const Spacer(),
          Divider(color: dividerColor, height: 1),

          // Dark mode toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode : Icons.light_mode,
                  color: iconColor,
                ),
                const SizedBox(width: 12),
                Text(
                  'Karanlık Mod',
                  style: TextStyle(color: textColor),
                ),
                const Spacer(),
                Switch(
                  value: isDark,
                  onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  activeThumbColor: AppColors.primary,
                ),
              ],
            ),
          ),

          // Kullanıcı bilgisi
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Row(
              children: [
                Icon(
                  isAdmin ? Icons.admin_panel_settings : Icons.person,
                  color: userTextColor,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${session.username ?? 'Kullanıcı'} '
                    '(${isAdmin ? 'Admin' : 'Kullanıcı'})',
                    style: TextStyle(color: userTextColor, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Text(
        title,
        style: TextStyle(
          color: color,
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
    required Color textColor,
    required Color iconColor,
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
          color: isActive ? AppColors.primary : iconColor,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.primary : textColor,
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

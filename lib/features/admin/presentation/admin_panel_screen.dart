import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_cubit.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/services/session_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _allXrays = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final users = await DatabaseHelper.instance.getAllUsers();
    final xrays = await DatabaseHelper.instance.getAllXrays();
    if (mounted) {
      setState(() {
        _users = users;
        _allXrays = xrays;
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _filteredUsers {
    if (_searchQuery.isEmpty) return _users;
    final q = _searchQuery.toLowerCase();
    return _users.where((u) {
      return (u['username'] as String).toLowerCase().contains(q) ||
          (u['email'] as String).toLowerCase().contains(q) ||
          (u['role'] as String).toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _changeRole(Map<String, dynamic> user) async {
    final currentRole = user['role'] as String;
    final newRole = currentRole == 'admin' ? 'user' : 'admin';
    final userId = user['id'] as int;

    // Prevent self-demotion
    if (userId == SessionService.instance.userId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Kendi rolünüzü değiştiremezsiniz.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rol Değiştir'),
        content: Text(
          '"${user['username']}" kullanıcısının rolü '
          '"$currentRole" → "$newRole" olarak değiştirilsin mi?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Onayla'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final ok = await DatabaseHelper.instance.updateUserRole(userId, newRole);
      if (ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '"${user['username']}" artık $newRole rolüne sahip.'),
            backgroundColor: AppColors.success,
          ),
        );
        _loadData();
      }
    }
  }

  Future<void> _logout() async {
    await SessionService.instance.clearSession();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.watch<ThemeCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Paneli'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            onPressed: () => context.read<ThemeCubit>().toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Çıkış Yap',
            onPressed: _logout,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome
                    Text(
                      'Hoş geldiniz, ${SessionService.instance.username}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Sistem yönetim paneli',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Stats cards
                    Row(
                      children: [
                        _statCard(
                          icon: Icons.people,
                          label: 'Toplam Kullanıcı',
                          value: _users.length.toString(),
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 12),
                        _statCard(
                          icon: Icons.image_search,
                          label: 'Toplam Röntgen',
                          value: _allXrays.length.toString(),
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 12),
                        _statCard(
                          icon: Icons.admin_panel_settings,
                          label: 'Admin Sayısı',
                          value: _users
                              .where((u) => u['role'] == 'admin')
                              .length
                              .toString(),
                          color: Colors.orange,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Röntgenler button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.go('/history'),
                        icon: const Icon(Icons.list_alt),
                        label: const Text('Tüm Röntgenleri Görüntüle'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Users section
                    const Text(
                      'Kullanıcı Yönetimi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Search
                    TextField(
                      controller: _searchController,
                      onChanged: (v) => setState(() => _searchQuery = v),
                      decoration: const InputDecoration(
                        hintText: 'Kullanıcı ara...',
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Table header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Text('ID',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text('Kullanıcı Adı',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text('E-posta',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('Rol',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text('İşlem',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12)),
                          ),
                        ],
                      ),
                    ),

                    // Table rows
                    ..._filteredUsers.asMap().entries.map((entry) {
                      final index = entry.key;
                      final user = entry.value;
                      final isEven = index % 2 == 0;
                      final isCurrentUser =
                          user['id'] == SessionService.instance.userId;
                      final isAdmin = user['role'] == 'admin';

                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isEven
                              ? Colors.transparent
                              : Colors.grey.withOpacity(0.05),
                          border: Border(
                            left: BorderSide(
                                color: Colors.grey.withOpacity(0.2)),
                            right: BorderSide(
                                color: Colors.grey.withOpacity(0.2)),
                            bottom: BorderSide(
                                color: Colors.grey.withOpacity(0.1)),
                          ),
                        ),
                        child: Row(
                          children: [
                            // ID
                            Expanded(
                              flex: 1,
                              child: Text(
                                '#${user['id']}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            // Username
                            Expanded(
                              flex: 3,
                              child: Row(
                                children: [
                                  Text(
                                    user['username'] ?? '',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  if (isCurrentUser)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: Text(
                                        '(siz)',
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Email
                            Expanded(
                              flex: 3,
                              child: Text(
                                user['email'] ?? '',
                                style: const TextStyle(fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Role badge
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 3),
                                decoration: BoxDecoration(
                                  color: isAdmin
                                      ? Colors.orange.withOpacity(0.2)
                                      : AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: isAdmin
                                        ? Colors.orange
                                        : AppColors.primary,
                                    width: 0.8,
                                  ),
                                ),
                                child: Text(
                                  isAdmin ? 'Admin' : 'Kullanıcı',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: isAdmin
                                        ? Colors.orange
                                        : AppColors.primary,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            // Action
                            Expanded(
                              flex: 2,
                              child: ElevatedButton(
                                onPressed: isCurrentUser
                                    ? null
                                    : () => _changeRole(user),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  minimumSize: const Size(0, 28),
                                  backgroundColor: isAdmin
                                      ? Colors.orange
                                      : AppColors.primary,
                                ),
                                child: Text(
                                  isAdmin ? '→ Kullanıcı' : '→ Admin',
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    if (_filteredUsers.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey.withOpacity(0.2)),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text('Kullanıcı bulunamadı.'),
                      ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _statCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.15),
              color.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

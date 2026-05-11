import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static final SessionService instance = SessionService._internal();
  SessionService._internal();

  int? _userId;
  String? _username;
  String? _role;

  int? get userId => _userId;
  String? get username => _username;
  String? get role => _role;
  bool get isAdmin => _role == 'admin';
  bool get isLoggedIn => _userId != null;

  Future<void> saveSession(Map<String, dynamic> user) async {
    _userId = user['id'] as int?;
    _username = user['username'] as String?;
    _role = user['role'] as String? ?? 'user';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sessionUserId', _userId ?? 0);
    await prefs.setString('sessionUsername', _username ?? '');
    await prefs.setString('sessionRole', _role ?? 'user');
  }

  Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('sessionUserId');
    if (userId != null && userId > 0) {
      _userId = userId;
      _username = prefs.getString('sessionUsername');
      _role = prefs.getString('sessionRole') ?? 'user';
    }
  }

  Future<void> clearSession() async {
    _userId = null;
    _username = null;
    _role = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('sessionUserId');
    await prefs.remove('sessionUsername');
    await prefs.remove('sessionRole');
  }
}

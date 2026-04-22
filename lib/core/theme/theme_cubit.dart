import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(true) {
    _loadTheme();
  }

  // true = dark, false = light
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    emit(prefs.getBool('isDark') ?? true);
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newValue = !state;
    await prefs.setBool('isDark', newValue);
    emit(newValue);
  }
}
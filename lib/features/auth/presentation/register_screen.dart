import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/database/database_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Prevent registering as 'admin'
    if (username.toLowerCase() == 'admin') {
      setState(() {
        _isLoading = false;
        _errorMessage = '"admin" kullanıcı adı kullanılamaz.';
      });
      return;
    }

    final usernameTaken = await DatabaseHelper.instance.isUsernameTaken(username);
    if (usernameTaken) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Bu kullanıcı adı zaten kullanılıyor.';
      });
      return;
    }

    final emailTaken = await DatabaseHelper.instance.isEmailTaken(email);
    if (emailTaken) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Bu e-posta adresi zaten kayıtlı.';
      });
      return;
    }

    final success = await DatabaseHelper.instance.registerUser(
      username: username,
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hesap başarıyla oluşturuldu! Giriş yapabilirsiniz.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/login');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Hesap oluşturulamadı. Lütfen tekrar deneyin.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dental gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.gradientStart, AppColors.gradientEnd],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // Decorative dental patterns
          Positioned(
            right: -50,
            top: 80,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.health_and_safety_outlined,
                size: 180,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: 120,
            child: Opacity(
              opacity: 0.08,
              child: Icon(
                Icons.medical_services_outlined,
                size: 160,
                color: Colors.white,
              ),
            ),
          ),
          // Registration card
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Dental logo icon
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withOpacity(0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Yeni Hesap Oluştur',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Dental AI sistemine katılın',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Kullanıcı adı
                            TextFormField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                labelText: 'Kullanıcı Adı',
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Kullanıcı adı boş bırakılamaz.';
                                }
                                if (value.trim().length < 3) {
                                  return 'En az 3 karakter olmalıdır.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // E-posta
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'E-posta',
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'E-posta boş bırakılamaz.';
                                }
                                final emailRegex = RegExp(
                                    r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                                if (!emailRegex.hasMatch(value.trim())) {
                                  return 'Geçerli bir e-posta adresi girin.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Şifre
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                labelText: 'Şifre',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscurePassword = !_obscurePassword),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Şifre boş bırakılamaz.';
                                }
                                if (value.length < 6) {
                                  return 'Şifre en az 6 karakter olmalıdır.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Şifre tekrar
                            TextFormField(
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirm,
                              decoration: InputDecoration(
                                labelText: 'Şifre Tekrar',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirm
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () => setState(
                                      () => _obscureConfirm = !_obscureConfirm),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Şifre tekrarı boş bırakılamaz.';
                                }
                                if (value != _passwordController.text) {
                                  return 'Şifreler eşleşmiyor.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Hata mesajı
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4, bottom: 4),
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            const SizedBox(height: 12),

                            // Kayıt ol butonu
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _register,
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'Hesap Oluştur',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Giriş yap linki
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Zaten hesabın var mı?'),
                                TextButton(
                                  onPressed: () => context.go('/login'),
                                  child: const Text('Giriş Yap'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

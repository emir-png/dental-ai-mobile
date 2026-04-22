import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/main_scaffold.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen zorunlu alanları doldurun.')),
      );
      return;
    }
    setState(() => _isSending = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isSending = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mesajınız gönderildi!'),
          backgroundColor: AppColors.success,
        ),
      );
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'İletişim',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'İletişim',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol - Form
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ad Soyad'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              hintText: 'Ör: Dr. Ali Yılmaz',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('E-posta'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'ornek@mail.com',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Konu'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _subjectController,
                            decoration: const InputDecoration(
                              hintText: 'Ör: Model doğruluğu hakkında',
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text('Mesajınız'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _messageController,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              hintText:
                              'Görüş, öneri veya teknik talebinizi yazabilirsiniz.',
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _isSending ? null : _send,
                            icon: _isSending
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                                : const Icon(Icons.send),
                            label: const Text('Gönder'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Sağ - İletişim bilgileri
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _ContactInfo(
                                icon: Icons.email,
                                label: 'E-posta:',
                                value: '0xfatihalp@gmail.com',
                              ),
                              SizedBox(height: 12),
                              _ContactInfo(
                                icon: Icons.phone,
                                label: 'Telefon:',
                                value: '+90 (552) 440 46 36',
                              ),
                              SizedBox(height: 12),
                              _ContactInfo(
                                icon: Icons.location_on,
                                label: 'Adres:',
                                value:
                                'Lalapaşa Mahallesi Mazi Sokak Birlik Apartmanı daire:3 Yakutiye/Erzurum',
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Icon(Icons.access_time,
                                      color: AppColors.primary, size: 18),
                                  SizedBox(width: 8),
                                  Text('Çalışma Saatleri',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text('• Pazartesi - Cuma: 09:00 - 18:00',
                                  style: TextStyle(fontSize: 13)),
                              SizedBox(height: 4),
                              Text('• Hafta sonu: Sadece acil teknik destek',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ContactInfo({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.bold,
                      fontSize: 13)),
              Text(value, style: const TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}
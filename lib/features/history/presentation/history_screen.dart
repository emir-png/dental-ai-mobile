import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/database/database_helper.dart';
import '../../../shared/widgets/main_scaffold.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, dynamic>> _xrays = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadXrays();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadXrays() async {
    final xrays = await DatabaseHelper.instance.getAllXrays();
    setState(() {
      _xrays = xrays;
      _filtered = xrays;
      _isLoading = false;
    });
  }

  void _onSearch(String query) {
    setState(() {
      _filtered = _xrays
          .where((x) =>
      x['id'].toString().contains(query) ||
          x['uploadDate'].toString().contains(query) ||
          x['status'].toString().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Tüm Röntgenler',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Röntgen Sonuçları',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Arama
            TextField(
              controller: _searchController,
              onChanged: _onSearch,
              decoration: const InputDecoration(
                hintText: 'Ara...',
                prefixIcon: Icon(Icons.search),
                isDense: true,
              ),
            ),
            const SizedBox(height: 16),

            // Tablo başlığı
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                children: const [
                  Expanded(
                    flex: 1,
                    child: Text('ID',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('Yükleme Tarihi',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Durum',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('İşlem',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),

            // Liste
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                  ? const Center(child: Text('Henüz röntgen yüklenmedi.'))
                  : ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (context, index) {
                  final xray = _filtered[index];
                  final isEven = index % 2 == 0;
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
                            '#${xray['id']}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        // Tarih
                        Expanded(
                          flex: 3,
                          child: Text(
                            xray['uploadDate'] ?? '',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        // Durum
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.done,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              xray['status'] ?? 'done',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        // İşlem butonu
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () => context
                                .go('/results/${xray['id']}'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              minimumSize: const Size(0, 32),
                            ),
                            child: const Text(
                              'Sonuçları Gör',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
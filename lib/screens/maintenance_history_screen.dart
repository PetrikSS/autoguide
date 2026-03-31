import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class MaintenanceHistoryScreen extends StatefulWidget {
  const MaintenanceHistoryScreen({super.key});

  @override
  State<MaintenanceHistoryScreen> createState() => _MaintenanceHistoryScreenState();
}

class _MaintenanceHistoryScreenState extends State<MaintenanceHistoryScreen> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('maintenance_history') ?? [];
    setState(() {
      _history = list.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
      // Сортируем по дате — новые сверху
      _history.sort((a, b) => b['date'].compareTo(a['date']));
    });
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Очистить историю?',  style: TextStyle(fontSize: 20),),
        content: const Text('Все записи будут удалены.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Отмена',  style: TextStyle(color: Colors.grey),)),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('maintenance_history');
      setState(() => _history.clear());
    }
  }

  String _formatDate(String isoDate) {
    final dt = DateTime.parse(isoDate);
    final months = ['янв', 'фев', 'мар', 'апр', 'май', 'июн', 'июл', 'авг', 'сен', 'окт', 'ноя', 'дек'];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Color _seasonColor(String season) {
    switch (season) {
      case 'Весна': return Colors.green;
      case 'Лето': return Colors.orange;
      case 'Осень': return Colors.brown;
      case 'Зима': return Colors.blue;
      default: return AppTheme.deepOrange;
    }
  }

  IconData _seasonIcon(String season) {
    switch (season) {
      case 'Весна': return Icons.spa;
      case 'Лето': return Icons.wb_sunny;
      case 'Осень': return Icons.grass;
      case 'Зима': return Icons.ac_unit;
      default: return Icons.calendar_month;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История обслуживания'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Очистить историю',
              onPressed: _clearHistory,
            ),
        ],
      ),
      body: _history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2)),
                  const SizedBox(height: 16),
                  Text(
                    'История пуста',
                    style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Отмечайте выполненные проверки\nв сезонном обслуживании',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3)),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final entry = _history[index];
                final season = entry['season'] as String;
                final color = _seasonColor(season);

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(_seasonIcon(season), color: color, size: 22),
                    ),
                    title: Text(
                      entry['title'],
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              season,
                              style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(entry['date']),
                            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  ),
                );
              },
            ),
    );
  }
}

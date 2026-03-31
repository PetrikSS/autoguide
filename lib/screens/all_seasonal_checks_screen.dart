import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../theme.dart';
import 'maintenance_history_screen.dart';

class AllSeasonalChecksScreen extends StatefulWidget {
  final String currentSeason;

  const AllSeasonalChecksScreen({
    super.key,
    required this.currentSeason,
  });

  @override
  State<AllSeasonalChecksScreen> createState() => _AllSeasonalChecksScreenState();
}

class _AllSeasonalChecksScreenState extends State<AllSeasonalChecksScreen> {
  final Set<String> _completed = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('seasonal_checks') ?? [];
    setState(() => _completed.addAll(saved));
  }

  Future<void> _toggle(String key, String season, String title) async {
    final isDone = _completed.contains(key);
    setState(() {
      if (isDone) {
        _completed.remove(key);
      } else {
        _completed.add(key);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('seasonal_checks', _completed.toList());

    // Обновляем историю
    final historyList = prefs.getStringList('maintenance_history') ?? [];
    if (!isDone) {
      // Добавляем запись
      historyList.add(jsonEncode({
        'key': key,
        'title': title,
        'season': season,
        'date': DateTime.now().toIso8601String(),
      }));
    } else {
      // Удаляем запись по ключу
      historyList.removeWhere((e) {
        final m = jsonDecode(e) as Map<String, dynamic>;
        return m['key'] == key;
      });
    }
    await prefs.setStringList('maintenance_history', historyList);
  }

  // Полный список проверок для всех сезонов
  List<Map<String, dynamic>> _getAllSeasonalChecks() {
    return [
      {
        'season': 'Весна',
        'icon': Icons.spa,
        'color': Colors.green,
        'checks': [
          {'title': 'Смена шин', 'subtitle': 'Переобуваемся в летнюю резину', 'icon': Icons.tire_repair, 'urgent': true},
          {'title': 'Проверка кондиционера', 'subtitle': 'Заправка и диагностика', 'icon': Icons.ac_unit, 'urgent': false},
          {'title': 'Омывающая жидкость', 'subtitle': 'Заменить на летнюю', 'icon': Icons.water_drop, 'urgent': false},
          {'title': 'Проверка дворников', 'subtitle': 'Заменить при необходимости', 'icon': Icons.remove_red_eye, 'urgent': false},
          {'title': 'Аккумулятор', 'subtitle': 'Проверка заряда после зимы', 'icon': Icons.battery_charging_full, 'urgent': false},
        ],
      },
      {
        'season': 'Лето',
        'icon': Icons.wb_sunny,
        'color': Colors.orange,
        'checks': [
          {'title': 'Кондиционер', 'subtitle': 'Диагностика и заправка', 'icon': Icons.ac_unit, 'urgent': true},
          {'title': 'Охлаждающая жидкость', 'subtitle': 'Уровень и состояние', 'icon': Icons.thermostat, 'urgent': false},
          {'title': 'Фильтр салона', 'subtitle': 'Замена от пыльцы', 'icon': Icons.air, 'urgent': false},
          {'title': 'Проверка ремней', 'subtitle': 'Осмотр на износ', 'icon': Icons.power, 'urgent': false},
          {'title': 'Тормозная жидкость', 'subtitle': 'Уровень и замена', 'icon': Icons.car_repair, 'urgent': false},
        ],
      },
      {
        'season': 'Осень',
        'icon': Icons.grass,
        'color': Colors.brown,
        'checks': [
          {'title': 'Смена шин', 'subtitle': 'Готовим зимнюю резину', 'icon': Icons.tire_repair, 'urgent': true},
          {'title': 'Проверка печки', 'subtitle': 'Отопление и обогрев', 'icon': Icons.whatshot, 'urgent': true},
          {'title': 'Аккумулятор', 'subtitle': 'Проверка заряда', 'icon': Icons.battery_charging_full, 'urgent': false},
          {'title': 'Антифриз', 'subtitle': 'Проверка температуры замерзания', 'icon': Icons.opacity, 'urgent': true},
          {'title': 'Стеклоомыватель', 'subtitle': 'Заменить на зимний', 'icon': Icons.water_drop, 'urgent': true},
        ],
      },
      {
        'season': 'Зима',
        'icon': Icons.ac_unit,
        'color': Colors.blue,
        'checks': [
          {'title': 'Аккумулятор', 'subtitle': 'Заряд и состояние', 'icon': Icons.battery_charging_full, 'urgent': true},
          {'title': 'Антифриз', 'subtitle': 'Проверка температуры замерзания', 'icon': Icons.opacity, 'urgent': true},
          {'title': 'Дворники', 'subtitle': 'Зимние щетки', 'icon': Icons.remove_red_eye, 'urgent': false},
          {'title': 'Двигатель', 'subtitle': 'Прогрев перед поездкой', 'icon': Icons.engineering, 'urgent': false},
          {'title': 'Зарядка', 'subtitle': 'Проверка генератора', 'icon': Icons.electric_bolt, 'urgent': false},
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final allChecks = _getAllSeasonalChecks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сезонное обслуживание'),
        backgroundColor: AppTheme.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'История',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MaintenanceHistoryScreen()),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: allChecks.length,
        itemBuilder: (context, index) {
          final seasonData = allChecks[index];
          final isCurrentSeason = seasonData['season'] == widget.currentSeason;

          return Column(
            children: [
              // Карточка сезона
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: isCurrentSeason
                      ? Border.all(color: AppTheme.deepOrange, width: 2)
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Заголовок сезона
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: seasonData['color'].withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: seasonData['color'],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              seasonData['icon'],
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      seasonData['season'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: seasonData['color'],
                                      ),
                                    ),
                                    if (isCurrentSeason) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.deepOrange,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Text(
                                          'Текущий сезон',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${seasonData['checks'].length} рекомендаций',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Список проверок
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: seasonData['checks'].asMap().entries.map<Widget>((entry) {
                          final checkIndex = entry.key;
                          final check = entry.value;
                          final key = '${seasonData['season']}_$checkIndex';
                          final isDone = _completed.contains(key);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color:
                                    seasonData['color'].withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    check['icon'],
                                    color: seasonData['color'],
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              check['title'],
                                              style: TextStyle(
                                                fontWeight: check['urgent']
                                                    ? FontWeight.bold
                                                    : FontWeight.w500,
                                                fontSize: 15,
                                                decoration: isDone ? TextDecoration.lineThrough : null,
                                                color: isDone ? Colors.grey : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        check['subtitle'],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    isDone ? Icons.check_circle : Icons.circle_outlined,
                                    color: isDone ? Colors.green : Colors.grey[400],
                                    size: 24,
                                  ),
                                  onPressed: () => _toggle(key, seasonData['season'] as String, check['title'] as String),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    // // Кнопка "Напомнить о сезоне"
                    // Padding(
                    //   padding: const EdgeInsets.all(16),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: OutlinedButton.icon(
                    //           onPressed: () {
                    //             ScaffoldMessenger.of(context).showSnackBar(
                    //               SnackBar(
                    //                 content: Text('Напоминание о ${seasonData['season']} установлено'),
                    //                 backgroundColor: AppTheme.deepOrange,
                    //               ),
                    //             );
                    //           },
                    //           icon: Icon(
                    //             Icons.notifications_none,
                    //             size: 18,
                    //             color: seasonData['color'],
                    //           ),
                    //           label: Text(
                    //             'Напомнить о сезоне',
                    //             style: TextStyle(color: seasonData['color']),
                    //           ),
                    //           style: OutlinedButton.styleFrom(
                    //             side: BorderSide(color: seasonData['color']),
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(30),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),

              if (index < allChecks.length - 1)
                const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}
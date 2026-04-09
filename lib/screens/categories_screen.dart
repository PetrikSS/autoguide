import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'all_seasonal_checks_screen.dart';
import 'parts_list_screen.dart';
import 'profile_screen.dart';
import '../models/car.dart';
import '../models/category.dart';
import '../database/database_helper.dart';
import '../theme.dart';

class CategoriesScreen extends StatefulWidget {
  final Car car;

  const CategoriesScreen({super.key, required this.car});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List<Category> categories = [];
  bool isLoading = true;
  Set<String> _completedChecks = {};

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadCompleted();
  }

  Future<void> _loadCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('seasonal_checks') ?? [];
    setState(() => _completedChecks = saved.toSet());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCompleted();
  }

  IconData _categoryIcon(String id) {
    switch (id) {
      case 'engine':      return Icons.settings;
      case 'brakes':      return Icons.album;
      case 'suspension':  return Icons.directions_car;
      case 'electrics':   return Icons.bolt;
      case 'exhaust':     return Icons.air;
      case 'body':        return Icons.car_repair;
      case 'interior':    return Icons.weekend;
      case 'cooling':     return Icons.thermostat;
      case 'fuel':        return Icons.local_gas_station;
      case 'transmission':return Icons.sync_alt;
      default:            return Icons.build;
    }
  }

  Future<void> _loadCategories() async {
    try {
      final dbHelper = DatabaseHelper();
      final loadedCategories = await dbHelper.getCategories().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          debugPrint('❌ getCategories() timeout');
          return [];
        },
      );

      setState(() {
        categories = loadedCategories;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('❌ Ошибка загрузки категорий: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  // Определяем текущий сезон (оставляем как есть)
  String _getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;

    if (month >= 3 && month <= 5) return 'Весна';
    if (month >= 6 && month <= 8) return 'Лето';
    if (month >= 9 && month <= 11) return 'Осень';
    return 'Зима';
  }

  // Получаем рекомендации по сезону — полный список (5 элементов, как в AllSeasonalChecksScreen)
  List<Map<String, dynamic>> _getAllSeasonalChecks() {
    final season = _getCurrentSeason();
    switch (season) {
      case 'Весна':
        return [
          {'title': 'Смена шин', 'subtitle': 'Переобуваемся в летнюю резину', 'icon': Icons.tire_repair, 'urgent': true},
          {'title': 'Проверка кондиционера', 'subtitle': 'Заправка и диагностика', 'icon': Icons.ac_unit, 'urgent': false},
          {'title': 'Омывающая жидкость', 'subtitle': 'Заменить на летнюю', 'icon': Icons.water_drop, 'urgent': false},
          {'title': 'Проверка дворников', 'subtitle': 'Заменить при необходимости', 'icon': Icons.remove_red_eye, 'urgent': false},
          {'title': 'Аккумулятор', 'subtitle': 'Проверка заряда после зимы', 'icon': Icons.battery_charging_full, 'urgent': false},
        ];
      case 'Лето':
        return [
          {'title': 'Кондиционер', 'subtitle': 'Диагностика и заправка', 'icon': Icons.ac_unit, 'urgent': true},
          {'title': 'Охлаждающая жидкость', 'subtitle': 'Уровень и состояние', 'icon': Icons.thermostat, 'urgent': false},
          {'title': 'Фильтр салона', 'subtitle': 'Замена от пыльцы', 'icon': Icons.air, 'urgent': false},
          {'title': 'Проверка ремней', 'subtitle': 'Осмотр на износ', 'icon': Icons.power, 'urgent': false},
          {'title': 'Тормозная жидкость', 'subtitle': 'Уровень и замена', 'icon': Icons.car_repair, 'urgent': false},
        ];
      case 'Осень':
        return [
          {'title': 'Смена шин', 'subtitle': 'Готовим зимнюю резину', 'icon': Icons.tire_repair, 'urgent': true},
          {'title': 'Проверка печки', 'subtitle': 'Отопление и обогрев', 'icon': Icons.whatshot, 'urgent': true},
          {'title': 'Аккумулятор', 'subtitle': 'Проверка заряда', 'icon': Icons.battery_charging_full, 'urgent': false},
          {'title': 'Антифриз', 'subtitle': 'Проверка температуры замерзания', 'icon': Icons.opacity, 'urgent': true},
          {'title': 'Стеклоомыватель', 'subtitle': 'Заменить на зимний', 'icon': Icons.water_drop, 'urgent': true},
        ];
      case 'Зима':
        return [
          {'title': 'Аккумулятор', 'subtitle': 'Заряд и состояние', 'icon': Icons.battery_charging_full, 'urgent': true},
          {'title': 'Антифриз', 'subtitle': 'Проверка температуры замерзания', 'icon': Icons.opacity, 'urgent': true},
          {'title': 'Дворники', 'subtitle': 'Зимние щетки', 'icon': Icons.remove_red_eye, 'urgent': false},
          {'title': 'Двигатель', 'subtitle': 'Прогрев перед поездкой', 'icon': Icons.engineering, 'urgent': false},
          {'title': 'Зарядка', 'subtitle': 'Проверка генератора', 'icon': Icons.electric_bolt, 'urgent': false},
        ];
      default:
        return [];
    }
  }

  // Возвращает только невыполненные пункты текущего сезона
  List<Map<String, dynamic>> _getSeasonalChecks() {
    final season = _getCurrentSeason();
    final all = _getAllSeasonalChecks();
    return all.asMap().entries
        .where((e) => !_completedChecks.contains('${season}_${e.key}'))
        .map((e) => e.value)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final currentSeason = _getCurrentSeason();
    final seasonalChecks = _getSeasonalChecks();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.car.fullName),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  _showNotificationsDialog(context);
                },
              ),
              Positioned(
                right: 11,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ProfileScreen(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AllSeasonalChecksScreen(
                        currentSeason: currentSeason,
                      ),
                    ),
                  ).then((_) => _loadCompleted());
                },
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.deepOrange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Сезонное обслуживание',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                '$currentSeason • Рекомендуемые проверки',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.deepOrange.withOpacity(0.3),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            if (seasonalChecks.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40, height: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.check_circle_outline, color: Colors.green, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Все проверки выполнены!',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Theme.of(context).colorScheme.onSurface,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              ...seasonalChecks.map((check) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppTheme.deepOrange.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      check['icon'],
                                      color: AppTheme.deepOrange,
                                      size: 22,
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
                                              check['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15,
                                                color: Theme.of(context).colorScheme.onSurface,
                                              ),
                                            ),
                                            if (check['urgent'])
                                              Container(
                                                margin: const EdgeInsets.only(left: 8),
                                                padding: const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 2,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Text(
                                                  'Срочно',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          check['subtitle'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: AppTheme.deepOrange,
                                    size: 14,
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ),
                      ),
                  ),
                ],
                ),
              ),
            ),
          ),

          // Заголовок категорий
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Категории деталей',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
          ),

          // Сетка категорий (теперь из базы данных)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartsListScreen(
                            car: widget.car,
                            category: category,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 4,
                      color: Theme.of(context).cardColor,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: AppTheme.deepOrange.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Icon(
                                  _categoryIcon(category.id),
                                  color: AppTheme.deepOrange,
                                  size: 24,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${category.partCount} деталей',
                              style: TextStyle(
                                fontSize: 11,
                                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: categories.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Уведомления',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildNotificationItem(
                context: context,
                icon: Icons.warning_amber,
                title: 'Срочно! Сезонная проверка',
                subtitle: 'Проверьте, что сменили шины',
                time: '2 часа назад',
                isUrgent: true,
              ),
              _buildNotificationItem(
                context: context,
                icon: Icons.build,
                title: 'Напоминание о ТО',
                subtitle: 'Замена масла через 500 км',
                time: 'вчера',
                isUrgent: false,
              ),
              _buildNotificationItem(
                context: context,
                icon: Icons.ac_unit,
                title: 'Сезонное обслуживание',
                subtitle: 'Проверьте кондиционер перед летом',
                time: '3 дня назад',
                isUrgent: false,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isUrgent,
  }) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isUrgent ? Colors.red.withOpacity(0.15) : AppTheme.deepOrange.withOpacity(0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 20,
          color: isUrgent ? Colors.red : AppTheme.deepOrange,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
          color: isUrgent ? Colors.red : onSurface,
          fontSize: 13,
        ),
      ),
      subtitle: subtitle.isNotEmpty ? Text(
        subtitle,
        style: TextStyle(fontSize: 11, color: onSurface.withOpacity(0.6)),
      ) : null,
      trailing: Text(
        time,
        style: TextStyle(fontSize: 11, color: onSurface.withOpacity(0.5)),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
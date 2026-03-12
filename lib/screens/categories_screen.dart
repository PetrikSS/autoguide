import 'package:flutter/material.dart';
import 'parts_list_screen.dart';
import '../models/car.dart';
import '../models/category.dart';
import '../data/mock_data.dart';
import '../theme.dart';

class CategoriesScreen extends StatelessWidget {
  final Car car;

  const CategoriesScreen({super.key, required this.car});

  // Определяем текущий сезон
  String _getCurrentSeason() {
    final now = DateTime.now();
    final month = now.month;

    if (month >= 3 && month <= 5) return 'Весна';
    if (month >= 6 && month <= 8) return 'Лето';
    if (month >= 9 && month <= 11) return 'Осень';
    return 'Зима';
  }

  // Получаем рекомендации по сезону
  List<Map<String, dynamic>> _getSeasonalChecks() {
    final season = _getCurrentSeason();

    switch (season) {
      case 'Весна':
        return [
          {'title': 'Смена шин', 'subtitle': 'Переобуваемся в летнюю резину', 'icon': Icons.tire_repair, 'urgent': true},
          {'title': 'Проверка кондиционера', 'subtitle': 'Заправка и диагностика', 'icon': Icons.ac_unit, 'urgent': false},
          {'title': 'Омывайка', 'subtitle': 'Заменить на летнюю', 'icon': Icons.water_drop, 'urgent': false},
        ];
      case 'Осень':
        return [
          {'title': 'Смена шин', 'subtitle': 'Готовим зимнюю резину', 'icon': Icons.tire_repair, 'urgent': true},
          {'title': 'Проверка печки', 'subtitle': 'Отопление и обогрев', 'icon': Icons.whatshot, 'urgent': true},
          {'title': 'Аккумулятор', 'subtitle': 'Проверка заряда', 'icon': Icons.battery_charging_full, 'urgent': false},
        ];
      case 'Зима':
        return [
          {'title': 'Аккумулятор', 'subtitle': 'Заряд и состояние', 'icon': Icons.battery_charging_full, 'urgent': true},
          {'title': 'Антифриз', 'subtitle': 'Проверка температуры замерзания', 'icon': Icons.opacity, 'urgent': true},
          {'title': 'Дворники', 'subtitle': 'Зимние щетки', 'icon': Icons.remove_red_eye, 'urgent': false},
        ];
      case 'Лето':
        return [
          {'title': 'Кондиционер', 'subtitle': 'Диагностика и заправка', 'icon': Icons.ac_unit, 'urgent': true},
          {'title': 'Охлаждающая жидкость', 'subtitle': 'Уровень и состояние', 'icon': Icons.thermostat, 'urgent': false},
          {'title': 'Фильтр салона', 'subtitle': 'Замена от пыльцы', 'icon': Icons.air, 'urgent': false},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = MockData.getCategories();
    final currentSeason = _getCurrentSeason();
    final seasonalChecks = _getSeasonalChecks();

    return Scaffold(
      appBar: AppBar(
        title: Text(car.fullName),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter позволяет вставить обычный виджет в Sliver-список
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Заголовок сезонной проверки
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
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '$currentSeason • Рекомендуемые проверки',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          // Показать все сезонные проверки
                        },
                        child: const Text('Все'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Карточка сезонной проверки
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.deepOrange.withOpacity(0.1),
                          AppTheme.lightOrange,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.deepOrange.withOpacity(0.3),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ...seasonalChecks.map((check) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: check['urgent']
                                        ? Colors.red.withOpacity(0.1)
                                        : AppTheme.deepOrange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    check['icon'],
                                    color: check['urgent']
                                        ? Colors.red
                                        : AppTheme.deepOrange,
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
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
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
                                          fontSize: 13,
                                          color: Colors.grey[600],
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

                          const Divider(height: 20),

                          // Кнопка "Напомнить позже"
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  // Отложить напоминание
                                },
                                icon: const Icon(Icons.notifications_none, size: 18),
                                label: const Text('Напомнить через неделю'),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppTheme.deepOrange,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.deepOrange,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Готово',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                  ),
                ],
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
                  color: Colors.grey[800],
                ),
              ),
            ),
          ),

          // Сетка категорий
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
                            car: car,
                            category: category,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppTheme.lightOrange,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  category.icon,
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              category.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${category.partCount} деталей',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
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
}
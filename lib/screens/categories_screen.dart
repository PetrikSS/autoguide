import 'package:flutter/material.dart';
import 'all_seasonal_checks_screen.dart';
import 'parts_list_screen.dart';
import 'profile_screen.dart';
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

          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {
                  // Показать уведомления - передаем контекст
                  _showNotificationsDialog(context);
                },
              ),
              // Индикатор новых уведомлений (красная точка)
              Positioned(
                right: 11,
                top: 11,
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
      // Добавляем Drawer (боковое меню)
      drawer: Drawer(
        child: ProfileScreen(), // Используем наш экран профиля как содержимое
      ),
      body: CustomScrollView(
        slivers: [
          // Сезонная проверка
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
                              const Text(
                                'Сезонное обслуживание',
                                style: TextStyle(
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
                      OutlinedButton(
                        onPressed: () {
                          // Переход на экран всех сезонных проверок
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllSeasonalChecksScreen(
                                currentSeason: currentSeason,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.deepOrange,
                          side: const BorderSide(
                              width: 2.0,
                              color: AppTheme.deepOrange
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        child: const Text('Все'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),


                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white,
                          Colors.white,
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
                      elevation:4,
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

  // Функция для показа диалога с уведомлениями
  void _showNotificationsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Уведомления',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildNotificationItem(
                context: context, // Передаем контекст явно
                icon: Icons.warning_amber,
                title: 'Срочно! Сезонная проверка',
                subtitle: 'Пора менять шины на зимние',
                time: '2 часа назад',
                isUrgent: true,
              ),
              _buildNotificationItem(
                context: context, // Передаем контекст явно
                icon: Icons.build,
                title: 'Напоминание о ТО',
                subtitle: 'Замена масла через 500 км',
                time: 'вчера',
                isUrgent: false,
              ),
              _buildNotificationItem(
                context: context, // Передаем контекст явно
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
    required BuildContext context, // Явно принимаем контекст
    required IconData icon,
    required String title,
    required String subtitle,
    required String time,
    required bool isUrgent,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isUrgent ? Colors.red.withOpacity(0.1) : AppTheme.lightOrange,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isUrgent ? Colors.red : AppTheme.deepOrange,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
          color: isUrgent ? Colors.red : Colors.black,
        ),
      ),
      subtitle: Text(subtitle),
      trailing: Text(
        time,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[500],
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Теперь context определен
        // Здесь можно добавить переход к соответствующему разделу
        // Например: Navigator.push(context, MaterialPageRoute(builder: (context) => SomeScreen()));
      },
    );
  }
}
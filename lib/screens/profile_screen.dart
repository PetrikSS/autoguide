import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car.dart';
import '../models/user.dart';
import '../theme.dart';
import '../theme_notifier.dart';
import 'car_selection_screen.dart';
import 'categories_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Car> _myCars = [];

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('my_cars') ?? [];
    setState(() {
      _myCars = list.map((e) => Car.fromJson(jsonDecode(e))).toList();
    });
  }

  Future<void> _removeCar(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _myCars.removeAt(index);
    await prefs.setStringList(
      'my_cars',
      _myCars.map((c) => jsonEncode(c.toJson())).toList(),
    );
    setState(() {});
  }

  Future<void> _confirmRemove(int index, Car car) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить автомобиль?', style: TextStyle(fontSize: 20),),
        content: Text('${car.fullName} будет удалён из списка.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(foregroundColor: Colors.grey),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppTheme.deepOrange),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed == true) _removeCar(index);
  }

  Future<void> _switchToCar(Car car) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_car', jsonEncode(car.toJson()));
    if (!mounted) return;
    Navigator.pop(context); // закрываем drawer
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CategoriesScreen(car: car)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = User.demoUser();

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Шапка профиля
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: AppTheme.deepOrange,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Center(
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.deepOrange,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  user.name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Мои автомобили
        _buildSection(
          title: 'Мои автомобили',
          child: Column(
            children: [
              ..._myCars.asMap().entries.map((entry) {
                final i = entry.key;
                final car = entry.value;
                return ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.lightOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        car.brand[0],
                        style: const TextStyle(fontSize: 16, color: AppTheme.deepOrange, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  title: Text(car.fullName),
                  // subtitle: Text('${car.generation} • ${car.years}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                    ],
                  ),
                  onTap: () => _switchToCar(car),
                  onLongPress: () => _confirmRemove(i, car),
                );
              }),
              ListTile(
                leading: Icon(Icons.add_circle_outline, color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Добавить автомобиль', style: TextStyle(fontSize: 15),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CarSelectionScreen(addMode: true)),
                  );
                },
              ),
            ],
          ),
        ),

        // const Divider(),

        // Сохранённые детали
        _buildSection(
          title: 'Сохраненные детали',
          child: Column(
            children: [
              ...user.savedParts.map((part) => ListTile(
                leading: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.lightOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.bookmark, size: 18, color: AppTheme.deepOrange),
                ),
                title: Text(part, style: TextStyle(fontSize: 15),),
                trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
                onTap: () => Navigator.pop(context),
              )),
            ],
          ),
        ),

        const Divider(),

        // Настройки
        _buildSection(
          title: 'Настройки',
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens_outlined, color: AppTheme.deepOrange),
                title: const Text('Тема оформления', style: TextStyle(fontSize: 15),),
                trailing: AnimatedBuilder(
                  animation: ThemeNotifier(),
                  builder: (_, __) => DropdownButton<ThemeMode>(
                    value: ThemeNotifier().mode,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: ThemeMode.light, child: Text('Светлая', style: TextStyle(fontSize: 13)),),
                      DropdownMenuItem(value: ThemeMode.dark, child: Text('Тёмная', style: TextStyle(fontSize: 13))),
                    ],
                    onChanged: (mode) {
                      if (mode != null) ThemeNotifier().setMode(mode);
                    },
                  ),
                ),
                onTap: null,
              ),
              ListTile(
                leading: const Icon(Icons.language, color: AppTheme.deepOrange),
                title: const Text('Язык', style: TextStyle(fontSize: 15),),
                trailing: const Text('Русский'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.notifications_outlined, color: AppTheme.deepOrange),
                title: const Text('Уведомления', style: TextStyle(fontSize: 15),),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                  activeColor: AppTheme.deepOrange,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('Выйти из аккаунта'),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        child,
      ],
    );
  }
}

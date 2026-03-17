import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.demoUser();

    return Drawer(
      child: ListView(
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
                  // Аватар
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
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
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
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
                ...user.favoriteCars.map((car) => ListTile(
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.lightOrange,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        car[0],
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.deepOrange,
                        ),
                      ),
                    ),
                  ),
                  title: Text(car),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                  onTap: () {
                    // Переключиться на этот автомобиль
                  },
                )),
                ListTile(
                  leading: const Icon(Icons.add_circle_outline),
                  title: const Text('Добавить автомобиль'),
                  onTap: () {
                    Navigator.pop(context);
                    // Перейти к выбору авто
                  },
                ),
              ],
            ),
          ),

          const Divider(),

          // Избранные детали
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
                    child: const Icon(
                      Icons.bookmark,
                      size: 18,
                      color: AppTheme.deepOrange,
                    ),
                  ),
                  title: Text(part),
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Перейти к детали
                  },
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
                  leading: Icon(
                    Icons.color_lens_outlined,
                    color: AppTheme.deepOrange,
                  ),
                  title: const Text('Тема оформления'),
                  trailing: const Text('Светлая'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: AppTheme.deepOrange,
                  ),
                  title: const Text('Язык'),
                  trailing: const Text('Русский'),
                  onTap: () {},
                ),
                ListTile(
                  leading: Icon(
                    Icons.notifications_outlined,
                    color: AppTheme.deepOrange,
                  ),
                  title: const Text('Уведомления'),
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

          // Кнопка выхода
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
      ),
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
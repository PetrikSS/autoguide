import 'package:flutter/material.dart';
import '../models/user.dart';
import '../theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = User.demoUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('AutoGiude'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // // Шапка профиля
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(24),
            //   decoration: BoxDecoration(
            //     color: AppTheme.deepOrange,
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(32),
            //       bottomRight: Radius.circular(32),
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       // Аватар
            //       Container(
            //         width: 100,
            //         height: 100,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           shape: BoxShape.circle,
            //           border: Border.all(
            //             color: Colors.white,
            //             width: 3,
            //           ),
            //         ),
            //         child: Center(
            //           child: Text(
            //             user.name[0].toUpperCase(),
            //             style: const TextStyle(
            //               fontSize: 40,
            //               fontWeight: FontWeight.bold,
            //               color: AppTheme.deepOrange,
            //             ),
            //           ),
            //         ),
            //       ),
            //       const SizedBox(height: 16),
            //       Text(
            //         user.name,
            //         style: const TextStyle(
            //           fontSize: 24,
            //           fontWeight: FontWeight.bold,
            //           color: Colors.white,
            //         ),
            //       ),
            //       const SizedBox(height: 4),
            //       Text(
            //         user.email,
            //         style: const TextStyle(
            //           fontSize: 16,
            //           color: Colors.white70,
            //         ),
            //       ),
            //       const SizedBox(height: 8),
            //       Text(
            //         'На автоcайтe с ${user.memberSince.day}.${user.memberSince.month}.${user.memberSince.year}',
            //         style: const TextStyle(
            //           fontSize: 14,
            //           color: Colors.white70,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            const SizedBox(height: 20),

            // Мои автомобили
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Мои автомобили',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...user.favoriteCars.map((car) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.lightOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            car[0],
                            style: TextStyle(
                              fontSize: 20,
                              color: AppTheme.deepOrange,
                            ),
                          ),
                        ),
                      ),
                      title: Text(car),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить автомобиль'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Избранные детали
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Сохраненные детали',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...user.savedParts.map((part) => Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.lightOrange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.bookmark,
                          color: AppTheme.deepOrange,
                        ),
                      ),
                      title: Text(part),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {},
                      ),
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Настройки
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Настройки',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Card(
                    child: Column(
                      children: [
                        // ListTile(
                        //   leading: Icon(
                        //     Icons.notifications_outlined,
                        //     color: AppTheme.deepOrange,
                        //   ),
                        //   title: const Text('Уведомления'),
                        //   trailing: Switch(
                        //     value: true,
                        //     onChanged: (value) {},
                        //     activeColor: AppTheme.deepOrange,
                        //   ),
                        // ),
                        // const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            Icons.color_lens_outlined,
                            color: AppTheme.deepOrange,
                          ),
                          title: const Text('Тема оформления'),
                          trailing: const Text('Светлая'),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: Icon(
                            Icons.language,
                            color: AppTheme.deepOrange,
                          ),
                          title: const Text('Язык'),
                          trailing: const Text('Русский'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // // Кнопка выхода
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 16),
            //   child: OutlinedButton(
            //     onPressed: () {},
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: Colors.red,
            //       side: const BorderSide(color: Colors.red),
            //       minimumSize: const Size(double.infinity, 50),
            //     ),
            //     child: const Text('Выйти из аккаунта'),
            //   ),
            // ),
            //
            // const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
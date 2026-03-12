class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final List<String> favoriteCars; // VIN или ID машин
  final List<String> savedParts; // Избранные детали
  final DateTime memberSince;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.favoriteCars,
    required this.savedParts,
    required this.memberSince,
  });

  // Для тестового пользователя
  factory User.demoUser() {
    return User(
      id: '1',
      name: 'Алексей Петров',
      email: 'alexey@example.com',
      avatarUrl: null,
      favoriteCars: ['Kia Rio 2019', 'Lada Granta 2021'],
      savedParts: ['Тормозные колодки', 'Масляный фильтр'],
      memberSince: DateTime(2024, 1, 15),
    );
  }
}
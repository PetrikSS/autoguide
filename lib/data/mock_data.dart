import '../models/car.dart';
import '../models/category.dart';
import '../models/part.dart';

class MockData {
  // ============ АВТОМОБИЛИ ============
  static List<Car> getCars() {    // <-- ЭТО МЕТОД, ВЫЗЫВАЕМ СО СКОБКАМИ
    return [
      Car(
        brand: 'Kia',
        model: 'Rio',
        generation: 'IV (QB)',
        years: '2017-2022',
        imageUrl: null,
      ),
      Car(
        brand: 'Hyundai',
        model: 'Solaris',
        generation: 'II (HC)',
        years: '2017-2022',
        imageUrl: null,
      ),
      Car(
        brand: 'Lada',
        model: 'Granta',
        generation: 'II',
        years: '2019-2023',
        imageUrl: null,
      ),
      Car(
        brand: 'Toyota',
        model: 'Camry',
        generation: 'XV70',
        years: '2018-2023',
        imageUrl: null,
      ),
      Car(
        brand: 'Volkswagen',
        model: 'Polo',
        generation: 'V',
        years: '2015-2020',
        imageUrl: null,
      ),
      Car(
        brand: 'Renault',
        model: 'Logan',
        generation: 'II',
        years: '2014-2020',
        imageUrl: null,
      ),
      Car(
        brand: 'Skoda',
        model: 'Octavia',
        generation: 'A7',
        years: '2013-2020',
        imageUrl: null,
      ),
      Car(
        brand: 'Nissan',
        model: 'Qashqai',
        generation: 'J11',
        years: '2014-2021',
        imageUrl: null,
      ),
    ];
  }

  // ============ КАТЕГОРИИ ============
  static List<Category> getCategories() {    // <-- МЕТОД
    return [
      Category(id: 'engine', name: 'Двигатель', icon: '🔧', partCount: 28),
      Category(id: 'brakes', name: 'Тормозная система', icon: '🛑', partCount: 22),
      Category(id: 'suspension', name: 'Ходовая часть', icon: '⚙️', partCount: 35),
      Category(id: 'electrics', name: 'Электрика', icon: '⚡', partCount: 25),
      Category(id: 'exhaust', name: 'Выхлопная система', icon: '💨', partCount: 14),
      Category(id: 'body', name: 'Кузов', icon: '🚘', partCount: 18),
      Category(id: 'interior', name: 'Салон и комфорт', icon: '🪑', partCount: 12),
      Category(id: 'cooling', name: 'Система охлаждения', icon: '❄️', partCount: 16),
      Category(id: 'fuel', name: 'Топливная система', icon: '⛽', partCount: 15),
      Category(id: 'transmission', name: 'Трансмиссия', icon: '⚙️', partCount: 20),
    ];
  }

  // ============ ДЕТАЛИ ============
  static List<Part> getParts() {    // <-- МЕТОД
    return [
      // === ТОРМОЗНАЯ СИСТЕМА ===
      Part(
        id: 'brake_pads_front',
        name: 'Тормозные колодки (передние)',
        categoryId: 'brakes',
        description: 'Фрикционные накладки, которые прижимаются к тормозному диску для замедления автомобиля.',
        location: 'Внутри тормозного суппорта на передних колесах',
        priceRange: '2 500 - 6 000 ₽ за комплект',
        symptoms: [
          'Скрип или визг при торможении',
          'Увеличенный тормозной путь',
        ],
        tools: [
          'Домкрат',
          'Баллонный ключ',
          'Набор ключей',
        ],
        instructions: '''ПОДГОТОВКА:
1. Установите авто на ровную поверхность
2. Ослабьте болты колеса
3. Поднимите домкратом''',
        difficulty: 'Средне',
        estimatedTimeMin: 90,
        videoUrl: null,
        oemNumbers: ['58101-4AA00', '58101-4AA10'],
        imageUrl: '',
      ),

      Part(
        id: 'oil_filter',
        name: 'Масляный фильтр',
        categoryId: 'engine',
        description: 'Очищает моторное масло от продуктов износа двигателя.',
        location: 'Сбоку на двигателе, в нижней части',
        priceRange: '300 - 1 500 ₽',
        symptoms: [
          'Давление масла упало',
          'Двигатель работает громче',
        ],
        tools: [
          'Ключ для масляного фильтра',
          'Емкость для масла',
        ],
        instructions: '''ПОДГОТОВКА:
1. Прогрейте двигатель
2. Слейте масло''',
        difficulty: 'Легко',
        estimatedTimeMin: 45,
        videoUrl: null,
        oemNumbers: ['26300-35503', 'MANN W811/80'],
        imageUrl: '',
      ),
    ];
  }

  // Получить детали по категории
  static List<Part> getPartsByCategory(String categoryId) {    // <-- МЕТОД
    return getParts().where((part) => part.categoryId == categoryId).toList();
  }

  // Получить деталь по ID
  static Part? getPartById(String id) {    // <-- МЕТОД
    try {
      return getParts().firstWhere((part) => part.id == id);
    } catch (e) {
      return null;
    }
  }
}
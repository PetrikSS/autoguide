import 'dart:convert';
import 'dart:io' show Platform, File, Directory; // <-- ДОБАВЛЯЕМ ЭТОТ ИМПОРТ
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/car.dart';
import '../models/category.dart';
import '../models/part.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static bool _initialized = false;

  // Инициализация для Windows (упрощённая)
  static void _initializeForWindows() {
    if (!_initialized) {
      try {
        // Проверяем, что мы на Windows через dart:io
        if (Platform.isWindows) {
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
          print('✅ SQLite инициализирован для Windows');
        }
      } catch (e) {
        print('⚠️ Не удалось определить платформу: $e');
        // Если не удалось определить, пробуем инициализировать FFI в любом случае
        try {
          sqfliteFfiInit();
          databaseFactory = databaseFactoryFfi;
        } catch (e) {
          print('⚠️ FFI инициализация не удалась: $e');
        }
      }
      _initialized = true;
    }
  }

  Future<Database> get database async {
    // Инициализируем для Windows
    _initializeForWindows();

    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Получаем правильную папку для хранения данных приложения
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'autoguide.db');

    print('📁 Путь к базе данных приложения: $path');
    print('📁 Путь к assets: assets/database/autoguide.db');

    // Проверяем, есть ли уже база
    bool dbExists = await File(path).exists();
    print('📁 База уже существует? $dbExists');

    if (!dbExists) {
      print('🔄 База не найдена, копируем из assets...');
      try {
        // Копируем из assets
        ByteData data = await rootBundle.load('assets/database/autoguide.db');
        print('✅ Файл в assets найден, размер: ${data.lengthInBytes} байт');

        List<int> bytes = data.buffer.asUint8List(
          data.offsetInBytes,
          data.lengthInBytes,
        );
        await File(path).writeAsBytes(bytes);
        print('✅ База скопирована успешно');
      } catch (e) {
        print('❌ Ошибка копирования базы данных: $e');
      }
    } else {
      print('✅ База уже существует');

      // Для отладки: проверим размер существующей базы
      File dbFile = File(path);
      int fileSize = await dbFile.length();
      print('📊 Размер существующей базы: $fileSize байт');
    }

    // Открываем базу
    return await openDatabase(path);
  }

  // ============ МЕТОДЫ ДЛЯ РАБОТЫ С МАШИНАМИ ============
  Future<List<Car>> getCars() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('cars');

    print('🚗 Найдено машин в базе: ${maps.length}');
    if (maps.isNotEmpty) {
      print('📝 Первая машина: ${maps[0]}');
    } else {
      print('⚠️ Таблица cars пуста!');

      // Проверим, есть ли вообще таблица cars
      try {
        var tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
        print('📊 Таблицы в базе: $tables');
      } catch (e) {
        print('❌ Ошибка при проверке таблиц: $e');
      }
    }

    return List.generate(maps.length, (i) {
      return Car(
        brand: maps[i]['brand'],
        model: maps[i]['model'],
        generation: maps[i]['generation'],
        years: maps[i]['years'],
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }

  // ============ МЕТОДЫ ДЛЯ РАБОТЫ С КАТЕГОРИЯМИ ============
  Future<List<Category>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');

    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
        icon: maps[i]['icon'],
        partCount: maps[i]['partCount'],
      );
    });
  }

  // ============ МЕТОДЫ ДЛЯ РАБОТЫ С ДЕТАЛЯМИ ============
  Future<List<Part>> getParts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('parts');

    return List.generate(maps.length, (i) {
      return Part(
        id: maps[i]['id'],
        name: maps[i]['name'],
        categoryId: maps[i]['categoryId'],
        description: maps[i]['description'],
        location: maps[i]['location'],
        priceRange: maps[i]['priceRange'],
        symptoms: List<String>.from(json.decode(maps[i]['symptoms'])),
        tools: List<String>.from(json.decode(maps[i]['tools'])),
        instructions: maps[i]['instructions'],
        difficulty: maps[i]['difficulty'],
        estimatedTimeMin: maps[i]['estimatedTimeMin'],
        videoUrl: maps[i]['videoUrl'],
        oemNumbers: List<String>.from(json.decode(maps[i]['oemNumbers'])),
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }

  Future<List<Part>> getPartsByCategory(String categoryId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'parts',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );

    return List.generate(maps.length, (i) {
      return Part(
        id: maps[i]['id'],
        name: maps[i]['name'],
        categoryId: maps[i]['categoryId'],
        description: maps[i]['description'],
        location: maps[i]['location'],
        priceRange: maps[i]['priceRange'],
        symptoms: List<String>.from(json.decode(maps[i]['symptoms'])),
        tools: List<String>.from(json.decode(maps[i]['tools'])),
        instructions: maps[i]['instructions'],
        difficulty: maps[i]['difficulty'],
        estimatedTimeMin: maps[i]['estimatedTimeMin'],
        videoUrl: maps[i]['videoUrl'],
        oemNumbers: List<String>.from(json.decode(maps[i]['oemNumbers'])),
        imageUrl: maps[i]['imageUrl'],
      );
    });
  }

  Future<Part?> getPartById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'parts',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;

    return Part(
      id: maps[0]['id'],
      name: maps[0]['name'],
      categoryId: maps[0]['categoryId'],
      description: maps[0]['description'],
      location: maps[0]['location'],
      priceRange: maps[0]['priceRange'],
      symptoms: List<String>.from(json.decode(maps[0]['symptoms'])),
      tools: List<String>.from(json.decode(maps[0]['tools'])),
      instructions: maps[0]['instructions'],
      difficulty: maps[0]['difficulty'],
      estimatedTimeMin: maps[0]['estimatedTimeMin'],
      videoUrl: maps[0]['videoUrl'],
      oemNumbers: List<String>.from(json.decode(maps[0]['oemNumbers'])),
      imageUrl: maps[0]['imageUrl'],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'categories_screen.dart';
import 'vin_search_screen.dart';
import '../models/car.dart';
import '../database/database_helper.dart';
import '../theme.dart';

class CarSelectionScreen extends StatefulWidget {
  const CarSelectionScreen({super.key});

  @override
  State<CarSelectionScreen> createState() => _CarSelectionScreenState();
}

class _CarSelectionScreenState extends State<CarSelectionScreen> {
  List<Car> cars = [];
  bool isLoading = true;
  String? errorMessage;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  List<Car> get _filteredCars {
    if (_searchQuery.isEmpty) return cars;
    final q = _searchQuery.toLowerCase();
    return cars.where((c) =>
    c.brand.toLowerCase().contains(q) ||
        c.model.toLowerCase().contains(q) ||
        c.generation.toLowerCase().contains(q) ||
        c.years.contains(q)
    ).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    try {
      final dbHelper = DatabaseHelper();
      final loadedCars = await dbHelper.getCars();

      setState(() {
        cars = loadedCars;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Ошибка загрузки: $e';
      });
      print('Ошибка загрузки машин: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите автомобиль'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Поиск по названию (перенесен выше)
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск по марке, модели, году...',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black, // Оранжевая иконка поиска
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.deepOrange,
                      width: 2,
                    ),
                  ),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),

              const SizedBox(height: 16),

              // Быстрый поиск по VIN
              _buildVinSearch(),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _searchQuery.isEmpty ? 'Популярные модели' : 'Результаты поиска',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  if (_searchQuery.isNotEmpty)
                    Text(
                      '${_filteredCars.length} авто',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              if (_filteredCars.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text('Ничего не найдено', style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                  ),
                )
              else
                ..._filteredCars.map((car) => _buildCarCard(car, context)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVinSearch() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VinSearchScreen(cars: cars),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightOrange,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppTheme.deepOrange,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.deepOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.manage_search, // Изменена иконка на VIN
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Найти по VIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Введите VIN-номер',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: AppTheme.deepOrange,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.lightOrange,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              car.brand[0],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.deepOrange,
              ),
            ),
          ),
        ),
        title: Text(
          car.fullName,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text('${car.generation} • ${car.years}'),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: AppTheme.deepOrange,
          size: 16,
        ),
        onTap: () async {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('selected_car', jsonEncode(car.toJson()));
          if (!context.mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoriesScreen(car: car),
            ),
          );
        },
      ),
    );
  }
}
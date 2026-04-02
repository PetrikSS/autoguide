import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'categories_screen.dart';
import 'vin_search_screen.dart';
import 'auth_screen.dart';
import '../models/car.dart';
import '../database/database_helper.dart';
import '../theme.dart';

class CarSelectionScreen extends StatefulWidget {
  final bool addMode;

  const CarSelectionScreen({super.key, this.addMode = false});

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
    if (!widget.addMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showAuthPrompt());
    }
  }

  Future<void> _showAuthPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final shown = prefs.getBool('auth_prompt_shown') ?? false;
    if (shown || !mounted) return;
    await prefs.setBool('auth_prompt_shown', true);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 20),
              Container(
                width: 64, height: 64,
                decoration: BoxDecoration(
                  color: AppTheme.deepOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, size: 36, color: AppTheme.deepOrange),
              ),
              const SizedBox(height: 16),
              const Text(
                'Создайте профиль',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Сохраняйте историю обслуживания, избранные детали и настройки в своём аккаунте.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Авторизоваться', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    foregroundColor: Colors.grey[700],
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Пропустить', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        );
      },
    );
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
        title: Text(widget.addMode ? 'Добавить автомобиль' : 'Выберите автомобиль'),
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
              // Поиск по названию
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск по марке, модели, году...',
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
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
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.deepOrange, width: 2),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          color: isDark ? const Color(0xFF1E1E1E) : AppTheme.lightOrange,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.deepOrange, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.deepOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.manage_search, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Найти по VIN',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Введите VIN-номер',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppTheme.deepOrange, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCarCard(Car car, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        if (widget.addMode) {
          final list = prefs.getStringList('my_cars') ?? [];
          final carJson = jsonEncode(car.toJson());
          if (!list.contains(carJson)) {
            list.add(carJson);
            await prefs.setStringList('my_cars', list);
          }
        } else {
          await prefs.setString('selected_car', jsonEncode(car.toJson()));
          final list = prefs.getStringList('my_cars') ?? [];
          final carJson = jsonEncode(car.toJson());
          if (!list.contains(carJson)) {
            list.add(carJson);
            await prefs.setStringList('my_cars', list);
          }
        }
        if (!context.mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CategoriesScreen(car: car)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.deepOrange.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.deepOrange.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  car.brand[0],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.deepOrange),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car.fullName, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: onSurface)),
                  const SizedBox(height: 2),
                  Text('${car.generation} • ${car.years}', style: TextStyle(fontSize: 13, color: onSurface.withOpacity(0.6))),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: AppTheme.deepOrange, size: 16),
          ],
        ),
      ),
    );
  }
}
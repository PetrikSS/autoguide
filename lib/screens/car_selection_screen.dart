import 'package:flutter/material.dart';
import 'categories_screen.dart';
import '../models/car.dart';
import '../data/mock_data.dart';
import '../theme.dart';

class CarSelectionScreen extends StatelessWidget {
   CarSelectionScreen({super.key});

  final List<Car> cars = MockData.getCars();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите автомобиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Поиск
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Быстрый поиск по VIN
              Container(
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
                        Icons.qr_code_scanner,
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
                            'Сфотографируйте или введите VIN-номер',
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

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Популярные модели',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Все марки'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Список авто
              ...cars.map((car) => _buildCarCard(car, context)),
            ],
          ),
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
        onTap: () {
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
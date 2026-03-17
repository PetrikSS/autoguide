import 'package:flutter/material.dart';
import 'part_detail_screen.dart';
import '../models/car.dart';
import '../models/category.dart';
import '../data/mock_data.dart';
import '../theme.dart';

class PartsListScreen extends StatelessWidget {
  final Car car;
  final Category category;


  const PartsListScreen({
    super.key,
    required this.car,
    required this.category
  });

  @override
  Widget build(BuildContext context) {
    final parts = MockData.getPartsByCategory(category.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: parts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.build_circle_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'В этой категории пока нет деталей',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: parts.length,
        itemBuilder: (context, index) {
          final part = parts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.lightOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _getIconForCategory(category.id),
                    color: AppTheme.deepOrange,
                  ),
                ),
              ),
              title: Text(
                part.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    part.priceRange,
                    style: TextStyle(
                      color: AppTheme.deepOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(part.difficulty).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          part.difficulty,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getDifficultyColor(part.difficulty),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.timer,
                        size: 14,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${part.estimatedTimeMin} мин',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.deepOrange,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PartDetailScreen(
                      car: car,
                      part: part,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForCategory(String categoryId) {
    switch (categoryId) {
      case 'engine': return Icons.engineering;
      case 'brakes': return Icons.dangerous;
      case 'suspension': return Icons.balance;
      case 'electrics': return Icons.bolt;
      case 'exhaust': return Icons.cloud;
      case 'body': return Icons.car_repair;
      case 'interior': return Icons.chair;
      case 'cooling': return Icons.ac_unit;
      case 'fuel': return Icons.local_gas_station;
      case 'transmission': return Icons.settings;
      default: return Icons.build;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Легко': return Colors.green;
      case 'Средне': return AppTheme.deepOrange;
      case 'Сложно': return Colors.red;
      default: return Colors.grey;
    }
  }
}
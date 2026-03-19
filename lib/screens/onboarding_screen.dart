import 'package:flutter/material.dart';
import 'car_selection_screen.dart';
import '../theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _onboardingData = [
    OnboardingItem(
      title: 'Добро пожаловать в AutoGuidePro!',
      description: 'Ваш персональный помощник по ремонту автомобиля. Здесь вы найдете всё, чтобы понять устройство машины и научиться её чинить.',
      icon: Icons.auto_awesome,
      color: AppTheme.deepOrange,
    ),
    OnboardingItem(
      title: 'Все детали на ладони',
      description: 'Выберите марку и модель авто, и получите полный каталог всех деталей с подробным описанием, где они находятся и за что отвечают.',
      icon: Icons.category,
      color: AppTheme.deepOrange,
    ),
    OnboardingItem(
      title: 'Пошаговые инструкции',
      description: 'Каждая деталь содержит подробную инструкцию по замене, список инструментов, признаки неисправности и примерную стоимость.',
      icon: Icons.menu_book,
      color: AppTheme.deepOrange,
    ),
    OnboardingItem(
      title: 'Экономьте на ремонте',
      description: 'Узнайте, что можно починить своими руками, а когда лучше обратиться в сервис. Сэкономьте тысячи рублей!',
      icon: Icons.attach_money,
      color: AppTheme.deepOrange,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Переходим к выбору авто
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  CarSelectionScreen()),
      );
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) =>  CarSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Кнопка пропуска
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Пропустить',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // PageView с контентом
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildOnboardingPage(_onboardingData[index]);
                },
              ),
            ),

            // Индикаторы страниц
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                    (index) => _buildPageIndicator(index),
              ),
            ),

            const SizedBox(height: 32),

            // Кнопка действия
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.deepOrange,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _currentPage == _onboardingData.length - 1
                      ? 'Начать пользоваться'
                      : 'Далее',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Анимированная иконка
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: item.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                item.icon,
                size: 100,
                color: item.color,
              ),
            ),
          ),

          const SizedBox(height: 48),

          // Заголовок
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          // Описание
          Text(
            item.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(int index) {
    return Container(
      width: _currentPage == index ? 24 : 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: _currentPage == index
            ? AppTheme.deepOrange
            : AppTheme.deepOrange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
import 'package:flutter/material.dart';
import '../theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTab = 0;

  // Авторизация
  final _loginEmailController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  bool _loginPasswordVisible = false;

  // Регистрация
  final _regNameController = TextEditingController();
  final _regEmailController = TextEditingController();
  final _regPasswordController = TextEditingController();
  final _regRepeatPasswordController = TextEditingController();
  bool _regPasswordVisible = false;
  bool _regRepeatVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _currentTab = _tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailController.dispose();
    _loginPasswordController.dispose();
    _regNameController.dispose();
    _regEmailController.dispose();
    _regPasswordController.dispose();
    _regRepeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Аккаунт'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),

          // Переключатель вкладок
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: AppTheme.deepOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: onSurface.withOpacity(0.5),
                labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                tabs: const [
                  Tab(text: 'Авторизация'),
                  Tab(text: 'Регистрация'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Контент вкладок
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoginTab(context, isDark, onSurface),
                _buildRegisterTab(context, isDark, onSurface),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab(BuildContext context, bool isDark, Color onSurface) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 16),
          // Center(
          //   child: Container(
          //     width: 72,
          //     height: 72,
          //     decoration: BoxDecoration(
          //       color: AppTheme.deepOrange.withOpacity(0.1),
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Icon(Icons.person_outline, size: 40, color: AppTheme.deepOrange),
          //   ),
          // ),
          // const SizedBox(height: 24),
          Text('Войдите в аккаунт', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: onSurface)),
          const SizedBox(height: 8),
          Text('Введите почту и пароль', style: TextStyle(fontSize: 14, color: onSurface.withOpacity(0.5))),
          const SizedBox(height: 32),

          _buildField(
            controller: _loginEmailController,
            label: 'Электронная почта',
            hint: 'example@mail.ru',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
            onSurface: onSurface,
          ),
          const SizedBox(height: 16),
          _buildField(
            controller: _loginPasswordController,
            label: 'Пароль',
            hint: 'password1234',
            icon: Icons.lock_outline,
            obscure: !_loginPasswordVisible,
            isDark: isDark,
            onSurface: onSurface,
            suffixIcon: IconButton(
              icon: Icon(
                _loginPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: onSurface.withOpacity(0.5),
              ),
              onPressed: () => setState(() => _loginPasswordVisible = !_loginPasswordVisible),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text('Забыли пароль?', style: TextStyle(color: AppTheme.deepOrange)),
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Войти', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
          // Center(
          //   child: TextButton(
          //     onPressed: () => _tabController.animateTo(1),
          //     child: RichText(
          //       text: TextSpan(
          //         text: 'Нет аккаунта? ',
          //         style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 14),
          //         children: const [
          //           TextSpan(text: 'Зарегистрироваться', style: TextStyle(color: AppTheme.deepOrange, fontWeight: FontWeight.w600)),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildRegisterTab(BuildContext context, bool isDark, Color onSurface) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 16),
          // Center(
          //   child: Container(
          //     width: 72,
          //     height: 72,
          //     decoration: BoxDecoration(
          //       color: AppTheme.deepOrange.withOpacity(0.1),
          //       shape: BoxShape.circle,
          //     ),
          //     child: const Icon(Icons.person_add_outlined, size: 40, color: AppTheme.deepOrange),
          //   ),
          // ),
          // const SizedBox(height: 24),
          Text('Создайте аккаунт', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: onSurface)),
          const SizedBox(height: 8),
          Text('Заполните данные для регистрации', style: TextStyle(fontSize: 14, color: onSurface.withOpacity(0.5))),
          const SizedBox(height: 32),

          _buildField(
            controller: _regNameController,
            label: 'Имя пользователя',
            hint: 'Иван Иванов',
            icon: Icons.badge_outlined,
            isDark: isDark,
            onSurface: onSurface,
          ),
          const SizedBox(height: 16),
          _buildField(
            controller: _regEmailController,
            label: 'Электронная почта',
            hint: 'example@mail.ru',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            isDark: isDark,
            onSurface: onSurface,
          ),
          const SizedBox(height: 16),
          _buildField(
            controller: _regPasswordController,
            label: 'Пароль',
            hint: 'password1234',
            icon: Icons.lock_outline,
            obscure: !_regPasswordVisible,
            isDark: isDark,
            onSurface: onSurface,
            suffixIcon: IconButton(
              icon: Icon(
                _regPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: onSurface.withOpacity(0.5),
              ),
              onPressed: () => setState(() => _regPasswordVisible = !_regPasswordVisible),
            ),
          ),
          // const SizedBox(height: 16),
          // _buildField(
          //   controller: _regRepeatPasswordController,
          //   label: 'Повторите пароль',
          //   hint: 'password1234',
          //   icon: Icons.lock_outline,
          //   obscure: !_regRepeatVisible,
          //   isDark: isDark,
          //   onSurface: onSurface,
          //   suffixIcon: IconButton(
          //     icon: Icon(
          //       _regRepeatVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          //       color: onSurface.withOpacity(0.5),
          //     ),
          //     onPressed: () => setState(() => _regRepeatVisible = !_regRepeatVisible),
          //   ),
          // ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Зарегистрироваться', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 16),
          // Center(
          //   child: TextButton(
          //     onPressed: () => _tabController.animateTo(0),
          //     child: RichText(
          //       text: TextSpan(
          //         text: 'Уже есть аккаунт? ',
          //         style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 14),
          //         children: const [
          //           TextSpan(text: 'Войти', style: TextStyle(color: AppTheme.deepOrange, fontWeight: FontWeight.w600)),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    required Color onSurface,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: onSurface.withOpacity(0.7))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: onSurface.withOpacity(0.35)),
            prefixIcon: Icon(icon, color: AppTheme.deepOrange, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: onSurface.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.deepOrange, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

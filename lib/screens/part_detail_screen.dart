import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/car.dart';
import '../models/part.dart';
import '../services/saved_parts_service.dart';
import '../theme.dart';
import 'auth_screen.dart';

class PartDetailScreen extends StatefulWidget {
  final Car car;
  final Part part;

  const PartDetailScreen({super.key, required this.car, required this.part});

  @override
  State<PartDetailScreen> createState() => _PartDetailScreenState();
}

class _PartDetailScreenState extends State<PartDetailScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkSaved();
  }

  Future<void> _checkSaved() async {
    final saved = await SavedPartsService.isSaved(widget.part.id);
    if (mounted) setState(() => _isSaved = saved);
  }

  Future<void> _toggleSave() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Требуется авторизация', style: TextStyle(fontSize: 20),),
          content: const Text('Войдите в аккаунт, чтобы сохранять детали.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              style: TextButton.styleFrom(foregroundColor: Colors.grey),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const AuthScreen()));
              },
              style: TextButton.styleFrom(foregroundColor: AppTheme.deepOrange),
              child: const Text('Войти'),
            ),
          ],
        ),
      );
      return;
    }
    await SavedPartsService.toggle(widget.part);
    setState(() => _isSaved = !_isSaved);
  }

  Color _cardBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white;

  Color _text(BuildContext context) => Theme.of(context).colorScheme.onSurface;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.part.name),
        actions: [
          IconButton(
            icon: Icon(
              _isSaved ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.white,
            ),
            onPressed: _toggleSave,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              color: isDark ? const Color(0xFF1A1A1A) : Colors.grey.shade200,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 64, color: isDark ? Colors.white24 : Colors.grey[400]),
                        const SizedBox(height: 8),
                        Text('Фото детали', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500])),
                        const SizedBox(height: 4),
                        Text('нажмите для увеличения', style: TextStyle(color: isDark ? Colors.white24 : Colors.grey[400], fontSize: 12)),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 16, right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(widget.part.difficulty),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(widget.part.difficulty, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _card(context, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        const Icon(Icons.directions_car, size: 20, color: AppTheme.deepOrange),
                        const SizedBox(width: 8),
                        Expanded(child: Text(widget.car.fullInfo, style: TextStyle(fontWeight: FontWeight.w600, color: _text(context)))),
                      ]),
                      const SizedBox(height: 12),
                      Divider(height: 1, color: _text(context).withOpacity(0.1)),
                      const SizedBox(height: 12),
                      Row(children: [
                        const Icon(Icons.qr_code, size: 20, color: AppTheme.deepOrange),
                        const SizedBox(width: 8),
                        Text('Оригинальные номера (OEM):', style: TextStyle(fontWeight: FontWeight.w600, color: _text(context))),
                      ]),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: widget.part.oemNumbers.map((oem) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.deepOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.deepOrange.withOpacity(0.3)),
                          ),
                          child: Text(oem, style: const TextStyle(fontSize: 12, color: AppTheme.deepOrange)),
                        )).toList(),
                      ),
                    ],
                  )),
                  const SizedBox(height: 12),
                  _infoRow(context, 'Назначение', widget.part.description, Icons.info_outline),
                  const SizedBox(height: 12),
                  _infoRow(context, 'Расположение', widget.part.location, Icons.location_on),
                  const SizedBox(height: 12),
                  _infoRow(context, 'Стоимость', widget.part.priceRange, Icons.attach_money),
                  const SizedBox(height: 16),
                  _card(context,
                    borderColor: Colors.red.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.warning_amber_rounded, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Признаки неисправности', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red)),
                        ]),
                        const SizedBox(height: 12),
                        ...widget.part.symptoms.map((s) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(' ', style: TextStyle(fontSize: 16, color: Colors.red)),
                              Expanded(child: Text(s, style: TextStyle(fontSize: 15, color: _text(context)))),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _card(context, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(children: [
                        Icon(Icons.handyman, color: AppTheme.deepOrange),
                        SizedBox(width: 8),
                        Text('Необходимые инструменты', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepOrange)),
                      ]),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, runSpacing: 8,
                        children: widget.part.tools.map((tool) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.deepOrange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.deepOrange.withOpacity(0.3)),
                          ),
                          child: Text(tool, style: const TextStyle(color: AppTheme.deepOrange, fontWeight: FontWeight.w500)),
                        )).toList(),
                      ),
                    ],
                  )),
                  const SizedBox(height: 16),
                  _card(context,
                    borderColor: AppTheme.deepOrange.withOpacity(0.3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.menu_book, color: AppTheme.deepOrange),
                          const SizedBox(width: 8),
                          const Expanded(child: Text('Инструкция по замене', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepOrange))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.deepOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(children: [
                              const Icon(Icons.timer, size: 14, color: AppTheme.deepOrange),
                              const SizedBox(width: 4),
                              Text('~${widget.part.estimatedTimeMin} мин', style: const TextStyle(fontSize: 12, color: AppTheme.deepOrange, fontWeight: FontWeight.w500)),
                            ]),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        Text(widget.part.instructions, style: TextStyle(height: 1.6, fontSize: 15, color: _text(context))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (widget.part.videoUrl != null) ...[
                    _card(context,
                      borderColor: Colors.red.withOpacity(0.2),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Видеоинструкция', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _text(context))),
                            Text('Смотреть на YouTube', style: TextStyle(fontSize: 14, color: _text(context).withOpacity(0.6))),
                          ],
                        )),
                        const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
                      ]),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Row(children: [
                    Expanded(child: ElevatedButton(onPressed: () {}, child: const Text('Где купить?'))),
                    const SizedBox(width: 12),
                    Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('СТО рядом'))),
                  ]),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child, Color? borderColor}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor ?? AppTheme.deepOrange.withOpacity(0.15)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _infoRow(BuildContext context, String title, String content, IconData icon) {
    return _card(context, child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.deepOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppTheme.deepOrange, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: _text(context).withOpacity(0.6))),
            const SizedBox(height: 4),
            Text(content, style: TextStyle(fontSize: 15, height: 1.4, color: _text(context))),
          ],
        )),
      ],
    ));
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
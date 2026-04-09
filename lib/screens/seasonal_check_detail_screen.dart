import 'package:flutter/material.dart';
import '../models/seasonal_check.dart';
import '../theme.dart';

class SeasonalCheckDetailScreen extends StatelessWidget {
  final SeasonalCheck check;

  const SeasonalCheckDetailScreen({super.key, required this.check});

  Color _cardBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1E1E1E)
          : Colors.white;

  Color _text(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  Color _seasonColor() {
    switch (check.season) {
      case 'Весна': return Colors.green;
      case 'Лето': return Colors.orange;
      case 'Осень': return Colors.brown;
      case 'Зима': return Colors.blue;
      default: return AppTheme.deepOrange;
    }
  }

  Color _getDifficultyColor(String? d) {
    switch (d) {
      case 'Легко': return Colors.green;
      case 'Средне': return AppTheme.deepOrange;
      case 'Сложно': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final seasonColor = _seasonColor();

    return Scaffold(
      appBar: AppBar(
        title: Text(check.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото / заглушка
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
                        Icon(Icons.image, size: 64, color: isDark ? Colors.white24 : Colors.grey[400],),
                        const SizedBox(height: 8),
                        Text('Фото детали', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Text('нажмите для увеличения', style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontSize: 12)),
                      ],
                    ),
                  ),
                  if (check.difficulty != null)
                    Positioned(
                      top: 16, right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(check.difficulty),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(check.difficulty!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
                      ),
                    ),
                  Positioned(
                    top: 16, left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: seasonColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(check.season, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 12)),
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
                  // Мета-инфо: сезон, месяцы, время
                  _card(context, child: Row(
                    children: [
                      if (check.optimalMonths != null) ...[
                        Icon(Icons.calendar_today, size: 18, color: AppTheme.deepOrange),
                        const SizedBox(width: 6),
                        Expanded(child: Text(check.optimalMonths!, style: TextStyle(color: _text(context), fontWeight: FontWeight.w500))),
                      ],
                      if (check.estimatedTimeMin != null) ...[
                        Icon(Icons.timer, size: 18, color: AppTheme.deepOrange),
                        const SizedBox(width: 4),
                        Text('~${check.estimatedTimeMin} мин', style: TextStyle(color: _text(context), fontWeight: FontWeight.w500)),
                      ],
                    ],
                  )),

                  const SizedBox(height: 12),

                  // Описание
                  if (check.description != null)
                    _infoRow(context, 'Описание', check.description!, Icons.info_outline),

                  if (check.priceRange != null) ...[
                    const SizedBox(height: 12),
                    _infoRow(context, 'Стоимость', check.priceRange!, Icons.attach_money),
                  ],

                  const SizedBox(height: 16),

                  // Признаки необходимости
                  if (check.symptoms.isNotEmpty)
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
                          ...check.symptoms.map((s) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontSize: 16, color: Colors.red)),
                                Expanded(child: Text(s, style: TextStyle(fontSize: 15, color: _text(context)))),
                              ],
                            ),
                          )),
                        ],
                      ),
                    ),

                  if (check.note != null) ...[
                    const SizedBox(height: 16),
                    _card(context,
                      borderColor: Colors.amber.withOpacity(0.4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline, color: Colors.amber),
                          const SizedBox(width: 10),
                          Expanded(child: Text(check.note!, style: TextStyle(fontSize: 14, color: _text(context), height: 1.4))),
                        ],
                      ),
                    ),
                  ],

                  if (check.tools.isNotEmpty) ...[
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
                          children: check.tools.map((tool) => Container(
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
                  ],

                  if (check.instruction != null) ...[
                    const SizedBox(height: 16),
                    _card(context,
                      borderColor: AppTheme.deepOrange.withOpacity(0.3),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.menu_book, color: AppTheme.deepOrange),
                            const SizedBox(width: 8),
                            const Expanded(child: Text('Инструкция', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.deepOrange))),
                            if (check.estimatedTimeMin != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.deepOrange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(children: [
                                  const Icon(Icons.timer, size: 14, color: AppTheme.deepOrange),
                                  const SizedBox(width: 4),
                                  Text('~${check.estimatedTimeMin} мин', style: const TextStyle(fontSize: 12, color: AppTheme.deepOrange, fontWeight: FontWeight.w500)),
                                ]),
                              ),
                          ]),
                          const SizedBox(height: 16),
                          Text(check.instruction!, style: TextStyle(height: 1.6, fontSize: 15, color: _text(context))),
                        ],
                      ),
                    ),
                  ],

                  if (check.videoUrl != null) ...[
                    const SizedBox(height: 16),
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
                            Text('Смотреть на RuTube', style: TextStyle(fontSize: 14, color: _text(context).withOpacity(0.6))),
                          ],
                        )),
                        const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
                      ]),
                    ),
                  ],

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
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
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
}

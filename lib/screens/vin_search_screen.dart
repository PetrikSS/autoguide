import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/car.dart';
import '../theme.dart';
import 'categories_screen.dart';

class VinSearchScreen extends StatefulWidget {
  final List<Car> cars;

  const VinSearchScreen({super.key, required this.cars});

  @override
  State<VinSearchScreen> createState() => _VinSearchScreenState();
}

class _VinSearchScreenState extends State<VinSearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  VinDecodeResult? _result;
  String? _error;

  // WMI → (страна, производитель)
  static const Map<String, List<String>> _wmiMap = {
    'XTA': ['Россия', 'АвтоВАЗ (Lada)'],
    'XTT': ['Россия', 'АвтоВАЗ (Lada)'],
    'X7L': ['Россия', 'АвтоВАЗ (Lada)'],
    'WBA': ['Германия', 'BMW'],
    'WBS': ['Германия', 'BMW M'],
    'WBY': ['Германия', 'BMW'],
    'WAU': ['Германия', 'Audi'],
    'WVW': ['Германия', 'Volkswagen'],
    'WV1': ['Германия', 'Volkswagen'],
    'WV2': ['Германия', 'Volkswagen'],
    'WME': ['Германия', 'Smart'],
    'WDB': ['Германия', 'Mercedes-Benz'],
    'WDC': ['Германия', 'Mercedes-Benz'],
    'WDD': ['Германия', 'Mercedes-Benz'],
    'W0L': ['Германия', 'Opel'],
    'SAJ': ['Великобритания', 'Jaguar'],
    'SAL': ['Великобритания', 'Land Rover'],
    'SCC': ['Великобритания', 'Lotus'],
    'JHM': ['Япония', 'Honda'],
    'JH4': ['Япония', 'Acura'],
    'JN1': ['Япония', 'Nissan'],
    'JN8': ['Япония', 'Nissan'],
    'JT2': ['Япония', 'Toyota'],
    'JT3': ['Япония', 'Toyota'],
    'JTD': ['Япония', 'Toyota'],
    'JTE': ['Япония', 'Toyota'],
    'JTJ': ['Япония', 'Lexus'],
    'JTH': ['Япония', 'Lexus'],
    'JS1': ['Япония', 'Suzuki'],
    'JS2': ['Япония', 'Suzuki'],
    'JS3': ['Япония', 'Suzuki'],
    'KMH': ['Южная Корея', 'Hyundai'],
    'KNA': ['Южная Корея', 'Kia'],
    'KNM': ['Южная Корея', 'Renault Samsung'],
    '1HG': ['США', 'Honda'],
    '1G1': ['США', 'Chevrolet'],
    '1GC': ['США', 'Chevrolet'],
    '1FA': ['США', 'Ford'],
    '1FB': ['США', 'Ford'],
    '1FT': ['США', 'Ford'],
    '2HG': ['Канада', 'Honda'],
    '3VW': ['Мексика', 'Volkswagen'],
    'YV1': ['Швеция', 'Volvo'],
    'YV4': ['Швеция', 'Volvo'],
    'ZFF': ['Италия', 'Ferrari'],
    'ZAR': ['Италия', 'Alfa Romeo'],
    'ZAM': ['Италия', 'Maserati'],
    'VF1': ['Франция', 'Renault'],
    'VF3': ['Франция', 'Peugeot'],
    'VF7': ['Франция', 'Citroën'],
    'VSS': ['Испания', 'SEAT'],
    'TMB': ['Чехия', 'Škoda'],
    'LFV': ['Китай', 'Volkswagen (FAW)'],
    'LGX': ['Китай', 'Buick'],
  };

  // Год по 10-му символу VIN
  static const Map<String, int> _yearMap = {
    'A': 1980, 'B': 1981, 'C': 1982, 'D': 1983, 'E': 1984,
    'F': 1985, 'G': 1986, 'H': 1987, 'J': 1988, 'K': 1989,
    'L': 1990, 'M': 1991, 'N': 1992, 'P': 1993, 'R': 1994,
    'S': 1995, 'T': 1996, 'V': 1997, 'W': 1998, 'X': 1999,
    'Y': 2000, '1': 2001, '2': 2002, '3': 2003, '4': 2004,
    '5': 2005, '6': 2006, '7': 2007, '8': 2008, '9': 2009,
    // 'A': 2010, 'B': 2011, 'C': 2012, 'D': 2013, 'E': 2014,
    // 'F': 2015, 'G': 2016, 'H': 2017, 'J': 2018, 'K': 2019,
    // 'L': 2020, 'M': 2021, 'N': 2022, 'P': 2023, 'R': 2024,
  };

  // Более точная таблица с учётом цикличности
  int? _decodeYear(String char) {
    const cycle1 = {
      'A': 1980, 'B': 1981, 'C': 1982, 'D': 1983, 'E': 1984,
      'F': 1985, 'G': 1986, 'H': 1987, 'J': 1988, 'K': 1989,
      'L': 1990, 'M': 1991, 'N': 1992, 'P': 1993, 'R': 1994,
      'S': 1995, 'T': 1996, 'V': 1997, 'W': 1998, 'X': 1999,
      'Y': 2000, '1': 2001, '2': 2002, '3': 2003, '4': 2004,
      '5': 2005, '6': 2006, '7': 2007, '8': 2008, '9': 2009,
    };
    const cycle2 = {
      'A': 2010, 'B': 2011, 'C': 2012, 'D': 2013, 'E': 2014,
      'F': 2015, 'G': 2016, 'H': 2017, 'J': 2018, 'K': 2019,
      'L': 2020, 'M': 2021, 'N': 2022, 'P': 2023, 'R': 2024,
      'S': 2025, 'T': 2026, 'V': 2027, 'W': 2028, 'X': 2029,
    };
    // Берём более поздний год (скорее всего актуальнее)
    return cycle2[char] ?? cycle1[char];
  }

  void _decode() {
    final vin = _controller.text.trim().toUpperCase();

    if (vin.length != 17) {
      setState(() {
        _error = 'VIN должен содержать 17 символов';
        _result = null;
      });
      return;
    }

    // Запрещённые символы в VIN: I, O, Q
    if (vin.contains(RegExp(r'[IOQ]'))) {
      setState(() {
        _error = 'Не может содержать буквы I, O, Q';
        _result = null;
      });
      return;
    }

    final wmi = vin.substring(0, 3);
    final yearChar = vin[9];
    final year = _decodeYear(yearChar);
    final wmiInfo = _wmiMap[wmi];

    // Ищем совпадение в базе по марке
    Car? matchedCar;
    if (wmiInfo != null) {
      final manufacturer = wmiInfo[1].toLowerCase();
      matchedCar = widget.cars.firstWhere(
        (c) => manufacturer.contains(c.brand.toLowerCase()) ||
               c.brand.toLowerCase().contains(manufacturer.split(' ')[0]),
        orElse: () => widget.cars.first,
      );
      // Проверяем что совпадение реальное
      final brandMatch = wmiInfo[1].toLowerCase().contains(matchedCar.brand.toLowerCase()) ||
          matchedCar.brand.toLowerCase().contains(wmiInfo[1].split(' ')[0].toLowerCase());
      if (!brandMatch) matchedCar = null;
    }

    setState(() {
      _error = null;
      _result = VinDecodeResult(
        vin: vin,
        country: wmiInfo?[0] ?? 'Неизвестно',
        manufacturer: wmiInfo?[1] ?? 'Неизвестно (WMI: $wmi)',
        year: year,
        wmi: wmi,
        vds: vin.substring(3, 9),
        vis: vin.substring(9, 17),
        matchedCar: matchedCar,
      );
    });
  }

  Future<void> _selectCar(Car car) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_car', jsonEncode(car.toJson()));
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CategoriesScreen(car: car)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск по VIN'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Поле ввода VIN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : AppTheme.lightOrange,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.deepOrange),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Введите VIN-номер',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurface),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'VIN состоит из 17 символов (буквы и цифры)',
                    style: TextStyle(fontSize: 13, color: onSurface.withOpacity(0.6)),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLength: 17,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                    ],
                    decoration: InputDecoration(
                      hintText: 'Например: XTA210990Y2800000',
                      hintStyle: TextStyle(color: onSurface.withOpacity(0.4), fontSize: 14),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _controller.clear();
                                setState(() { _result = null; _error = null; });
                              },
                            )
                          : null,
                      counterText: '',
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _decode(),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _controller.text.length == 17 ? _decode : null,
                      icon: const Icon(Icons.search),
                      label: const Text('Определить автомобиль'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.deepOrange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],

            if (_result != null) ...[
              const SizedBox(height: 24),
              const Text(
                'Результат декодирования',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // VIN структура
              Card(
                color: cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Визуализация VIN
                      _buildVinVisual(_result!),
                      const Divider(height: 24),
                      _buildInfoRow(Icons.flag, 'Страна производства', _result!.country),
                      const SizedBox(height: 12),
                      _buildInfoRow(Icons.factory, 'Производитель', _result!.manufacturer),
                      const SizedBox(height: 12),
                      _buildInfoRow(
                        Icons.calendar_today,
                        'Год выпуска',
                        _result!.year != null ? '${_result!.year}' : 'Не определён',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Найденный автомобиль в базе
              if (_result!.matchedCar != null) ...[
                const Text(
                  'Найдено в базе',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  color: cardColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.deepOrange.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _result!.matchedCar!.brand[0],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.deepOrange,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      _result!.matchedCar!.fullName,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Text('${_result!.matchedCar!.generation} • ${_result!.matchedCar!.years}'),
                    trailing: Icon(Icons.arrow_forward_ios, color: AppTheme.deepOrange, size: 16),
                    onTap: () => _selectCar(_result!.matchedCar!),
                  ),
                ),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade700),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Автомобиль не найден в базе. Выберите вручную из списка.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            // Подсказка где найти VIN
            const SizedBox(height: 24),
            _buildVinHint(),
          ],
        ),
      ),
    );
  }

  Widget _buildVinVisual(VinDecodeResult result) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Структура VIN', style: TextStyle(fontSize: 13, color: onSurface.withOpacity(0.6))),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildVinSegment(result.wmi, 'WMI\nПроизводитель', Colors.blue),
            const SizedBox(width: 4),
            _buildVinSegment(result.vds, 'VDS\nМодель', Colors.green),
            const SizedBox(width: 4),
            _buildVinSegment(result.vis, 'VIS\nСерийный №', AppTheme.deepOrange),
          ],
        ),
      ],
    );
  }

  Widget _buildVinSegment(String text, String label, Color color) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 13, color: color, letterSpacing: 2),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: onSurface.withOpacity(0.5))),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppTheme.deepOrange.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppTheme.deepOrange, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: onSurface.withOpacity(0.6))),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: onSurface)),
          ],
        ),
      ],
    );
  }

  Widget _buildVinHint() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.white12 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.help_outline, size: 18, color: onSurface),
            const SizedBox(width: 8),
            Text('Где найти VIN?', style: TextStyle(fontWeight: FontWeight.bold, color: onSurface)),
          ]),
          const SizedBox(height: 12),
          _buildHintItem('На передней панели (видно через лобовое стекло)'),
          _buildHintItem('На стойке водительской двери'),
          _buildHintItem('В техническом паспорте (СТС/ПТС)'),
          _buildHintItem('На табличке в моторном отсеке'),
        ],
      ),
    );
  }

  Widget _buildHintItem(String text) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 6, color: AppTheme.deepOrange),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: onSurface))),
        ],
      ),
    );
  }
}

class VinDecodeResult {
  final String vin;
  final String country;
  final String manufacturer;
  final int? year;
  final String wmi;
  final String vds;
  final String vis;
  final Car? matchedCar;

  VinDecodeResult({
    required this.vin,
    required this.country,
    required this.manufacturer,
    this.year,
    required this.wmi,
    required this.vds,
    required this.vis,
    this.matchedCar,
  });
}

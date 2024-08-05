import 'package:flutter/material.dart';

void main() {
  runApp(TempConversionApp());
}

class TempConversionApp extends StatelessWidget {
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, ThemeMode currentMode, __) {
        return MaterialApp(
          title: 'Temperature Conversion',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFD3D3D3),
            appBarTheme: const AppBarTheme(
              color: Color(0xFFADD8E6),
              iconTheme: IconThemeData(color: Color(0xFF000000)),
              titleTextStyle: TextStyle(color: Color(0xFF000000), fontSize: 20),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF000000)),
              bodyMedium: TextStyle(color: Color(0xFF000000)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFADD8E6),
                foregroundColor: const Color(0xFF000000),
              ),
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF000000),
            appBarTheme: const AppBarTheme(
              color: Color(0xFF8B4513),
              iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
              titleTextStyle: TextStyle(color: Color(0xFFFFFFFF), fontSize: 20),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
              bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B4513),
                foregroundColor: const Color(0xFFFFFFFF),
              ),
            ),
          ),
          themeMode: currentMode,
          home: TempConversionHomePage(notifier: _notifier),
        );
      },
    );
  }
}

class TempConversionHomePage extends StatefulWidget {
  final ValueNotifier<ThemeMode> notifier;

  const TempConversionHomePage({required this.notifier});

  @override
  _TempConversionHomePageState createState() => _TempConversionHomePageState();
}

class _TempConversionHomePageState extends State<TempConversionHomePage> {
  final _temperatureController = TextEditingController();
  String _conversionType = 'f-to-c';
  String _result = '';
  List<String> _history = [];

  void _convertTemperature() {
    final double? temperature = double.tryParse(_temperatureController.text);
    if (temperature == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid temperature')),
      );
      return;
    }

    double result;
    String historyEntry;
    if (_conversionType == 'f-to-c') {
      result = (temperature - 32) * 5 / 9;
      historyEntry = 'F to C: ${temperature.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}';
    } else {
      result = (temperature * 9 / 5) + 32;
      historyEntry = 'C to F: ${temperature.toStringAsFixed(1)} => ${result.toStringAsFixed(2)}';
    }

    setState(() {
      _result = result.toStringAsFixed(2);
      _history.add(historyEntry);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temperature Conversion'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              widget.notifier.value =
                  widget.notifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _temperatureController,
              decoration: const InputDecoration(
                labelText: 'Enter Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _conversionType,
              onChanged: (String? newValue) {
                if (newValue != null && newValue != _conversionType) {
                  setState(() {
                    _conversionType = newValue;
                  });
                }
              },
              items: const [
                DropdownMenuItem(
                  value: 'f-to-c',
                  child: Text('Fahrenheit to Celsius'),
                ),
                DropdownMenuItem(
                  value: 'c-to-f',
                  child: Text('Celsius to Fahrenheit'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertTemperature,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 16),
            Text(
              'Converted Temperature: $_result',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Conversion History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_history[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _temperatureController.dispose();
    super.dispose();
  }
}

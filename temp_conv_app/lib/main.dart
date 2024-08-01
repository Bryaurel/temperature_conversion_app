import 'package:flutter/material.dart';

void main() {
  runApp(TempConversionApp());
}

class TempConversionApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Temperature Conversion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TempConversionHomePage(),
    );
  }
}

class TempConversionHomePage extends StatefulWidget {
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
        SnackBar(content: Text('Please enter a valid temperature')),
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
        title: Text('Temperature Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _temperatureController,
              decoration: InputDecoration(
                labelText: 'Enter Temperature',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _conversionType,
              onChanged: (String? newValue) {
                setState(() {
                  _conversionType = newValue!;
                });
              },
              items: [
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _convertTemperature,
              child: Text('Convert'),
            ),
            SizedBox(height: 16),
            Text(
              'Converted Temperature: $_result',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
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

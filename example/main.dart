import 'package:flutter/material.dart';
import 'package:injecta/injecta.dart';

final services = ServiceRegistry(
  services: [
    () => CounterService(),
  ],
);

void main() {
  runApp(const App());
}

class CounterService {
  int counter = 0;

  void increment() => counter++;
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => services.get<CounterService>().increment(),
    );
  }
}

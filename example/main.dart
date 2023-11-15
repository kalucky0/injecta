import 'package:flutter/widgets.dart';
import 'package:injecta/injecta.dart';

void main() {
  runApp(
    ServiceRegistry(
      services: [
        () => CounterService(),
      ],
      child: const App(),
    ),
  );
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
      onTap: () => context.read<CounterService>().increment(),
    );
  }
}

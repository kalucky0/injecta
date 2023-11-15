# Injecta

![Code license (MIT)](https://img.shields.io/github/license/kalucky0/injecta)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/kalucky0/injecta)
![GitHub issues](https://img.shields.io/github/issues/kalucky0/injecta)

Injecta is a lightweight Flutter library that provides a simple and efficient service registry for managing dependencies in your Flutter applications. It can be used instead of InheritedWidget or Provider to access objects e.g. from your UI.

## Installation

To use Injecta in your Flutter project, add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  injecta: ^0.1.0
```

Then, run: 

```
flutter pub get
```

## Usage

1. **Create a `ServiceRegistry`**
\
Wrap your `MaterialApp` or any other widget with a `ServiceRegistry`. Pass a list of functions that create instances of your services to the services parameter.

```dart
ServiceRegistry(
    services: [
        () => CounterService(),
    ],
    child: const HomeScreen(),
),
```

2. **Access Services in your Widgets**
\
Use the `context.read<T>()` method to access services within your widgets. The services will be lazily initialized and cached.

```dart
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<CounterService>().increment();
        setState(() {});
      },
      child: Text('${context.read<CounterService>().counter}'),
    );
  }
}
```

## Contributing

Contributions are welcome! If you find any issues or have suggestions for improvements, please [open an issue](https://github.com/kalucky0/injecta/issues) or [submit a pull request](https://github.com/kalucky0/injecta/pulls) on the [GitHub repository](https://github.com/kalucky0/injecta).

## License

Injecta is distributed under the MIT License. See the [LICENSE.md](https://github.com/kalucky0/injecta/blob/master/LICENSE.md) file for more information.
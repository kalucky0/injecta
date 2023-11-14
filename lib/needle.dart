library needle;

import 'package:flutter/widgets.dart';

class ServiceRegistry extends InheritedWidget {
  ServiceRegistry({
    required this.services,
    required super.child,
    super.key,
  });

  final List<Object Function()> services;
  final List<Object> _initialized = [];

  T read<T>() {
    return _initialized.firstWhere((e) => e is T, orElse: () {
      final service = services.firstWhere((e) => e is T Function(), orElse: () {
        throw ServiceNotFoundException(T);
      })();
      _initialized.add(service);
      return service;
    }) as T;
  }

  static ServiceRegistry? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ServiceRegistry>();
  }

  static ServiceRegistry of(BuildContext context) {
    final ServiceRegistry? result = maybeOf(context);
    assert(result != null, 'No ServiceRegistry found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(ServiceRegistry oldWidget) {
    return services != oldWidget.services;
  }
}

extension Needle on BuildContext {
  T read<T>() {
    return ServiceRegistry.of(this).read<T>();
  }
}

class ServiceNotFoundException implements Exception {
  ServiceNotFoundException(
    this.valueType,
  );

  final Type valueType;

  @override
  String toString() {
    return 'Error: Could not find the $valueType service';
  }
}

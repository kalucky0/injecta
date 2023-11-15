/// A simple dependency injection library for Flutter applications.
library injecta;

import 'package:flutter/widgets.dart';

/// A widget that provides a registry for managing and accessing services.
class ServiceRegistry extends InheritedWidget {
  /// Creates a [ServiceRegistry].
  ///
  /// The [services] parameter is a list of functions that provide the services.
  ///
  /// The [child] parameter is the widget tree that this [InheritedWidget] wraps.
  ///
  /// The [key] parameter is an optional key to distinguish this [InheritedWidget].
  ServiceRegistry({
    required this.services,
    required super.child,
    super.key,
  });

  /// A list of functions that provide services.
  final List<Object Function()> services;

  /// A list of initialized services to avoid redundant creation.
  final List<Object> _initialized = [];

  /// Reads and retrieves a service of type [T].
  ///
  /// If the service is not yet initialized, it is created using the provided function.
  T read<T>() {
    return _initialized.firstWhere((e) => e is T, orElse: () {
      final service = services.firstWhere((e) => e is T Function(), orElse: () {
        throw ServiceNotFoundException(T);
      })();
      _initialized.add(service);
      return service;
    }) as T;
  }

  /// Returns the [ServiceRegistry] instance associated with the nearest
  /// ancestor [ServiceRegistry] found in the widget tree.
  static ServiceRegistry? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ServiceRegistry>();
  }

  /// Returns the [ServiceRegistry] instance associated with
  /// the nearest ancestor [ServiceRegistry] found in the widget tree.
  ///
  /// Throws an assertion error if no [ServiceRegistry] is found.
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

/// An extension on [BuildContext] providing a convenient method to
/// read services from the nearest [ServiceRegistry].
extension InjectaExtension  on BuildContext {
  /// Reads and retrieves a service of type [T] from the nearest [ServiceRegistry].
  T read<T>() {
    return ServiceRegistry.of(this).read<T>();
  }
}

/// Exception thrown when a service of a specific type is not found in the [ServiceRegistry].
class ServiceNotFoundException implements Exception {
  /// Creates a [ServiceNotFoundException] with the specified [valueType].
  ServiceNotFoundException(
    this.valueType,
  );

  /// The type of the service that was not found.
  final Type valueType;

  @override
  String toString() {
    return 'Error: Could not find the $valueType service';
  }
}

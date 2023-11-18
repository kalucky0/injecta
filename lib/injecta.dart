/// A simple dependency injection library for Flutter applications.
library injecta;

/// A registry for managing and accessing services.
class ServiceRegistry {
  /// Creates a [ServiceRegistry].
  ///
  /// The [services] parameter is a list of functions that provide the services.
  ServiceRegistry({
    required this.services,
  });

  /// A list of functions that provide services.
  final List<Object Function()> services;

  /// A list of initialized services to avoid redundant creation.
  final List<Object> _initialized = [];

  /// Reads and retrieves a service of type [T].
  ///
  /// If the service is not yet initialized, it is created using the provided function.
  T get<T>() {
    return _initialized.firstWhere((e) => e is T, orElse: () {
      final service = services.firstWhere((e) => e is T Function(), orElse: () {
        throw ServiceNotFoundException(T);
      })();
      _initialized.add(service);
      return service;
    }) as T;
  }

  /// Resets the initialized instance of the service of type [T], if it exists.
  void reset<T>() {
    _initialized.removeWhere((e) => e is T);
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

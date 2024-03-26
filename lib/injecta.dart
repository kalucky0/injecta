/// A simple dependency injection library for Flutter applications.
library injecta;

/// A registry for managing and accessing services.
class ServiceRegistry<S> {
  /// Creates a [ServiceRegistry].
  ///
  /// The [services] parameter is a list of functions that provide the services.
  ServiceRegistry({
    required List<S Function()> services,
  }) : _services = services;

  final List<S Function()> _services;
  final List<Type> _initializedTypes = [];
  final List<S> _initializedServices = [];

  /// Reads and retrieves a service of type [T].
  ///
  /// If the service is not yet initialized, it is created using the provided function.
  T get<T extends S>() {
    return _initializedServices.firstWhere((e) => e is T, orElse: () {
      final service = _services.firstWhere(
        (e) => e is T Function(),
        orElse: () => throw ServiceNotFoundException(T),
      )();
      _initializedTypes.add(service.runtimeType);
      _initializedServices.add(service);
      return service;
    }) as T;
  }

  /// Returns an iterable of all the services.
  ///
  /// This method iterates over the `_services` list and yields the first initialized instance of each service.
  /// If a service has not been initialized yet, it initializes it, adds it to the `_initializedServices` list, and returns it.
  ///
  /// The returned iterable can be used to access all the initialized services.
  Iterable<S> getAll() {
    return _services.map((s) {
      final service = s();
      if (_initializedTypes.contains(service.runtimeType)) {
        return _initializedServices.firstWhere(
          (e) => e.runtimeType == service.runtimeType,
        );
      }
      _initializedTypes.add(service.runtimeType);
      _initializedServices.add(service);
      return service;
    });
  }

  /// Resets the initialized instance of the service of type [T], if it exists.
  void reset<T>() {
    _initializedServices.removeWhere((e) => e is T);
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

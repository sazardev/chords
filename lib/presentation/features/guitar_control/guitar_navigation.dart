import 'package:go_router/go_router.dart';

/// Lo que el menú de la guitarra necesita del enrutador de la app.
abstract interface class GuitarNavigation {
  /// Ruta en la que está la persona ahora.
  String get location;

  /// Va a [path] sustituyendo la pila de pantallas.
  void go(String path);

  /// Vuelve a la pantalla anterior; sin anterior, al inicio.
  void back();
}

/// [GuitarNavigation] sobre un [GoRouter].
class RouterGuitarNavigation implements GuitarNavigation {
  /// Crea la navegación sobre [router].
  RouterGuitarNavigation(this.router, {required this.home});

  /// Enrutador de la app.
  final GoRouter router;

  /// Ruta a la que se vuelve si no hay pantalla anterior.
  final String home;

  @override
  String get location => router.routerDelegate.currentConfiguration.uri.path;

  @override
  void go(String path) => router.go(path);

  @override
  void back() {
    if (router.canPop()) {
      router.pop();
    } else {
      router.go(home);
    }
  }
}

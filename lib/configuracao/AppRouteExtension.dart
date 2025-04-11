import 'package:flutter_app_helio/enums/AppRouteEnum.dart';

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.estado:
        return '/estado';
      case AppRoute.cidade:
        return '/cidade';
      case AppRoute.pessoa:
        return '/pessoa';
      case AppRoute.categoria:
        return '/categoria';
      case AppRoute.produto:
        return '/produto';
    }
  }
}

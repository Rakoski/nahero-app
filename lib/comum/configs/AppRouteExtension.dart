import 'package:flutter_app_helio/comum/enums/AppRouteEnum.dart';

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.listaSimulados:
        return '/lista-simulados';
      case AppRoute.listaQuestoes:
        return '/lista-questoes';
      case AppRoute.formularioQuestao:
        return '/formulario-questao';
      case AppRoute.formularioSimulado:
        return '/formulario-simulado';
    }
  }
}

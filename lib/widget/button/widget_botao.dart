import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/configs/AppRouteExtension.dart';
import 'package:flutter_app_helio/comum/enums/AppRouteEnum.dart';

class WidgetBotao extends StatelessWidget {
  final String rota;
  final String rotulo;
  WidgetBotao({required this.rota, required this.rotulo});

  Widget criarBotao(BuildContext context, String texto, AppRoute rota) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(rota.path);
      },
      child: Text(rotulo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        criarBotao(
          context,
          'Formlário de simulado',
          AppRoute.formularioSimulado,
        ),
      ],
    );
  }
}

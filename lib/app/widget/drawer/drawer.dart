import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/configs/AppRouteExtension.dart';
import 'package:flutter_app_helio/comum/enums/AppRouteEnum.dart';

class DrawerApp extends StatelessWidget {
  //método - define, repete, parâmetro (não tem, diferentes)
  Widget criarBotao(BuildContext context, String rotulo, AppRoute rota) {
    return ElevatedButton(
      child: Text(rotulo),
      onPressed: () {
        Navigator.of(context).pushNamed(rota.path);
      },
    );
  }

  @override
  Drawer build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          criarBotao(context, 'Lista de Simulados', AppRoute.listaSimulados),
          // const SizedBox(height: 20),
          // criarBotao(context, 'Lista de Questões', AppRoute.listaQuestoes),
          // const SizedBox(height: 20),
          // criarBotao(context, 'Cadastro de simulado', AppRoute.wizardSimulado),
        ],
      ),
    );
  }
}

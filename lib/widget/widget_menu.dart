import 'package:flutter/material.dart';
import 'package:flutter_app_helio/configuracao/AppRouteExtension.dart';
import 'package:flutter_app_helio/enums/AppRouteEnum.dart';

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({key}) : super(key: key);

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
  Widget build(BuildContext context) {
    return Column(
      children: [
        criarBotao(context, 'Cadastro de estado', AppRoute.estado),
        criarBotao(context, 'Cadastro de cidade', AppRoute.cidade),
        criarBotao(context, 'Cadastro de pessoa', AppRoute.pessoa),
        criarBotao(context, 'Cadastro de produto', AppRoute.produto),
        criarBotao(context, 'Cadastro de categoria', AppRoute.categoria),
      ],
    );
  }
}

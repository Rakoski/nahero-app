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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          criarBotao(context, 'Cadastro de estado', AppRoute.estado),
          const SizedBox(height: 10),
          criarBotao(context, 'Cadastro de cidade', AppRoute.cidade),
          const SizedBox(height: 10),
          criarBotao(context, 'Cadastro de pessoa', AppRoute.pessoa),
          const SizedBox(height: 10),
          criarBotao(context, 'Cadastro de produto', AppRoute.produto),
          const SizedBox(height: 10),
          criarBotao(context, 'Cadastro de categoria', AppRoute.categoria),
          const SizedBox(height: 10),
          criarBotao(context, 'Lista de Pessoas', AppRoute.listPessoa),
          const SizedBox(height: 10),
          criarBotao(context, 'Lista de Cidades', AppRoute.listCidade),
        ],
      ),
    );
  }
}

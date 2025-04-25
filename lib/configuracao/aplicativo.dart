import 'package:flutter/material.dart';
import 'package:flutter_app_helio/configuracao/rotas.dart';
import 'package:flutter_app_helio/widget/lista/widget_nome_lista.dart';
import 'package:flutter_app_helio/widget/widget_categoria.dart';
import 'package:flutter_app_helio/widget/widget_cidade.dart';
import 'package:flutter_app_helio/widget/widget_cidade_lista.dart';
import 'package:flutter_app_helio/widget/widget_estado.dart';
import 'package:flutter_app_helio/widget/menu/widget_menu.dart';
import 'package:flutter_app_helio/widget/lista/widget_lista_simulados.dart';
import 'package:flutter_app_helio/widget/lista/widget_pessoa_lista.dart';
import 'package:flutter_app_helio/widget/widget_produto.dart';

class Aplicativo extends StatelessWidget {
  const Aplicativo({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula Widget',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WidgetMenu(),
        Rotas.estado: (context) => const WidgetEstado(),
        Rotas.cidade: (context) => WidgetCidade(),
        Rotas.listaPessoa: (context) => WidgetPessoaLista(),
        Rotas.categoria: (context) => const WidgetCategoria(),
        Rotas.produto: (context) => const WidgetProduto(),
        Rotas.listaSimulados: (context) => const WidgetSimuladosLista(),
        Rotas.listaCidade: (context) => WidgetCidadeLista(),
        Rotas.listaNome: (context) => WidgetNomesLista(),
      },
    );
  }
}

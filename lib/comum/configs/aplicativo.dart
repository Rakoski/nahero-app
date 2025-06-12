import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/configs/rotas.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/paginas/simulado/lista_simulados_page.dart';
import 'package:flutter_app_helio/paginas/simulado/questoes_simulado_page.dart';
import 'package:flutter_app_helio/paginas/simulado/simulado_wizard_page.dart';
import 'package:flutter_app_helio/widget/menu/widget_menu.dart';

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

        Rotas.listaSimulados: (context) => const ListaSimuladosPage(),

        Rotas.listaQuestoes:
            (context) => QuestoesSimuladoPage(
              simulado: Simulado(
                id: '1',
                titulo: 'Simulado Padrão',
                descricao: 'Simulado para navegação',
                pontuacaoAprovacao: 70,
                tempoLimite: 60,
                nivelDificuldade: 3,
                estaAtivo: true,
              ),
            ),

        Rotas.wizardSimulado:
            (context) => SimuladoWizardPage(
              onSave: (simulado) {
                print('Simulado criado: ${simulado.titulo}');
              },
            ),
      },
    );
  }
}

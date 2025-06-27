import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/configs/rotas.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/app/paginas/lista_simulados_page.dart';
import 'package:flutter_app_helio/app/paginas/questoes_simulado_page.dart';
import 'package:flutter_app_helio/app/paginas/simulado_wizard_page.dart';
import 'package:flutter_app_helio/app/paginas/home.dart';

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
        '/': (context) => const Home(),

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

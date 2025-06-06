import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/configs/AppRouteExtension.dart';
import 'package:flutter_app_helio/comum/enums/AppRouteEnum.dart';
import 'package:flutter_app_helio/widget/card/card.dart';
import 'package:flutter_app_helio/widget/drawer/drawer.dart';

final List<Widget> cardsSimulados = [
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
  WidgetCard(
    nome: 'AWS Cloud Practitioner',
    descricao:
        'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
    altura: 204,
    largura: 250,
  ),
];

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nahero - Simulados Grátis',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        backgroundColor: Colors.orange,
      ),
      drawerScrimColor: Colors.blueGrey,
      drawer: DrawerApp(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 16.0),
              Container(
                alignment: Alignment.topCenter,
                child: const Text(
                  'Nahero - Simulados Grátis',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Container(
                alignment: Alignment.bottomCenter,
                child: SearchBar(
                  onTap: () => {print("tapou")},
                  hintText: 'Pesquisar...',
                ),
              ),
              SizedBox(height: 16.0),
              Wrap(
                spacing: 150.0,
                runSpacing: 30.0,
                direction: Axis.horizontal,
                children: cardsSimulados,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

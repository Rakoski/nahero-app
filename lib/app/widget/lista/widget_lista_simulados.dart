import 'package:flutter/material.dart';
import 'package:flutter_app_helio/app/widget/card/card.dart';

class WidgetSimuladosLista extends StatelessWidget {
  const WidgetSimuladosLista({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Simulados!')),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder:
            (context, index) => WidgetCard(
              nome: 'AWS Cloud Practitioner',
              descricao:
                  'Fundação: A practice exam to test your knowledge of AWS Services. Foundational.',
              altura: 200,
              largura: 300,
            ),
      ),
    );
  }
}

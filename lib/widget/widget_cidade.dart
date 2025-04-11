import 'package:flutter/material.dart';

class WidgetCidade extends StatefulWidget {
  WidgetCidade({Key? key}) : super(key: key);

  @override
  _WidgetCidadeState createState() => _WidgetCidadeState();
}

class _WidgetCidadeState extends State<WidgetCidade> {
  String? nomeCidade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cidade')),
      body: Center(
        child: DropdownButton<String>(
          hint: Text('Selecione um estado'),
          value: nomeCidade,
          items: [
            DropdownMenuItem(value: 'estado1', child: Text('PR')),
            DropdownMenuItem(value: 'estado2', child: Text('SC')),
            DropdownMenuItem(value: 'estado3', child: Text('RS')),
          ],
          onChanged: (value) {
            setState(() {
              nomeCidade = value;
            });
          },
        ),
      ),
    );
  }
}

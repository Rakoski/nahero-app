import 'package:flutter/material.dart';

class WidgetCard extends StatelessWidget {
  final String nome;
  final String descricao;
  final double altura;
  final double largura;

  WidgetCard({
    super.key,
    required this.nome,
    required this.descricao,
    required this.altura,
    required this.largura,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largura,
      height: altura,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.album),
              title: Text(nome),
              subtitle: Text(descricao),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateColor.transparent,
                  ),
                  child: const Text('Começar'),
                  onPressed: () {
                    print("Começou");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

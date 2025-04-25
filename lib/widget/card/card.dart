import 'package:flutter/material.dart';

class WidgetCard extends StatelessWidget {
  final String nome;
  final String descricao;
  const WidgetCard({super.key, required this.nome, required this.descricao});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200.0,
      height: 300.0,
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
                  child: const Text('Começar'),
                  onPressed: () {
                    print("Começou");
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

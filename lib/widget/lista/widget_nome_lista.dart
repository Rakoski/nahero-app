import 'package:flutter/material.dart';

class WidgetNomesLista extends StatefulWidget {
  @override
  _Lista createState() {
    return _Lista();
  }
}

class _Lista extends State<WidgetNomesLista> {
  var nomes = ['Mateus', 'Hélio', 'Lucas'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('lista'),
        actions: [
          IconButton(
            onPressed: () {
              print('deu certo! ${nomes.length}');
              setState(() {
                nomes.add('João');
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => Text(nomes[i]),
        itemCount: nomes.length,
      ),
    );
  }
}

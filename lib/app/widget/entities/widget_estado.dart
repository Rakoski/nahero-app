import 'package:flutter/material.dart';

class WidgetEstado extends StatelessWidget {
  const WidgetEstado({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cdastro de Estado')),
      body: Form(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Sigla: ',
                hintText: 'Informe a sigla estado em 2 letras',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

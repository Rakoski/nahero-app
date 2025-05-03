import 'package:flutter/material.dart';

class WidgetCategoria extends StatelessWidget {
  const WidgetCategoria({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Cadastro de produto'),
      onPressed: () => {print('cadastro produto')},
    );
  }
}

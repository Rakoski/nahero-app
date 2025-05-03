import 'package:flutter/material.dart';

class WidgetProduto extends StatelessWidget {
  const WidgetProduto({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Cadastro de produto'),
      onPressed: () => {Navigator.of(context).pop()},
    );
  }
}

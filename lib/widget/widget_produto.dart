import 'package:flutter/material.dart';

class WidgetMenu extends StatelessWidget {
  const WidgetMenu({key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Cadastro de produto'),
      onPressed: () => {Navigator.of(context).pop()},
    );
  }
}

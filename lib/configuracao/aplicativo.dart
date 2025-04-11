import 'package:flutter/material.dart';
import 'package:flutter_app_helio/configuracao/rotas.dart';
import 'package:flutter_app_helio/widget/widget_cidade.dart';
import 'package:flutter_app_helio/widget/widget_estado.dart';
import 'package:flutter_app_helio/widget/widget_menu.dart';

class Aplicativo extends StatelessWidget {
  const Aplicativo({key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aula Widget',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WidgetMenu(),
        Rotas.estado: (context) => const WidgetEstado(),
        Rotas.cidade: (context) => WidgetCidade(),
      },
    );
  }
}

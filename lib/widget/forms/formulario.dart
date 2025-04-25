import 'package:flutter/material.dart';

class Formulario extends StatefulWidget {
  @override
  _Formulario createState() {
    return _Formulario();
  }
}

class _Formulario extends State<Formulario> {
  String _nome = '';
  var _nomeCOntroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulário')),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(label: Text('nome')),
              onSaved: (newValue) => _nome = _nomeCOntroller.text,
              controller: _nomeCOntroller,
              validator: (validatorNome) {
                if (validatorNome == null || validatorNome.isEmpty) {
                  return "Por favor, digite um nome!";
                } else if (validatorNome.length < 2 ||
                    validatorNome.length > 150) {
                  return "Por favor, digite um nome válido!";
                }
                return null;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(label: Text('E-mail')),
              validator: (validatorEmail) {
                if (validatorEmail == null || !validatorEmail.contains('@')) {
                  return "Por favor, digite um nome válido!";
                } else if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(validatorEmail)) {
                  return "Por favor, digite um e-mail válido!";
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  print("deu bom");
                } else {
                  print("deu ruim");
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SimuladoRespostasPage extends StatefulWidget {
  @override
  _EstadoSimuladoRespostas createState() => _EstadoSimuladoRespostas();
}

class _EstadoSimuladoRespostas extends State<SimuladoRespostasPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();

  bool formValido = false;

  void validarFormulario() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        formValido = true;
      });
      const SnackBar(content: Text("válido!"));
    } else {
      setState(() {
        formValido = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nomeController,
            validator: (value) {
              if (value == null) return "não pode cadastrar";
            },
          ),
        ],
      ),
    );
  }
}

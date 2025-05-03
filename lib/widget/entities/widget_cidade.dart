import 'package:flutter/material.dart';
import 'package:flutter_app_helio/widget/entities/widget_cidade_lista.dart';

class WidgetCidade extends StatefulWidget {
  final Map<String, dynamic>? cidadeParaEditar;
  final bool? taEditando;

  WidgetCidade({Key? key, this.cidadeParaEditar, this.taEditando})
    : super(key: key);

  @override
  _WidgetCidadeState createState() => _WidgetCidadeState();
}

class _WidgetCidadeState extends State<WidgetCidade> {
  String? nomeEstado;
  bool? taEditando;

  TextEditingController _nomeCidadeController = TextEditingController();
  TextEditingController _cepController = TextEditingController();
  TextEditingController _urlController = TextEditingController();

  @override
  void dispose() {
    _nomeCidadeController.dispose();
    _cepController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    if (widget.cidadeParaEditar != null) {
      _urlController.text = widget.cidadeParaEditar!["url"] ?? '';
      _cepController.text = widget.cidadeParaEditar!["cep"] ?? '';
      _nomeCidadeController.text = widget.cidadeParaEditar!["nome"];
      taEditando = widget.taEditando;
      setState(() {
        nomeEstado = widget.cidadeParaEditar!['estado'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Cidade')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              isExpanded: false,
              alignment: AlignmentDirectional.centerStart,
              hint: Text('Selecione um estado'),
              value: nomeEstado,
              items: [
                DropdownMenuItem(value: 'PR', child: Text('PR')),
                DropdownMenuItem(value: 'SC', child: Text('SC')),
                DropdownMenuItem(value: 'RS', child: Text('RS')),
                DropdownMenuItem(value: 'SP', child: Text('SP')),
                DropdownMenuItem(value: 'RJ', child: Text('RJ')),
                DropdownMenuItem(value: 'AM', child: Text('AM')),
              ],
              onChanged: (value) {
                setState(() {
                  nomeEstado = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _nomeCidadeController,
              decoration: InputDecoration(
                labelText: 'Nome: ',
                hintText: 'Informe o nome da sua cidade',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'Cep: ',
                hintText: 'Informe o CEP da sua cidade',
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'URL: ',
                hintText: 'Coloque uma URL de foto da sua cidade!',
              ),
            ),
            SizedBox(height: 16.0),
            IconButton(
              onPressed: () {
                if (nomeEstado == null ||
                    _nomeCidadeController.text.isEmpty ||
                    _cepController.text.isEmpty ||
                    _urlController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Preencha todos os campos!')),
                  );
                  return;
                }

                final novaCidade = {
                  'nome': _nomeCidadeController.text,
                  'cep': _cepController.text,
                  'estado': nomeEstado,
                  'url': _urlController.text,
                };

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            taEditando == true
                                ? WidgetCidadeLista()
                                : WidgetCidadeLista(cidade: novaCidade),
                  ),
                );
              },
              icon: const Icon(Icons.save),
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

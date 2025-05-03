import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';

class SimuladoFormPage extends StatefulWidget {
  final Simulado? simulado;
  final Function(Simulado) onSave;

  const SimuladoFormPage({Key? key, this.simulado, required this.onSave})
    : super(key: key);

  @override
  _SimuladoFormPageState createState() => _SimuladoFormPageState();
}

class _SimuladoFormPageState extends State<SimuladoFormPage> {
  final _formKey = GlobalKey<FormState>();
  var _tituloController = TextEditingController();
  var _descricaoController = TextEditingController();
  var _pontuacaoAprovacaoController = TextEditingController();
  var _tempoLimiteController = TextEditingController();
  int _nivelDificuldade = 2;
  bool _estaAtivo = true;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.simulado != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Simulado' : 'Novo Simulado'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'digite um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'digite uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pontuacaoAprovacaoController,
                      decoration: const InputDecoration(
                        labelText: 'Aprovação (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite a pontuação';
                        }
                        final pontuacao = int.tryParse(value);
                        if (pontuacao == null ||
                            pontuacao < 0 ||
                            pontuacao > 100) {
                          return 'Valor entre 0 e 100';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _tempoLimiteController,
                      decoration: const InputDecoration(
                        labelText: 'Tempo (min)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Digite o tempo';
                        }
                        final tempo = int.tryParse(value);
                        if (tempo == null || tempo <= 0) {
                          return 'Tempo maior que 0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Nível:', style: TextStyle(fontSize: 16)),
              Slider(
                value: _nivelDificuldade.toDouble(),
                min: 1,
                max: 4,
                label: _getNivelDificuldadeLabel(_nivelDificuldade),
                onChanged: (value) {
                  setState(() {
                    _nivelDificuldade = value.round();
                  });
                },
              ),
              Center(
                child: Text(
                  _getNivelDificuldadeLabel(_nivelDificuldade),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Simulado Ativo'),
                value: _estaAtivo,
                onChanged: (value) {
                  setState(() {
                    _estaAtivo = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _salvarSimulado();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    isEditing ? 'ATUALIZAR' : 'SALVAR',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getNivelDificuldadeLabel(int nivel) {
    switch (nivel) {
      case 1:
        return 'Fundação';
      case 2:
        return 'Associado';
      case 3:
        return 'Profissional';
      case 4:
        return 'Especialista';
      default:
        return 'Associado';
    }
  }

  void _salvarSimulado() {
    final simulado = Simulado(
      id: widget.simulado?.id,
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      pontuacaoAprovacao: int.parse(_pontuacaoAprovacaoController.text),
      tempoLimite: int.parse(_tempoLimiteController.text),
      nivelDificuldade: _nivelDificuldade,
      estaAtivo: _estaAtivo,
      exame: widget.simulado?.exame,
      professor: widget.simulado?.professor,
      criadoEm: widget.simulado?.criadoEm,
      atualizadoEm: DateTime.now(),
    );

    widget.onSave(simulado);
    Navigator.of(context).pop();
  }
}

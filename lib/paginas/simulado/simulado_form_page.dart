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
  late TextEditingController _tituloController;
  late TextEditingController _descricaoController;
  late TextEditingController _pontuacaoAprovacaoController;
  late TextEditingController _tempoLimiteController;
  late int _nivelDificuldade;
  late bool _estaAtivo;

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.simulado != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Simulado' : 'Novo Simulado'),
      ),
      body: Form(
        key: _formKey,
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
                    return 'colocar tit';
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
                    return 'colocar desc';
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
                        labelText: 'pra aprovar (%)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'pontos:';
                        }
                        final pontuacao = int.tryParse(value);
                        if (pontuacao == null ||
                            pontuacao < 0 ||
                            pontuacao > 100) {
                          return 'tem que ser entre 0 e 100 ne';
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
                        labelText: 'Tempo lim (min)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'colocar tempo lim';
                        }
                        final tempo = int.tryParse(value);
                        if (tempo == null || tempo <= 0) {
                          return 'Tempo m 0';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('dificil:', style: TextStyle(fontSize: 16)),
              Slider(
                value: _nivelDificuldade.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
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
                title: const Text('Simula'),
                value: _estaAtivo,
                onChanged: (value) {
                  setState(() {
                    _estaAtivo = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _salvarSimulado,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    isEditing ? 'ATUALIZAR SIMULADO' : 'SALVAR SIMULADO',
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
    // nivel dos testes de nuvem AWS
    switch (nivel) {
      case 1:
        return 'FUndacao';
      case 2:
        return 'Associado';
      case 3:
        return 'Profissional';
      case 4:
        return 'Especial';
      default:
        return 'Associado';
    }
  }

  void _salvarSimulado() {
    if (_formKey.currentState!.validate()) {
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.simulado != null
                ? 'Simulado atualizado com sucesso!'
                : 'Simulado criado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

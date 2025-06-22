import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_helio/comum/utils/utils.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/prova/entidades/prova.dart';

class SimuladoFormComponent extends StatefulWidget {
  final List<Exame> examesDisponiveis;
  final Function(Simulado) onSimuladoCreated;
  final Simulado? simuladoInicial;

  const SimuladoFormComponent({
    Key? key,
    required this.examesDisponiveis,
    required this.onSimuladoCreated,
    this.simuladoInicial,
  }) : super(key: key);

  @override
  _SimuladoFormComponentState createState() => _SimuladoFormComponentState();
}

class _SimuladoFormComponentState extends State<SimuladoFormComponent> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _pontuacaoAprovacaoController = TextEditingController();
  final _tempoLimiteController = TextEditingController();

  int _nivelDificuldade = 2;
  bool _estaAtivo = true;
  Exame? _exameSelecionado;

  @override
  void initState() {
    super.initState();
    _preencherFormulario();
  }

  void _preencherFormulario() {
    if (widget.simuladoInicial != null) {
      final simulado = widget.simuladoInicial!;
      _tituloController.text = simulado.titulo ?? '';
      _descricaoController.text = simulado.descricao ?? '';
      _pontuacaoAprovacaoController.text =
          simulado.pontuacaoAprovacao?.toString() ?? '';
      _tempoLimiteController.text = simulado.tempoLimite?.toString() ?? '';
      _nivelDificuldade = simulado.nivelDificuldade ?? 2;
      _estaAtivo = simulado.estaAtivo ?? true;
      _exameSelecionado = simulado.exame;
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _pontuacaoAprovacaoController.dispose();
    _tempoLimiteController.dispose();
    super.dispose();
  }

  bool validarFormulario() {
    return _formKey.currentState?.validate() ?? false;
  }

  void salvarSimulado() {
    if (validarFormulario()) {
      final simulado = Simulado(
        id:
            widget.simuladoInicial?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        exame: _exameSelecionado,
        titulo: _tituloController.text,
        descricao: _descricaoController.text,
        pontuacaoAprovacao: int.parse(_pontuacaoAprovacaoController.text),
        tempoLimite: int.parse(_tempoLimiteController.text),
        nivelDificuldade: _nivelDificuldade,
        estaAtivo: _estaAtivo,
        criadoEm: widget.simuladoInicial?.criadoEm ?? DateTime.now(),
        atualizadoEm: DateTime.now(),
      );

      widget.onSimuladoCreated(simulado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Configurações do Simulado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            DropdownButtonFormField<Exame>(
              decoration: const InputDecoration(
                labelText: 'Exame/Prova',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              value: _exameSelecionado,
              items:
                  widget.examesDisponiveis.map((exame) {
                    return DropdownMenuItem<Exame>(
                      value: exame,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [Text(exame.titulo ?? 'Sem título')],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _exameSelecionado = value;
                });
                salvarSimulado();
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione um exame';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título do Simulado',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.title),
              ),
              onChanged: (_) => salvarSimulado(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite um título';
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
                prefixIcon: Icon(Icons.description),
              ),
              maxLines: 3,
              onChanged: (_) => salvarSimulado(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite uma descrição';
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
                      labelText: 'Pontuação para Aprovação (%)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.percent),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => salvarSimulado(),
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
                      labelText: 'Tempo Limite (min)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.timer),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (_) => salvarSimulado(),
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

            const Text('Nível de Dificuldade:', style: TextStyle(fontSize: 16)),
            Slider(
              value: _nivelDificuldade.toDouble(),
              min: 1,
              max: 4,
              divisions: 3,
              label: Utils.getNivelDificuldade(_nivelDificuldade),
              onChanged: (value) {
                setState(() {
                  _nivelDificuldade = value.round();
                });
                salvarSimulado();
              },
            ),
            Center(
              child: Text(
                Utils.getNivelDificuldade(_nivelDificuldade),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            SwitchListTile(
              title: const Text('Simulado Ativo'),
              subtitle: const Text('Define se o simulado estará disponível'),
              value: _estaAtivo,
              onChanged: (value) {
                setState(() {
                  _estaAtivo = value;
                });
                salvarSimulado();
              },
            ),
          ],
        ),
      ),
    );
  }
}

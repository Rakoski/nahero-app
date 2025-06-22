import 'package:flutter/material.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/tipo_questao.dart';

class QuestaoFormDialog extends StatefulWidget {
  final Questao? questao;
  final Simulado simulado;
  final Function(Questao) onSave;

  const QuestaoFormDialog({
    Key? key,
    required this.questao,
    required this.simulado,
    required this.onSave,
  }) : super(key: key);

  @override
  _QuestaoFormDialogState createState() => _QuestaoFormDialogState();
}

class _QuestaoFormDialogState extends State<QuestaoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _conteudoController = TextEditingController();
  final _pontosController = TextEditingController();
  final _explicacaoController = TextEditingController();

  TipoQuestao? _tipoSelecionado;
  bool _isEditing = false;

  final List<TipoQuestao> _tiposQuestao = [
    TipoQuestao(id: "1", nome: 'Múltipla Escolha'),
    TipoQuestao(id: "2", nome: 'Verdadeiro/Falso'),
    TipoQuestao(id: "3", nome: 'Dissertativa'),
  ];

  @override
  void initState() {
    super.initState();
    _isEditing = widget.questao != null;

    if (_isEditing) {
      _conteudoController.text = widget.questao!.conteudo ?? '';
      _pontosController.text = widget.questao!.pontos.toString();
      _explicacaoController.text = widget.questao!.explicacao ?? '';
      _tipoSelecionado = widget.questao!.tipoQuestao;
    } else {
      _pontosController.text = '1';
    }
  }

  @override
  void dispose() {
    _conteudoController.dispose();
    _pontosController.dispose();
    _explicacaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEditing ? 'Editar Questão' : 'Nova Questão',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Conteúdo da Questão *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _conteudoController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          hintText: 'Digite o enunciado da questão...',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'O conteúdo da questão é obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Tipo de Questão *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<TipoQuestao>(
                        value: _tipoSelecionado,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Selecione o tipo de questão',
                        ),
                        items:
                            _tiposQuestao.map((tipo) {
                              return DropdownMenuItem<TipoQuestao>(
                                value: tipo,
                                child: Text(tipo.nome ?? ""),
                              );
                            }).toList(),
                        onChanged: (TipoQuestao? novoTipo) {
                          setState(() {
                            _tipoSelecionado = novoTipo;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um tipo de questão';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Pontos *',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _pontosController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Pontos da questão',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Os pontos são obrigatórios';
                          }
                          final pontos = int.tryParse(value);
                          if (pontos == null || pontos <= 0) {
                            return 'Digite um valor válido maior que zero';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      const Text(
                        'Explicação (Opcional)',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _explicacaoController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Explicação da resposta...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _salvarQuestao,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_isEditing ? 'Atualizar' : 'Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _salvarQuestao() {
    if (_formKey.currentState!.validate()) {
      final questao = Questao(
        id: _isEditing ? widget.questao!.id : null,
        conteudo: _conteudoController.text.trim(),
        tipoQuestao: _tipoSelecionado,
        pontos: int.parse(_pontosController.text),
        explicacao:
            _explicacaoController.text.trim().isEmpty
                ? null
                : _explicacaoController.text.trim(),
        simulado: widget.simulado,
      );

      widget.onSave(questao);
      Navigator.of(context).pop();
    }
  }
}

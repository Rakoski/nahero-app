import 'package:flutter/material.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/app/widget/cruds/alternativa_crud.dart';
import '../forms/questao_form_dialog.dart';

class QuestaoCrudComponent extends StatefulWidget {
  final Simulado? simulado;
  final List<Questao> questoes;
  final Function(List<Questao>) onQuestoesChanged;

  const QuestaoCrudComponent({
    Key? key,
    required this.simulado,
    required this.questoes,
    required this.onQuestoesChanged,
  }) : super(key: key);

  @override
  _QuestaoCrudComponentState createState() => _QuestaoCrudComponentState();
}

class _QuestaoCrudComponentState extends State<QuestaoCrudComponent> {
  List<Questao> _questoesInternas = [];

  @override
  void initState() {
    super.initState();
    _questoesInternas = List.from(widget.questoes);
  }

  @override
  void didUpdateWidget(QuestaoCrudComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.questoes != oldWidget.questoes) {
      _questoesInternas = List.from(widget.questoes);
    }
  }

  void _atualizarQuestoes() {
    widget.onQuestoesChanged(_questoesInternas);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.simulado == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.warning, size: 64, color: Colors.orange),
            SizedBox(height: 16),
            Text(
              'Configure o simulado primeiro',
              style: TextStyle(fontSize: 18, color: Colors.orange),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Questões do Simulado',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nova Questão'),
                onPressed: _adicionarQuestao,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child:
              _questoesInternas.isEmpty
                  ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.quiz, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Nenhuma questão cadastrada',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Clique em "Nova Questão" para começar',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                  : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: _questoesInternas.length,
                    itemBuilder: (context, index) {
                      final questao = _questoesInternas[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            'Questão ${index + 1}: ${_truncateText(questao.conteudo ?? '', 50)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Chip(
                                    label: Text(
                                      questao.tipoQuestao?.nome ?? 'Sem tipo',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: Colors.blue[100],
                                  ),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(
                                      '${questao.pontos} ponto${questao.pontos == 1 ? '' : 's'}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    backgroundColor: Colors.orange[100],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.list_alt,
                                  color: Colors.blue,
                                ),
                                onPressed:
                                    () =>
                                        _gerenciarAlternativas(questao, index),
                                tooltip: 'Gerenciar Alternativas',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                                onPressed: () => _editarQuestao(questao, index),
                                tooltip: 'Editar Questão',
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _excluirQuestao(index),
                                tooltip: 'Excluir Questão',
                              ),
                            ],
                          ),
                          isThreeLine: true,
                          onTap: () => _gerenciarAlternativas(questao, index),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  void _adicionarQuestao() {
    _mostrarDialogQuestao(null, null);
  }

  void _editarQuestao(Questao questao, int index) {
    _mostrarDialogQuestao(questao, index);
  }

  void _mostrarDialogQuestao(Questao? questao, int? index) {
    showDialog(
      context: context,
      builder:
          (context) => QuestaoFormDialog(
            questao: questao,
            simulado: widget.simulado!,
            onSave: (novaQuestao) {
              setState(() {
                if (index != null) {
                  _questoesInternas[index] = novaQuestao;
                } else {
                  _questoesInternas.add(novaQuestao);
                }
              });
              _atualizarQuestoes();
            },
          ),
    );
  }

  void _excluirQuestao(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir esta questão?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _questoesInternas.removeAt(index);
                  });
                  _atualizarQuestoes();
                  Navigator.of(context).pop();
                },
                child: const Text('Excluir'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }

  void _gerenciarAlternativas(Questao questao, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => AlternativaCrudComponent(
              questao: questao,
              onQuestaoUpdate: (questaoAtualizada) {
                setState(() {
                  _questoesInternas[index] = questaoAtualizada;
                });
                _atualizarQuestoes();
              },
            ),
      ),
    );
  }
}

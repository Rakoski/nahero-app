import 'package:flutter/material.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/alternativa.dart';

class AlternativaCrudComponent extends StatefulWidget {
  final Questao questao;
  final Function(Questao) onQuestaoUpdate;

  const AlternativaCrudComponent({
    Key? key,
    required this.questao,
    required this.onQuestaoUpdate,
  }) : super(key: key);

  @override
  _AlternativaCrudComponentState createState() =>
      _AlternativaCrudComponentState();
}

class _AlternativaCrudComponentState extends State<AlternativaCrudComponent> {
  late Questao _questaoAtual;
  List<Alternativa> _alternativasInternas = [];

  @override
  void initState() {
    super.initState();
    _questaoAtual = widget.questao;
  }

  void _atualizarQuestao() {
    final questaoAtualizada = Questao(
      id: _questaoAtual.id,
      conteudo: _questaoAtual.conteudo,
      tipoQuestao: _questaoAtual.tipoQuestao,
      pontos: _questaoAtual.pontos,
      explicacao: _questaoAtual.explicacao,
      simulado: _questaoAtual.simulado,
    );

    setState(() {
      _questaoAtual = questaoAtualizada;
    });

    widget.onQuestaoUpdate(questaoAtualizada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Alternativas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _adicionarAlternativa,
            tooltip: 'Adicionar Alternativa',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Questão:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  _questaoAtual.conteudo ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Chip(
                      label: Text(
                        _questaoAtual.tipoQuestao?.nome ?? 'Sem tipo',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.blue[100],
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(
                        '${_questaoAtual.pontos} ponto${_questaoAtual.pontos == 1 ? '' : 's'}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.orange[100],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child:
                _alternativasInternas.isEmpty
                    ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.list_alt, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma alternativa cadastrada',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Toque no botão + para adicionar alternativas',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _alternativasInternas.length,
                      itemBuilder: (context, index) {
                        final alternativa = _alternativasInternas[index];
                        final letra = String.fromCharCode(65 + index);

                        return Card(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green,
                              child: Text(
                                letra,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              alternativa.conteudo ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  ),
                                  onPressed: () => _marcarComoCorreta(index),
                                  tooltip: 'Marcar como correta',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.orange,
                                  ),
                                  onPressed:
                                      () => _editarAlternativa(
                                        alternativa,
                                        index,
                                      ),
                                  tooltip: 'Editar',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _excluirAlternativa(index),
                                  tooltip: 'Excluir',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  void _adicionarAlternativa() {
    _mostrarDialogAlternativa(null, null);
  }

  void _editarAlternativa(Alternativa alternativa, int index) {
    _mostrarDialogAlternativa(alternativa, index);
  }

  void _mostrarDialogAlternativa(Alternativa? alternativa, int? index) {
    final controller = TextEditingController(text: alternativa?.conteudo ?? '');

    showDialog(
      context: context,
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setDialogState) => AlertDialog(
                  title: Text(
                    index != null ? 'Editar Alternativa' : 'Nova Alternativa',
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Conteúdo da Alternativa',
                          border: OutlineInputBorder(),
                          hintText: 'Digite o texto da alternativa...',
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (controller.text.trim().isNotEmpty) {
                          final novaAlternativa = Alternativa(
                            id: alternativa?.id,
                            conteudo: controller.text.trim(),
                            questao: _questaoAtual,
                          );

                          setState(() {
                            if (index != null) {
                              _alternativasInternas[index] = novaAlternativa;
                            } else {
                              _alternativasInternas.add(novaAlternativa);
                            }
                          });

                          _atualizarQuestao();
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(index != null ? 'Atualizar' : 'Adicionar'),
                    ),
                  ],
                ),
          ),
    );
  }

  void _marcarComoCorreta(int index) {
    setState(() {
      for (int i = 0; i < _alternativasInternas.length; i++) {
        _alternativasInternas[i] = Alternativa(
          id: _alternativasInternas[i].id,
          conteudo: _alternativasInternas[i].conteudo,
          questao: _questaoAtual,
        );
      }
    });
    _atualizarQuestao();
  }

  void _excluirAlternativa(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Deseja realmente excluir esta alternativa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _alternativasInternas.removeAt(index);
                  });
                  _atualizarQuestao();
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }
}

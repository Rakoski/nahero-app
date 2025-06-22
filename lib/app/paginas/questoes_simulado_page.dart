import 'package:flutter/material.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/alternativa.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/tipo_questao.dart';
import 'package:flutter_app_helio/app/widget/forms/questao_form_component.dart';

class QuestoesSimuladoPage extends StatefulWidget {
  final Simulado simulado;

  const QuestoesSimuladoPage({Key? key, required this.simulado})
    : super(key: key);

  @override
  _QuestoesSimuladoPageState createState() => _QuestoesSimuladoPageState();
}

class _QuestoesSimuladoPageState extends State<QuestoesSimuladoPage> {
  late List<Questao> questoes;
  bool _mostrarInativas = false;

  @override
  void initState() {
    super.initState();

    questoes = [
      Questao(
        id: '1',
        simulado: widget.simulado,
        tipoQuestao: TipoQuestao(nome: 'Múltipla Escolha'),
        conteudo: 'Qual é a capital do Brasil?',
        pontos: 2,
        estaAtiva: true,
      ),
      Questao(
        id: '2',
        simulado: widget.simulado,
        tipoQuestao: TipoQuestao(nome: 'Múltipla Escolha'),
        conteudo: 'Qual é o resultado da expressão 2 + 2 * 3?',
        pontos: 1,
        estaAtiva: true,
      ),
      Questao(
        id: '3',
        simulado: widget.simulado,
        tipoQuestao: TipoQuestao(nome: 'Verdadeiro ou Falso'),
        conteudo: 'O Brasil é o maior país da América do Sul.',
        pontos: 1,
        estaAtiva: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final questoesFiltradas =
        _mostrarInativas
            ? questoes
            : questoes.where((q) => q.estaAtiva == true).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Número de questões - ${widget.simulado.titulo}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _mostrarInativas = !_mostrarInativas;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _mostrarInativas
                        ? 'Mostrando todas as questões'
                        : 'Mostrando apenas questões ativas',
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            tooltip: 'Filtrar questões inativas',
          ),
        ],
      ),
      body:
          questoesFiltradas.isEmpty
              ? const Center(
                child: Text(
                  'Nenhuma questão cadastrada',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: questoesFiltradas.length,
                itemBuilder: (context, index) {
                  final questao = questoesFiltradas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ExpansionTile(
                      title: Text(
                        'Questão ${index + 1}: ${questao.conteudo?.substring(0, questao.conteudo!.length > 50 ? 50 : questao.conteudo!.length)}${questao.conteudo!.length > 50 ? '...' : ''}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              questao.estaAtiva == true
                                  ? Colors.black
                                  : Colors.grey,
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Chip(
                            label: Text(
                              questao.tipoQuestao?.nome ?? 'ué',
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
                            backgroundColor: Colors.green[100],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              _navegarParaFormularioQuestao(questao, index);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                questoes.removeAt(index);
                              });
                            },
                          ),
                        ],
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                questao.conteudo ?? 'Sem nd',
                                style: const TextStyle(fontSize: 16),
                              ),
                              if (questao.explicacao != null &&
                                  questao.explicacao!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                const Divider(),
                                const SizedBox(height: 8),
                                const Text(
                                  'Explicação:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(questao.explicacao!),
                              ],
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Alternativas:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.add),
                                    label: const Text('Adicionar Alternativa'),
                                    onPressed: () {
                                      _adicionarAlternativa(questao);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              _buildAlternativasList(questao),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navegarParaFormularioQuestao(null, null);
        },
        child: const Icon(Icons.add),
        tooltip: 'Adicionar nova questão',
      ),
    );
  }

  Widget _buildAlternativasList(Questao questao) {
    List<Alternativa> alternativas = [
      if (questao.id == '1') ...[
        Alternativa(
          id: '1',
          questao: questao,
          conteudo: 'Paranavai',
          estaCorreta: false,
        ),
        Alternativa(
          id: '2',
          questao: questao,
          conteudo: 'Cianorte',
          estaCorreta: false,
        ),
        Alternativa(
          id: '3',
          questao: questao,
          conteudo: 'umuarama',
          estaCorreta: true,
        ),
        Alternativa(
          id: '4',
          questao: questao,
          conteudo: 'Maringa',
          estaCorreta: false,
        ),
      ] else if (questao.id == '2') ...[
        Alternativa(
          id: '5',
          questao: questao,
          conteudo: '4',
          estaCorreta: false,
        ),
        Alternativa(
          id: '6',
          questao: questao,
          conteudo: '6',
          estaCorreta: false,
        ),
        Alternativa(
          id: '7',
          questao: questao,
          conteudo: '8',
          estaCorreta: true,
        ),
        Alternativa(
          id: '8',
          questao: questao,
          conteudo: '12',
          estaCorreta: false,
        ),
      ] else if (questao.id == '3') ...[
        Alternativa(
          id: '9',
          questao: questao,
          conteudo: 'Verdadeiro',
          estaCorreta: true,
        ),
        Alternativa(
          id: '10',
          questao: questao,
          conteudo: 'Falso',
          estaCorreta: false,
        ),
      ],
    ];

    if (alternativas.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Nao achei.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: alternativas.length,
      itemBuilder: (context, index) {
        final alternativa = alternativas[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                alternativa.estaCorreta == true ? Colors.green : Colors.grey,
            child: Text(
              String.fromCharCode(65 + index),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          title: Text(alternativa.conteudo ?? 'Sem nd'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () {
                  _editarAlternativa(alternativa);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  print("ecluir");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _navegarParaFormularioQuestao(Questao? questao, int? index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => QuestaoFormComponent(
              simulado: widget.simulado,
              questao: questao,
              onSave: (questaoAtualizada) {
                setState(() {
                  if (index != null) {
                    questoes[index] = questaoAtualizada;
                  } else {
                    questoes.add(questaoAtualizada);
                  }
                });
              },
            ),
      ),
    );
  }

  void _adicionarAlternativa(Questao questao) {
    _editarAlternativa(Alternativa(questao: questao));
  }

  void _editarAlternativa(Alternativa alternativa) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              alternativa.id == null
                  ? 'Adicionar Alternativa'
                  : 'Editar Alternativa',
            ),
            content: _AlternativaFormDialog(
              alternativa: alternativa,
              onSave: (alternativaAtualizada) {
                setState(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        alternativa.id == null
                            ? 'Alternativa add!'
                            : 'Alternativa dd!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                });
              },
            ),
          ),
    );
  }
}

class _AlternativaFormDialog extends StatefulWidget {
  final Alternativa alternativa;
  final Function(Alternativa) onSave;

  const _AlternativaFormDialog({
    Key? key,
    required this.alternativa,
    required this.onSave,
  }) : super(key: key);

  @override
  __AlternativaFormDialogState createState() => __AlternativaFormDialogState();
}

class __AlternativaFormDialogState extends State<_AlternativaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _conteudoController;
  late bool _estaCorreta;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _conteudoController,
              decoration: const InputDecoration(
                labelText: 'Texto da alternativa',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'coloque algo pfv';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCELAR'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final alternativaAtualizada = Alternativa(
                        id: widget.alternativa.id,
                        questao: widget.alternativa.questao,
                        conteudo: _conteudoController.text,
                        estaCorreta: _estaCorreta,
                        estaAtiva: true,
                        versao: widget.alternativa.versao,
                        professor: widget.alternativa.professor,
                        criadoEm: widget.alternativa.criadoEm,
                        atualizadoEm: DateTime.now(),
                      );

                      widget.onSave(alternativaAtualizada);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('SALVAR'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

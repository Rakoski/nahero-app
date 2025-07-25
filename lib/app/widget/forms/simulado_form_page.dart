import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_helio/comum/utils/utils.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/alternativa.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/tipo_questao.dart';

class SimuladoFormPage extends StatefulWidget {
  final Simulado? simulado;
  final Function(Simulado, List<Questao>) onSave;

  const SimuladoFormPage({Key? key, this.simulado, required this.onSave})
    : super(key: key);

  @override
  _SimuladoFormPageState createState() => _SimuladoFormPageState();
}

class _SimuladoFormPageState extends State<SimuladoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _pontuacaoAprovacaoController = TextEditingController();
  final _tempoLimiteController = TextEditingController();
  int _nivelDificuldade = 2;
  bool _estaAtivo = true;

  List<QuestaoData> _questoes = [];

  final List<TipoQuestao> _tipos = [
    TipoQuestao(id: '1', nome: 'objetiva'),
    TipoQuestao(id: '2', nome: 'vdd ou falso'),
    TipoQuestao(id: '3', nome: 'de escrever'),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.simulado != null) {
      _loadSimuladoData();
    }
  }

  void _loadSimuladoData() {
    final simulado = widget.simulado!;
    _tituloController.text = simulado.titulo ?? '';
    _descricaoController.text = simulado.descricao ?? '';
    _pontuacaoAprovacaoController.text =
        simulado.pontuacaoAprovacao?.toString() ?? '';
    _tempoLimiteController.text = simulado.tempoLimite?.toString() ?? '';
    _nivelDificuldade = simulado.nivelDificuldade ?? 2;
    _estaAtivo = simulado.estaAtivo ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.simulado != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Simulado' : 'Novo Simulado'),
        actions: [
          if (_currentPage == 1)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _adicionarQuestao,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _goToPage(0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              _currentPage == 0
                                  ? Colors.blue
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Simulado',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                _currentPage == 0 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _goToPage(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              _currentPage == 1
                                  ? Colors.blue
                                  : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Questões (${_questoes.length})',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                _currentPage == 1 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                children: [_buildSimuladoForm(), _buildQuestoesForm()],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  if (_currentPage == 1)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _goToPage(0),
                        child: const Text('VOLTAR'),
                      ),
                    ),
                  if (_currentPage == 1) const SizedBox(width: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSimuladoForm() {
    return Form(
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
              divisions: 3,
              label: Utils.getNivelDificuldade(_nivelDificuldade),
              onChanged: (value) {
                setState(() {
                  _nivelDificuldade = value.round();
                });
              },
            ),
            Center(
              child: Text(
                Utils.getNivelDificuldade(_nivelDificuldade),
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
          ],
        ),
      ),
    );
  }

  Widget _buildQuestoesForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_questoes.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(Icons.quiz, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhuma questão adicionada',
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Toque no botão + para adicionar questões',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            )
          else
            ...List.generate(_questoes.length, (index) {
              return QuestaoCard(
                questaoData: _questoes[index],
                index: index,
                tipos: _tipos,
                onUpdate: (questaoData) {
                  setState(() {
                    _questoes[index] = questaoData;
                  });
                },
                onDelete: () {
                  setState(() {
                    _questoes.removeAt(index);
                  });
                },
              );
            }),
        ],
      ),
    );
  }

  void _goToPage(int page) {
    if (page == 1 && !_formKey.currentState!.validate()) {
      return;
    }
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _adicionarQuestao() {
    setState(() {
      _questoes.add(QuestaoData());
    });
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

    final questoes =
        _questoes.map((questaoData) {
          return Questao(
            id: questaoData.questao?.id,
            simulado: simulado,
            tipoQuestao: questaoData.tipoQuestao,
            conteudo: questaoData.conteudo,
            explicacao:
                questaoData.explicacao?.isEmpty == true
                    ? null
                    : questaoData.explicacao,
            urlImagem:
                questaoData.urlImagem?.isEmpty == true
                    ? null
                    : questaoData.urlImagem,
            pontos: questaoData.pontos,
            estaAtiva: questaoData.estaAtiva,
            versao: questaoData.questao?.versao ?? 1,
            professor: questaoData.questao?.professor,
            criadoEm: questaoData.questao?.criadoEm,
            atualizadoEm: DateTime.now(),
          );
        }).toList();

    widget.onSave(simulado, questoes);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _pontuacaoAprovacaoController.dispose();
    _tempoLimiteController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}

class QuestaoData {
  Questao? questao;
  TipoQuestao? tipoQuestao;
  String? conteudo;
  String? explicacao;
  String? urlImagem;
  int pontos;
  bool estaAtiva;
  List<AlternativaData> alternativas;

  QuestaoData({
    this.questao,
    this.tipoQuestao,
    this.conteudo,
    this.explicacao,
    this.urlImagem,
    this.pontos = 1,
    this.estaAtiva = true,
    List<AlternativaData>? alternativas,
  }) : alternativas = alternativas ?? [];
}

class AlternativaData {
  Alternativa? alternativa;
  String? conteudo;
  String? urlImagem;
  bool estaCorreta;
  bool estaAtiva;

  AlternativaData({
    this.alternativa,
    this.conteudo,
    this.urlImagem,
    this.estaCorreta = false,
    this.estaAtiva = true,
  });
}

class QuestaoCard extends StatefulWidget {
  final QuestaoData questaoData;
  final int index;
  final List<TipoQuestao> tipos;
  final Function(QuestaoData) onUpdate;
  final VoidCallback onDelete;

  const QuestaoCard({
    Key? key,
    required this.questaoData,
    required this.index,
    required this.tipos,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _QuestaoCardState createState() => _QuestaoCardState();
}

class _QuestaoCardState extends State<QuestaoCard> {
  final _conteudoController = TextEditingController();
  final _explicacaoController = TextEditingController();
  final _urlImagemController = TextEditingController();
  final _pontosController = TextEditingController();
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _conteudoController.text = widget.questaoData.conteudo ?? '';
    _explicacaoController.text = widget.questaoData.explicacao ?? '';
    _urlImagemController.text = widget.questaoData.urlImagem ?? '';
    _pontosController.text = widget.questaoData.pontos.toString();

    _conteudoController.addListener(_updateQuestao);
    _explicacaoController.addListener(_updateQuestao);
    _urlImagemController.addListener(_updateQuestao);
    _pontosController.addListener(_updateQuestao);
  }

  void _updateQuestao() {
    widget.questaoData.conteudo = _conteudoController.text;
    widget.questaoData.explicacao = _explicacaoController.text;
    widget.questaoData.urlImagem = _urlImagemController.text;
    widget.questaoData.pontos = int.tryParse(_pontosController.text) ?? 1;
    widget.onUpdate(widget.questaoData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          ListTile(
            title: Text('Questão ${widget.index + 1}'),
            subtitle:
                widget.questaoData.conteudo?.isNotEmpty == true
                    ? Text(
                      widget.questaoData.conteudo!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                    : const Text('Questão sem enunciado'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  DropdownButtonFormField<TipoQuestao>(
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Questão',
                      border: OutlineInputBorder(),
                    ),
                    value: widget.questaoData.tipoQuestao,
                    items:
                        widget.tipos.map((tipo) {
                          return DropdownMenuItem<TipoQuestao>(
                            value: tipo,
                            child: Text(tipo.nome ?? 'Sem nome'),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        widget.questaoData.tipoQuestao = value;
                        widget.onUpdate(widget.questaoData);
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _conteudoController,
                    decoration: const InputDecoration(
                      labelText: 'Enunciado',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _urlImagemController,
                    decoration: const InputDecoration(
                      labelText: 'URL da Imagem',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _explicacaoController,
                    decoration: const InputDecoration(
                      labelText: 'Explicação',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _pontosController,
                          decoration: const InputDecoration(
                            labelText: 'Pontos',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: SwitchListTile(
                          title: const Text('Ativa'),
                          value: widget.questaoData.estaAtiva,
                          onChanged: (value) {
                            setState(() {
                              widget.questaoData.estaAtiva = value;
                              widget.onUpdate(widget.questaoData);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (widget.questaoData.tipoQuestao?.nome == 'objetiva' ||
                      widget.questaoData.tipoQuestao?.nome == 'vdd ou falso')
                    _buildAlternativasSection(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlternativasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Alternativas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: _adicionarAlternativa,
              icon: const Icon(Icons.add),
              label: const Text('Adicionar'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (widget.questaoData.alternativas.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Nenhuma alternativa adicionada',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ...List.generate(widget.questaoData.alternativas.length, (index) {
            return AlternativaItem(
              alternativaData: widget.questaoData.alternativas[index],
              index: index,
              isVerdadeiroFalso:
                  widget.questaoData.tipoQuestao?.nome == 'vdd ou falso',
              onUpdate: (alternativaData) {
                setState(() {
                  widget.questaoData.alternativas[index] = alternativaData;
                  widget.onUpdate(widget.questaoData);
                });
              },
              onDelete: () {
                setState(() {
                  widget.questaoData.alternativas.removeAt(index);
                  widget.onUpdate(widget.questaoData);
                });
              },
              onCorrectChanged: (isCorrect) {
                if (isCorrect &&
                    widget.questaoData.tipoQuestao?.nome == 'objetiva') {
                  for (
                    int i = 0;
                    i < widget.questaoData.alternativas.length;
                    i++
                  ) {
                    widget.questaoData.alternativas[i].estaCorreta = i == index;
                  }
                } else {
                  widget.questaoData.alternativas[index].estaCorreta =
                      isCorrect;
                }
                setState(() {
                  widget.onUpdate(widget.questaoData);
                });
              },
            );
          }),
      ],
    );
  }

  void _adicionarAlternativa() {
    setState(() {
      if (widget.questaoData.tipoQuestao?.nome == 'vdd ou falso') {
        if (widget.questaoData.alternativas.isEmpty) {
          widget.questaoData.alternativas.add(
            AlternativaData(conteudo: 'Verdadeiro'),
          );
          widget.questaoData.alternativas.add(
            AlternativaData(conteudo: 'Falso'),
          );
        }
      } else {
        widget.questaoData.alternativas.add(AlternativaData());
      }
      widget.onUpdate(widget.questaoData);
    });
  }

  @override
  void dispose() {
    _conteudoController.dispose();
    _explicacaoController.dispose();
    _urlImagemController.dispose();
    _pontosController.dispose();
    super.dispose();
  }
}

class AlternativaItem extends StatefulWidget {
  final AlternativaData alternativaData;
  final int index;
  final bool isVerdadeiroFalso;
  final Function(AlternativaData) onUpdate;
  final VoidCallback onDelete;
  final Function(bool) onCorrectChanged;

  const AlternativaItem({
    Key? key,
    required this.alternativaData,
    required this.index,
    required this.isVerdadeiroFalso,
    required this.onUpdate,
    required this.onDelete,
    required this.onCorrectChanged,
  }) : super(key: key);

  @override
  _AlternativaItemState createState() => _AlternativaItemState();
}

class _AlternativaItemState extends State<AlternativaItem> {
  final _conteudoController = TextEditingController();
  final _urlImagemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _conteudoController.text = widget.alternativaData.conteudo ?? '';
    _urlImagemController.text = widget.alternativaData.urlImagem ?? '';

    _conteudoController.addListener(_updateAlternativa);
    _urlImagemController.addListener(_updateAlternativa);
  }

  void _updateAlternativa() {
    widget.alternativaData.conteudo = _conteudoController.text;
    widget.alternativaData.urlImagem = _urlImagemController.text;
    widget.onUpdate(widget.alternativaData);
  }

  @override
  Widget build(BuildContext context) {
    String label =
        widget.isVerdadeiroFalso
            ? (widget.index == 0 ? 'Verdadeiro' : 'Falso')
            : 'Alternativa ${String.fromCharCode(65 + widget.index)}';

    return Card(
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio<bool>(
                  value: true,
                  groupValue: widget.alternativaData.estaCorreta,
                  onChanged: (value) {
                    widget.onCorrectChanged(value ?? false);
                  },
                ),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (!widget.isVerdadeiroFalso)
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: widget.onDelete,
                  ),
              ],
            ),
            if (!widget.isVerdadeiroFalso) ...[
              TextFormField(
                controller: _conteudoController,
                decoration: const InputDecoration(
                  labelText: 'Conteúdo',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _urlImagemController,
                decoration: const InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _conteudoController.dispose();
    _urlImagemController.dispose();
    super.dispose();
  }
}

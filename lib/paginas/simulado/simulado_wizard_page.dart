import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/alternativa.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/tipo_questao.dart';
import 'package:flutter_app_helio/modelo/prova/entidades/prova.dart';

class SimuladoWizardPage extends StatefulWidget {
  final Function(Simulado)? onSave;

  const SimuladoWizardPage({Key? key, this.onSave}) : super(key: key);

  @override
  _SimuladoWizardPageState createState() => _SimuladoWizardPageState();
}

class _SimuladoWizardPageState extends State<SimuladoWizardPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Dados do simulado
  Simulado? _simulado;
  List<Questao> _questoes = [];

  // Controllers da Etapa 1 - Simulado
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _pontuacaoAprovacaoController = TextEditingController();
  final _tempoLimiteController = TextEditingController();
  int _nivelDificuldade = 2;
  bool _estaAtivo = true;
  Exame? _exameSelecionado;

  // Form keys
  final _formKeyEtapa1 = GlobalKey<FormState>();

  final List<Exame> _examesDisponiveis = [
    Exame(
      id: '1',
      titulo: 'AWS Cloud Practitioner',
      categoria: 'Cloud Computing',
    ),
    Exame(id: '2', titulo: 'Azure Fundamentals', categoria: 'Cloud Computing'),
    Exame(
      id: '3',
      titulo: 'Google Cloud Associate',
      categoria: 'Cloud Computing',
    ),
    Exame(id: '4', titulo: 'CompTIA Security+', categoria: 'Segurança'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _tituloController.dispose();
    _descricaoController.dispose();
    _pontuacaoAprovacaoController.dispose();
    _tempoLimiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Simulado - Etapa ${_currentStep + 1}'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Indicador de progresso
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Simulado'),
                Expanded(child: _buildStepConnector(0)),
                _buildStepIndicator(1, 'Questões'),
              ],
            ),
          ),

          // Conteúdo das etapas
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildEtapa1(), _buildEtapa2()],
            ),
          ),

          // Botões de navegação
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  ElevatedButton(
                    onPressed: _voltarEtapa,
                    child: const Text('Voltar'),
                  )
                else
                  const SizedBox(),

                ElevatedButton(
                  onPressed: _proximaEtapa,
                  child: Text(_currentStep == 1 ? 'Finalizar' : 'Próximo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    bool isActive = step <= _currentStep;
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isActive ? Colors.blue : Colors.grey,
          child: Text(
            '${step + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.blue : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector(int step) {
    bool isActive = step < _currentStep;
    return Container(
      height: 2,
      margin: const EdgeInsets.only(bottom: 25),
      color: isActive ? Colors.blue : Colors.grey,
    );
  }

  Widget _buildEtapa1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKeyEtapa1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Configurações do Simulado',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Dropdown para Exame
            DropdownButtonFormField<Exame>(
              decoration: const InputDecoration(
                labelText: 'Exame/Prova',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              value: _exameSelecionado,
              items:
                  _examesDisponiveis.map((exame) {
                    return DropdownMenuItem<Exame>(
                      value: exame,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(exame.titulo ?? 'Sem título'),
                          Text(
                            exame.categoria ?? 'Sem categoria',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _exameSelecionado = value;
                });
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
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEtapa2() {
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
              _questoes.isEmpty
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
                    itemCount: _questoes.length,
                    itemBuilder: (context, index) {
                      final questao = _questoes[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            'Questão ${index + 1}: ${questao.conteudo?.substring(0, questao.conteudo!.length > 50 ? 50 : questao.conteudo!.length)}${questao.conteudo!.length > 50 ? '...' : ''}',
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

  void _voltarEtapa() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _proximaEtapa() {
    if (_currentStep == 0) {
      if (_formKeyEtapa1.currentState!.validate()) {
        _criarSimulado();
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else if (_currentStep == 1) {
      _finalizarCadastro();
    }
  }

  void _criarSimulado() {
    _simulado = Simulado(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      exame: _exameSelecionado,
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      pontuacaoAprovacao: int.parse(_pontuacaoAprovacaoController.text),
      tempoLimite: int.parse(_tempoLimiteController.text),
      nivelDificuldade: _nivelDificuldade,
      estaAtivo: _estaAtivo,
      criadoEm: DateTime.now(),
      atualizadoEm: DateTime.now(),
    );
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
          (context) => _QuestaoFormDialog(
            questao: questao,
            simulado: _simulado!,
            onSave: (novaQuestao) {
              setState(() {
                if (index != null) {
                  _questoes[index] = novaQuestao;
                } else {
                  _questoes.add(novaQuestao);
                }
              });
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
                    _questoes.removeAt(index);
                  });
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
            (context) => _AlternativasPage(
              questao: questao,
              onQuestaoUpdate: (questaoAtualizada) {
                setState(() {
                  _questoes[index] = questaoAtualizada;
                });
              },
            ),
      ),
    );
  }

  void _finalizarCadastro() {
    if (_questoes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos uma questão ao simulado'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Simular salvamento no banco
    if (widget.onSave != null) {
      widget.onSave!(_simulado!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulado criado com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }
}

// Dialog para cadastro/edição de questões
class _QuestaoFormDialog extends StatefulWidget {
  final Questao? questao;
  final Simulado simulado;
  final Function(Questao) onSave;

  const _QuestaoFormDialog({
    Key? key,
    this.questao,
    required this.simulado,
    required this.onSave,
  }) : super(key: key);

  @override
  __QuestaoFormDialogState createState() => __QuestaoFormDialogState();
}

class __QuestaoFormDialogState extends State<_QuestaoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _conteudoController;
  late TextEditingController _explicacaoController;
  late TextEditingController _pontosController;
  late TipoQuestao? _tipoQuestaoSelecionado;
  late bool _estaAtiva;

  final List<TipoQuestao> tipos = [
    TipoQuestao(id: '1', nome: 'Múltipla Escolha'),
    TipoQuestao(id: '2', nome: 'Verdadeiro ou Falso'),
    TipoQuestao(id: '3', nome: 'Dissertativa'),
  ];

  @override
  void initState() {
    super.initState();
    _conteudoController = TextEditingController(
      text: widget.questao?.conteudo ?? '',
    );
    _explicacaoController = TextEditingController(
      text: widget.questao?.explicacao ?? '',
    );
    _pontosController = TextEditingController(
      text: widget.questao?.pontos?.toString() ?? '1',
    );
    _tipoQuestaoSelecionado = widget.questao?.tipoQuestao ?? tipos.first;
    _estaAtiva = widget.questao?.estaAtiva ?? true;
  }

  @override
  void dispose() {
    _conteudoController.dispose();
    _explicacaoController.dispose();
    _pontosController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.questao != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Questão' : 'Nova Questão'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<TipoQuestao>(
                  decoration: const InputDecoration(
                    labelText: 'Tipo de Questão',
                    border: OutlineInputBorder(),
                  ),
                  value: _tipoQuestaoSelecionado,
                  items:
                      tipos.map((tipo) {
                        return DropdownMenuItem<TipoQuestao>(
                          value: tipo,
                          child: Text(tipo.nome ?? 'Sem nome'),
                        );
                      }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _tipoQuestaoSelecionado = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione um tipo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _conteudoController,
                  decoration: const InputDecoration(
                    labelText: 'Enunciado da Questão',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite o enunciado';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _explicacaoController,
                  decoration: const InputDecoration(
                    labelText: 'Explicação (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _pontosController,
                  decoration: const InputDecoration(
                    labelText: 'Pontos',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite a pontuação';
                    }
                    final pontos = int.tryParse(value);
                    if (pontos == null || pontos <= 0) {
                      return 'Deve ser maior que 0';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                SwitchListTile(
                  title: const Text('Questão Ativa'),
                  value: _estaAtiva,
                  onChanged: (value) {
                    setState(() {
                      _estaAtiva = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final questao = Questao(
                id:
                    widget.questao?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                simulado: widget.simulado,
                tipoQuestao: _tipoQuestaoSelecionado,
                conteudo: _conteudoController.text,
                explicacao:
                    _explicacaoController.text.isEmpty
                        ? null
                        : _explicacaoController.text,
                pontos: int.parse(_pontosController.text),
                estaAtiva: _estaAtiva,
                versao: widget.questao?.versao ?? 1,
                criadoEm: widget.questao?.criadoEm ?? DateTime.now(),
                atualizadoEm: DateTime.now(),
              );

              widget.onSave(questao);
              Navigator.of(context).pop();
            }
          },
          child: Text(isEditing ? 'Atualizar' : 'Salvar'),
        ),
      ],
    );
  }
}

// Página para gerenciar alternativas de uma questão
class _AlternativasPage extends StatefulWidget {
  final Questao questao;
  final Function(Questao) onQuestaoUpdate;

  const _AlternativasPage({
    Key? key,
    required this.questao,
    required this.onQuestaoUpdate,
  }) : super(key: key);

  @override
  __AlternativasPageState createState() => __AlternativasPageState();
}

class __AlternativasPageState extends State<_AlternativasPage> {
  List<Alternativa> _alternativas = [];

  @override
  void initState() {
    super.initState();
    // Simular carregamento de alternativas existentes
    _alternativas = [];
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
          // Mostrar a questão
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Questão:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.questao.conteudo ?? 'Sem conteúdo'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          widget.questao.tipoQuestao?.nome ?? 'Sem tipo',
                        ),
                        backgroundColor: Colors.blue[100],
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('${widget.questao.pontos} pontos'),
                        backgroundColor: Colors.orange[100],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Lista de alternativas
          Expanded(
            child:
                _alternativas.isEmpty
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
                            'Clique no + para adicionar alternativas',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _alternativas.length,
                      itemBuilder: (context, index) {
                        final alternativa = _alternativas[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  alternativa.estaCorreta == true
                                      ? Colors.green
                                      : Colors.grey,
                              child: Text(
                                String.fromCharCode(
                                  65 + index,
                                ), // A, B, C, D...
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(alternativa.conteudo ?? 'Sem conteúdo'),
                            subtitle: Text(
                              alternativa.estaCorreta == true
                                  ? 'Alternativa Correta'
                                  : 'Alternativa Incorreta',
                              style: TextStyle(
                                color:
                                    alternativa.estaCorreta == true
                                        ? Colors.green
                                        : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                  tooltip: 'Editar Alternativa',
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _excluirAlternativa(index),
                                  tooltip: 'Excluir Alternativa',
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
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarAlternativa,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
        tooltip: 'Adicionar Alternativa',
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
    showDialog(
      context: context,
      builder:
          (context) => _AlternativaFormDialog(
            alternativa: alternativa,
            questao: widget.questao,
            onSave: (novaAlternativa) {
              setState(() {
                if (index != null) {
                  _alternativas[index] = novaAlternativa;
                } else {
                  _alternativas.add(novaAlternativa);
                }
              });
            },
          ),
    );
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
                    _alternativas.removeAt(index);
                  });
                  Navigator.of(context).pop();
                },
                child: const Text('Excluir'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }
}

// Dialog para cadastro/edição de alternativas
class _AlternativaFormDialog extends StatefulWidget {
  final Alternativa? alternativa;
  final Questao questao;
  final Function(Alternativa) onSave;

  const _AlternativaFormDialog({
    Key? key,
    this.alternativa,
    required this.questao,
    required this.onSave,
  }) : super(key: key);

  @override
  __AlternativaFormDialogState createState() => __AlternativaFormDialogState();
}

class __AlternativaFormDialogState extends State<_AlternativaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _conteudoController;
  late TextEditingController _urlImagemController;
  late bool _estaCorreta;
  late bool _estaAtiva;

  @override
  void initState() {
    super.initState();
    _conteudoController = TextEditingController(
      text: widget.alternativa?.conteudo ?? '',
    );
    _urlImagemController = TextEditingController(
      text: widget.alternativa?.urlImagem ?? '',
    );
    _estaCorreta = widget.alternativa?.estaCorreta ?? false;
    _estaAtiva = widget.alternativa?.estaAtiva ?? true;
  }

  @override
  void dispose() {
    _conteudoController.dispose();
    _urlImagemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.alternativa != null;

    return AlertDialog(
      title: Text(isEditing ? 'Editar Alternativa' : 'Nova Alternativa'),
      content: SizedBox(
        width: double.maxFinite,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _conteudoController,
                  decoration: const InputDecoration(
                    labelText: 'Texto da Alternativa',
                    border: OutlineInputBorder(),
                    hintText: 'Digite o conteúdo da alternativa',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Digite o conteúdo da alternativa';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _urlImagemController,
                  decoration: const InputDecoration(
                    labelText: 'URL da Imagem (opcional)',
                    border: OutlineInputBorder(),
                    hintText: 'https://exemplo.com/imagem.jpg',
                  ),
                ),
                const SizedBox(height: 16),

                SwitchListTile(
                  title: const Text('Esta é a alternativa correta?'),
                  subtitle: const Text(
                    'Marque se esta alternativa é a resposta certa',
                  ),
                  value: _estaCorreta,
                  onChanged: (value) {
                    setState(() {
                      _estaCorreta = value;
                    });
                  },
                  activeColor: Colors.green,
                ),

                SwitchListTile(
                  title: const Text('Alternativa Ativa'),
                  subtitle: const Text('Define se a alternativa será exibida'),
                  value: _estaAtiva,
                  onChanged: (value) {
                    setState(() {
                      _estaAtiva = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final alternativa = Alternativa(
                id:
                    widget.alternativa?.id ??
                    DateTime.now().millisecondsSinceEpoch.toString(),
                questao: widget.questao,
                conteudo: _conteudoController.text,
                urlImagem:
                    _urlImagemController.text.isEmpty
                        ? null
                        : _urlImagemController.text,
                estaCorreta: _estaCorreta,
                estaAtiva: _estaAtiva,
                versao: widget.alternativa?.versao ?? 1,
                criadoEm: widget.alternativa?.criadoEm ?? DateTime.now(),
                atualizadoEm: DateTime.now(),
              );

              widget.onSave(alternativa);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          child: Text(isEditing ? 'Atualizar' : 'Salvar'),
        ),
      ],
    );
  }
}

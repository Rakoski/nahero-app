import 'package:flutter/material.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/entidades/prova/entidades/prova.dart';
import 'package:flutter_app_helio/app/widget/crud/questao_crud_component.dart';
import '../widget/forms/simulado_form_component.dart';

class SimuladoWizardPage extends StatefulWidget {
  final Function(Simulado)? onSave;
  final Simulado? simulado; // Add this parameter for editing

  const SimuladoWizardPage({
    Key? key,
    this.onSave,
    this.simulado, // Add simulado parameter
  }) : super(key: key);

  @override
  _SimuladoWizardPageState createState() => _SimuladoWizardPageState();
}

class _SimuladoWizardPageState extends State<SimuladoWizardPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  Simulado? _simulado;
  List<Questao> _questoes = [];
  bool get _isEditing => widget.simulado != null; // Helper to check if editing

  final List<Exame> _examesDisponiveis = [
    Exame(id: '1', titulo: 'AWS Cloud Practitioner'),
    Exame(id: '2', titulo: 'Azure Fundamentals'),
    Exame(id: '3', titulo: 'Google Cloud Associate'),
    Exame(id: '4', titulo: 'CompTIA Security+'),
  ];

  @override
  void initState() {
    super.initState();
    // If editing, initialize with existing simulado data
    if (_isEditing) {
      _simulado = widget.simulado;
      // TODO: Load questoes for this simulado from database
      // You'll need to add a method in your DAO to fetch questoes by simulado ID
      // _loadQuestoes();
    }
  }

  // Future method to load questoes when editing (you'll need to implement this)
  // Future<void> _loadQuestoes() async {
  //   if (_simulado?.id != null) {
  //     try {
  //       // Assuming you have a QuestaoDao
  //       // final questaoDao = QuestaoDao();
  //       // final questoes = await questaoDao.buscarPorSimulado(int.parse(_simulado!.id!));
  //       // setState(() {
  //       //   _questoes = questoes;
  //       // });
  //     } catch (e) {
  //       print('Erro ao carregar questões: $e');
  //     }
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${_isEditing ? "Editar" : "Cadastro de"} Simulado - Etapa ${_currentStep + 1}',
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
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

          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SimuladoFormComponent(
                  examesDisponiveis: _examesDisponiveis,
                  simuladoInicial:
                      _simulado, // Pass existing simulado for editing
                  onSimuladoCreated: (simulado) {
                    setState(() {
                      _simulado = simulado;
                    });
                  },
                ),
                QuestaoCrudComponent(
                  simulado: _simulado,
                  questoes: _questoes,
                  onQuestoesChanged: (questoes) {
                    setState(() {
                      _questoes = questoes;
                    });
                  },
                ),
              ],
            ),
          ),

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
                  child: Text(
                    _currentStep == 1
                        ? (_isEditing ? 'Salvar' : 'Finalizar')
                        : 'Próximo',
                  ),
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
      if (_simulado != null) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Preencha todos os campos obrigatórios do simulado'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else if (_currentStep == 1) {
      _finalizarCadastro();
    }
  }

  void _finalizarCadastro() {
    // Skip validation for editing mode if you want to allow saving without questoes
    if (_questoes.isEmpty && !_isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Adicione pelo menos uma questão ao simulado'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (widget.onSave != null) {
      widget.onSave!(_simulado!);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isEditing
              ? 'Simulado atualizado com sucesso!'
              : 'Simulado criado com sucesso!',
        ),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }
}

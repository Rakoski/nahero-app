import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/utils/utils.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/app/widget/forms/simulado_form_page.dart';

class ListaSimuladosPage extends StatefulWidget {
  const ListaSimuladosPage({Key? key}) : super(key: key);

  @override
  _ListaSimuladosPageState createState() => _ListaSimuladosPageState();
}

class _ListaSimuladosPageState extends State<ListaSimuladosPage> {
  List<Simulado> simulados = [
    Simulado(
      id: '1',
      titulo: 'CLOUD PRACTITIONER',
      descricao:
          'A practice exam to test your knowledge of AWS Services. Foundational.',
      pontuacaoAprovacao: 70,
      tempoLimite: 60,
      nivelDificuldade: 2,
    ),
    Simulado(
      id: '2',
      titulo: 'SOLUTIONS ARCHITECT',
      descricao: 'Advanced exam covering AWS architecture and design patterns.',
      pontuacaoAprovacao: 75,
      tempoLimite: 90,
      nivelDificuldade: 3,
    ),
    Simulado(
      id: '3',
      titulo: 'DEVELOPER ASSOCIATE',
      descricao: 'Exam focused on AWS development services and best practices.',
      pontuacaoAprovacao: 65,
      tempoLimite: 45,
      nivelDificuldade: 1,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => SimuladoFormPage(
                        onSave: (novoSimulado, questoes) {
                          setState(() {
                            simulados.add(novoSimulado);
                          });

                          print(
                            'Simulado criado com ${questoes.length} questões',
                          );
                        },
                      ),
                ),
              );
            },
          ),
        ],
      ),
      body:
          simulados.isEmpty
              ? const Center(
                child: Text('Nenhum simulado', style: TextStyle(fontSize: 18)),
              )
              : ListView.builder(
                itemCount: simulados.length,
                itemBuilder: (context, index) {
                  final simulado = simulados[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text(
                        simulado.titulo ?? 'COLOCAR TIT',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(simulado.descricao ?? 'COLOCAR DESC'),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.timer,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text('${simulado.tempoLimite} min'),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.equalizer,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                Utils.getNivelDificuldade(
                                  simulado.nivelDificuldade,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text('${simulado.pontuacaoAprovacao}%'),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SimuladoFormPage(
                                        simulado: simulado,
                                        onSave: (simuladoAtualizado, questoes) {
                                          setState(() {
                                            simulados[index] =
                                                simuladoAtualizado;
                                          });

                                          print(
                                            'Simulado atualizado com ${questoes.length} questões',
                                          );
                                        },
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              excluir(simulado, index);
                            },
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        _verDetalhes(simulado);
                      },
                    ),
                  );
                },
              ),
    );
  }

  void excluir(Simulado simulado, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: Text('Deseja excluir o simulado "${simulado.titulo}"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    simulados.removeAt(index);
                  });
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Simulado "${simulado.titulo}" excluído'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Excluir'),
              ),
            ],
          ),
    );
  }

  void _verDetalhes(Simulado simulado) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(simulado.titulo ?? 'Simulado'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Descrição: ${simulado.descricao}'),
                const SizedBox(height: 8),
                Text('Tempo: ${simulado.tempoLimite} minutos'),
                Text('Aprovação: ${simulado.pontuacaoAprovacao}%'),
                Text(
                  'Nível: ${Utils.getNivelDificuldade(simulado.nivelDificuldade)}',
                ),
                Text(
                  'Status: ${simulado.estaAtivo == true ? "Ativo" : "Inativo"}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Fechar'),
              ),
            ],
          ),
    );
  }
}

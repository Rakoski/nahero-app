import 'package:flutter/material.dart';
import 'package:flutter_app_helio/comum/utils/utils.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/paginas/simulado/simulado_form_page.dart';

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
      titulo: 'CLOUD PRACTITIONER',
      descricao:
          'A practice exam to test your knowledge of AWS Services. Foundational.',
      pontuacaoAprovacao: 70,
      tempoLimite: 60,
      nivelDificuldade: 3,
    ),
    Simulado(
      id: '3',
      titulo: 'CLOUD PRACTITIONER',
      descricao:
          'A practice exam to test your knowledge of AWS Services. Foundational.',
      pontuacaoAprovacao: 70,
      tempoLimite: 60,
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
                        onSave: (novoSimulado) {
                          setState(() {
                            simulados.add(novoSimulado);
                          });
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
                child: Text('Nenhum simuladou', style: TextStyle(fontSize: 18)),
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
                                        onSave: (simuladoAtualizado) {
                                          setState(() {
                                            simulados[index] =
                                                simuladoAtualizado;
                                          });
                                        },
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              ewxcluir(simulado, index);
                            },
                          ),
                        ],
                      ),
                      isThreeLine: true,
                      onTap: () {
                        print("tapoud");
                      },
                    ),
                  );
                },
              ),
    );
  }

  void ewxcluir(Simulado simulado, int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('vish slk ?'),
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
                },
                child: const Text('Excluir'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
    );
  }
}

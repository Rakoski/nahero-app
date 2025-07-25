import 'package:flutter/material.dart';
import 'package:flutter_app_helio/app/paginas/simulado_wizard_page.dart';
import 'package:flutter_app_helio/comum/utils/utils.dart';
import 'package:flutter_app_helio/modelo/dao/simulado_dao.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/app/widget/forms/simulado_form_page.dart';

class ListaSimuladosPage extends StatefulWidget {
  const ListaSimuladosPage({Key? key}) : super(key: key);

  @override
  _ListaSimuladosPageState createState() => _ListaSimuladosPageState();
}

class _ListaSimuladosPageState extends State<ListaSimuladosPage> {
  final SimuladoDao _simuladoDao = SimuladoDao(); // Add DAO instance
  List<Simulado> simulados = []; // Start with empty list
  bool _isLoading = true; // Add loading state

  @override
  void initState() {
    super.initState();
    _carregarSimulados(); // Load data when widget initializes
  }

  // Method to load simulados from database
  Future<void> _carregarSimulados() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final simuladosCarregados = await _simuladoDao.buscarTodos();

      setState(() {
        simulados = simuladosCarregados;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar simulados: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulados'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarSimulados, // Add refresh button
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loading indicator
              : simulados.isEmpty
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
                                      (context) => SimuladoWizardPage(
                                        simulado:
                                            simulado, // Pass the simulado for editing
                                        onSave: (simuladoAtualizado) async {
                                          try {
                                            // Update in database
                                            await _simuladoDao.atualizar(
                                              simuladoAtualizado,
                                            );

                                            // Reload the list
                                            await _carregarSimulados();

                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Simulado "${simuladoAtualizado.titulo}" atualizado',
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'Erro ao atualizar: $e',
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => SimuladoWizardPage(
                    onSave: (novoSimulado) async {
                      try {
                        // Insert in database
                        await _simuladoDao.inserir(novoSimulado);

                        // Reload the list
                        await _carregarSimulados();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Simulado "${novoSimulado.titulo}" criado',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erro ao criar simulado: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
            ),
          );
        },
        child: const Icon(Icons.add),
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
                onPressed: () async {
                  try {
                    final id = int.parse(simulado.id!);

                    await _simuladoDao.excluir(id);

                    Navigator.of(context).pop();

                    await _carregarSimulados();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Simulado "${simulado.titulo}" excluído'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro ao excluir simulado: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
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
                if (simulado.exame?.titulo != null) ...[
                  const SizedBox(height: 4),
                  Text('Exame: ${simulado.exame!.titulo}'),
                ],
                if (simulado.professor?.nome != null) ...[
                  const SizedBox(height: 4),
                  Text('Professor: ${simulado.professor!.nome}'),
                ],
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/tipo_questao.dart';

class QuestaoFormPage extends StatefulWidget {
  final Simulado simulado;
  final Questao? questao;
  final Function(Questao) onSave;

  const QuestaoFormPage({
    Key? key,
    required this.simulado,
    this.questao,
    required this.onSave,
  }) : super(key: key);

  @override
  _QuestaoFormPageState createState() => _QuestaoFormPageState();
}

class _QuestaoFormPageState extends State<QuestaoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _conteudoController;
  late TextEditingController _explicacaoController;
  late TextEditingController _urlImagemController;
  late TextEditingController _pontosController;
  late TipoQuestao? _tipoQuestaoSelecionado;
  late bool _estaAtiva;

  final List<TipoQuestao> _tiposQuestao = [
    TipoQuestao(id: '1', nome: 'objetiva'),
    TipoQuestao(id: '2', nome: 'vdd ou falso'),
    TipoQuestao(id: '3', nome: 'de escrever'),
  ];

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.questao != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Questão' : 'Nova Questão'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<TipoQuestao>(
                decoration: const InputDecoration(
                  labelText: 'Tipo de Questão',
                  border: OutlineInputBorder(),
                ),
                value: _tipoQuestaoSelecionado,
                items:
                    _tiposQuestao.map((tipo) {
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
                    return 'tipo quqes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _conteudoController,
                decoration: const InputDecoration(
                  labelText: 'Enunciado ',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'falta enum,';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _urlImagemController,
                decoration: const InputDecoration(
                  labelText: 'URL',
                  border: OutlineInputBorder(),
                  hintText: 'colocar url',
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _explicacaoController,
                decoration: const InputDecoration(
                  labelText: 'resp explicacao pdv',
                  border: OutlineInputBorder(),
                  hintText:
                      'oq vai ser mostrado dps do cara terminar o simulado',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _pontosController,
                decoration: const InputDecoration(
                  labelText: 'pontos',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'colocar ponto';
                  }
                  final pontos = int.tryParse(value);
                  if (pontos == null || pontos <= 0) {
                    return 'tem que ser maior q 0 ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Questão Ativa'),
                subtitle: const Text('nn vai exibit'),
                value: _estaAtiva,
                onChanged: (value) {
                  setState(() {
                    _estaAtiva = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _salvarQuestao,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    isEditing ? 'ATUALIZAR QUESTÃO' : 'SALVAR QUESTÃO',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

              if (isEditing)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.list),
                    label: const Text('GERENCIAR ALTERNATIVAS'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _salvarQuestao() {
    if (_formKey.currentState!.validate()) {
      final questao = Questao(
        id: widget.questao?.id,
        simulado: widget.simulado,
        tipoQuestao: _tipoQuestaoSelecionado,
        conteudo: _conteudoController.text,
        explicacao:
            _explicacaoController.text.isEmpty
                ? null
                : _explicacaoController.text,
        urlImagem:
            _urlImagemController.text.isEmpty
                ? null
                : _urlImagemController.text,
        pontos: int.parse(_pontosController.text),
        estaAtiva: _estaAtiva,
        versao: widget.questao?.versao ?? 1,
        professor: widget.questao?.professor,
        criadoEm: widget.questao?.criadoEm,
        atualizadoEm: DateTime.now(),
      );

      widget.onSave(questao);

      Navigator.of(context).pop();

      print("salvcouuu");
      print("eu acho");
    }
  }
}

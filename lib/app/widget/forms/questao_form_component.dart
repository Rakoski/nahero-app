import 'package:flutter/material.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/tipo_questao.dart';

class QuestaoFormComponent extends StatefulWidget {
  final Simulado simulado;
  final Questao? questao;
  final Function(Questao) onSave;

  const QuestaoFormComponent({
    Key? key,
    required this.simulado,
    this.questao,
    required this.onSave,
  }) : super(key: key);

  @override
  _QuestaoFormComponentState createState() => _QuestaoFormComponentState();
}

class _QuestaoFormComponentState extends State<QuestaoFormComponent> {
  final _formKey = GlobalKey<FormState>();
  var _conteudoController = TextEditingController();
  var _explicacaoController = TextEditingController();
  var _urlImagemController = TextEditingController();
  var _pontosController = TextEditingController();
  TipoQuestao? _tipoQuestaoSelecionado;
  bool _estaAtiva = true;

  final List<TipoQuestao> tipos = [
    TipoQuestao(id: '1', nome: 'objetiva'),
    TipoQuestao(id: '2', nome: 'vdd ou falso'),
    TipoQuestao(id: '3', nome: 'de escrever'),
  ];

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.questao != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Editar' : 'Nova')),
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    return 'selecione um tipo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _conteudoController,
                decoration: const InputDecoration(
                  labelText: 'Enunciado',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'digite o enunciado';
                  }
                  return null;
                },
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
                maxLines: 3,
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
                    return 'digite a pontuação';
                  }
                  final pontos = int.tryParse(value);
                  if (pontos == null || pontos <= 0) {
                    return 'tem q ser maior que 0';
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
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    salvar();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    isEditing ? 'ATUALIZAR' : 'SALVAR',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void salvar() {
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
          _urlImagemController.text.isEmpty ? null : _urlImagemController.text,
      pontos: int.parse(_pontosController.text),
      estaAtiva: _estaAtiva,
      versao: widget.questao?.versao ?? 1,
      professor: widget.questao?.professor,
      criadoEm: widget.questao?.criadoEm,
      atualizadoEm: DateTime.now(),
    );

    widget.onSave(questao);
    Navigator.of(context).pop();
  }
}

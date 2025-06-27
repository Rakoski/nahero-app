import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/entidades/prova/entidades/prova.dart';
import 'package:flutter_app_helio/modelo/entidades/usuario/entidades/usuario.dart';

class Simulado extends EntidadeBase {
  Exame? exame;
  String? titulo;
  String? descricao;
  int? pontuacaoAprovacao;
  Usuario? professor;
  int? tempoLimite;
  int? nivelDificuldade;
  bool? estaAtivo = true;

  Simulado({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.exame,
    this.titulo,
    this.descricao,
    this.pontuacaoAprovacao,
    this.professor,
    this.tempoLimite,
    this.nivelDificuldade,
    this.estaAtivo = true,
  });
}

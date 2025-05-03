import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/tipo_questao.dart';
import 'package:flutter_app_helio/modelo/usuario/entidades/usuario.dart';

class Questao extends EntidadeBase {
  Questao? questaoBase;
  Simulado? simulado;
  TipoQuestao? tipoQuestao;
  String? conteudo;
  String? urlImagem;
  String? explicacao;
  int? pontos = 1;
  int? versao = 1;
  bool? estaAtiva = true;
  Usuario? professor;

  Questao({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.questaoBase,
    this.simulado,
    this.tipoQuestao,
    this.conteudo,
    this.urlImagem,
    this.explicacao,
    this.pontos = 1,
    this.versao = 1,
    this.estaAtiva = true,
    this.professor,
  });
}

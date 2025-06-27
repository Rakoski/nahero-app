import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/entidades/usuario/entidades/usuario.dart';

class Alternativa extends EntidadeBase {
  Alternativa? alternativaBase;
  Questao? questao;
  String? urlImagem;
  String? conteudo;
  bool? estaCorreta;
  int? versao = 1;
  bool? estaAtiva = true;
  Usuario? professor;

  Alternativa({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.alternativaBase,
    this.questao,
    this.urlImagem,
    this.conteudo,
    this.estaCorreta,
    this.versao = 1,
    this.estaAtiva = true,
    this.professor,
  });
}

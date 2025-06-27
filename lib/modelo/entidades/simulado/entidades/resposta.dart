import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';

class Resposta extends EntidadeBase {
  Simulado? simulado;
  String? questaoId;
  int? questaoVersao;
  String? alternativaSelecionadaId;
  int? alternativaSelecionadaVersao;
  bool? estaCorreta;

  Resposta({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.simulado,
    this.questaoId,
    this.questaoVersao,
    this.alternativaSelecionadaId,
    this.alternativaSelecionadaVersao,
    this.estaCorreta,
  });
}

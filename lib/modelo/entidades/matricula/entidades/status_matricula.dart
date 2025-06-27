import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';

class StatusMatricula extends EntidadeBase {
  String? nome;
  String? descricao;

  StatusMatricula({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.nome,
    this.descricao,
  });
}

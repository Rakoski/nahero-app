import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';

class StatusSimulado extends EntidadeBase {
  String? nome;
  String? descricao;

  StatusSimulado({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.nome,
    this.descricao,
  });
}

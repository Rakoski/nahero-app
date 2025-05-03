import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';

class TipoQuestao extends EntidadeBase {
  String? nome;

  TipoQuestao({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.nome,
  });
}

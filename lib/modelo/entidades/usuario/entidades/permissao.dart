import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/entidades/usuario/entidades/cargo.dart';

class Permissao extends EntidadeBase {
  String? descricao;
  List<Cargo> cargos = [];

  Permissao({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.descricao,
    List<Cargo>? cargos,
  }) : cargos = cargos ?? [];
}

import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/usuario/entidades/usuario.dart';

class Exame extends EntidadeBase {
  String? titulo;
  String? descricao;
  Usuario? professor;
  String? categoria;
  bool? estaAtivo = true;
  int? nivelDificuldade;

  Exame({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.titulo,
    this.descricao,
    this.professor,
    this.categoria,
    this.estaAtivo = true,
    this.nivelDificuldade,
  });
}

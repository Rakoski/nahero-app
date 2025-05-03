import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/usuario/entidades/permissao.dart';
import 'package:flutter_app_helio/modelo/usuario/entidades/usuario.dart';

class Cargo extends EntidadeBase {
  String? nome;
  List<Usuario> usuarios = [];
  List<Permissao> permissoes = [];

  Cargo({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.nome,
    List<Usuario>? usuarios,
    List<Permissao>? permissoes,
  }) : usuarios = usuarios ?? [],
       permissoes = permissoes ?? [];

  bool temPermissao(String descricao) {
    return permissoes.any((permissao) => permissao.descricao == descricao);
  }
}

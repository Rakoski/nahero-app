import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/usuario/entidades/cargo.dart';
import 'package:flutter_app_helio/modelo/usuario/entidades/endereco.dart';

class Usuario extends EntidadeBase {
  static const int tamanhoMaximoBio = 500;

  String? nome;
  String? email;
  String? cpf;
  String? numeroPassaporte;
  String? bio;
  String? senha;
  String? telefone;
  String? urlAvatar;
  DateTime? emailConfirmadoEm;
  String? idClienteExterno;
  String? tokenRecuperacaoSenha;
  Endereco? endereco;
  List<Cargo> cargos = [];

  Usuario({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.nome,
    this.email,
    this.cpf,
    this.numeroPassaporte,
    this.bio,
    this.senha,
    this.telefone,
    this.urlAvatar,
    this.emailConfirmadoEm,
    this.idClienteExterno,
    this.tokenRecuperacaoSenha,
    this.endereco,
    List<Cargo>? cargos,
  }) : cargos = cargos ?? [];

  bool temCargo(String nomeCargo) {
    return cargos.any((cargo) => cargo.nome == nomeCargo);
  }
}

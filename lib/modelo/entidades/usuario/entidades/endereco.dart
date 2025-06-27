import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/entidades/usuario/entidades/usuario.dart';

class Endereco extends EntidadeBase {
  String? cep;
  String? rua;
  String? numero;
  String? complemento;
  String? bairro;
  String? cidade;
  String? estado;
  String? pais = "Brasil";
  Usuario? usuario;

  Endereco({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.cep,
    this.rua,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.pais = "Brasil",
    this.usuario,
  });
}

import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/matricula/entidades/status_matricula.dart';
import 'package:flutter_app_helio/modelo/prova/entidades/prova.dart';
import 'package:flutter_app_helio/modelo/usuario/entidades/usuario.dart';

class Matricula extends EntidadeBase {
  Usuario estudante;
  Exame exame;
  StatusMatricula status;

  Matricula({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    required this.estudante,
    required this.exame,
    required this.status,
  });
}

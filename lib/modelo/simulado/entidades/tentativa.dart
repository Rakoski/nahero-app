import 'package:flutter_app_helio/comum/entidades/entidade_base.dart';
import 'package:flutter_app_helio/modelo/matricula/entidades/matricula.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/simulado/entidades/status_simulado.dart';

class Tentativa extends EntidadeBase {
  Matricula? matricula;
  Simulado? simulado;
  StatusSimulado? statusTentativa;
  DateTime? horaInicio;
  DateTime? horaFim;
  int? pontuacao;
  bool? aprovado;

  Tentativa({
    super.id,
    super.criadoEm,
    super.atualizadoEm,
    super.excluidoEm,
    this.matricula,
    this.simulado,
    this.statusTentativa,
    this.horaInicio,
    this.horaFim,
    this.pontuacao,
    this.aprovado,
  });
}

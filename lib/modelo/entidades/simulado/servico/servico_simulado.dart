import 'package:flutter_app_helio/modelo/dao/exame_dao.dart';
import 'package:flutter_app_helio/modelo/dao/questao_dao.dart';
import 'package:flutter_app_helio/modelo/dao/simulado_dao.dart';
import 'package:flutter_app_helio/modelo/dao/tipo_questao_dao.dart';
import 'package:flutter_app_helio/modelo/entidades/prova/entidades/prova.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/tipo_questao.dart';

class SimuladoService {
  final SimuladoDao _simuladoDao = SimuladoDao();
  final QuestaoDao _questaoDao = QuestaoDao();
  final ExameDao _exameDao = ExameDao();
  final TipoQuestaoDao _tipoQuestaoDao = TipoQuestaoDao();

  Future<Simulado> criarSimulado(Simulado simulado) async {
    try {
      final now = DateTime.now();
      final simuladoParaSalvar = Simulado(
        id: simulado.id,
        exame: simulado.exame,
        titulo: simulado.titulo,
        descricao: simulado.descricao,
        pontuacaoAprovacao: simulado.pontuacaoAprovacao,
        professor: simulado.professor,
        tempoLimite: simulado.tempoLimite,
        nivelDificuldade: simulado.nivelDificuldade,
        estaAtivo: simulado.estaAtivo,
        criadoEm: now,
        atualizadoEm: now,
      );

      final id = await _simuladoDao.inserir(simuladoParaSalvar);

      return simuladoParaSalvar;
    } catch (e) {
      throw Exception('Erro ao criar simulado: $e');
    }
  }

  Future<List<Simulado>> obterTodosSimulados() async {
    try {
      return await _simuladoDao.buscarTodos();
    } catch (e) {
      throw Exception('Erro ao buscar simulados: $e');
    }
  }

  Future<Simulado?> obterSimuladoPorId(int id) async {
    try {
      return await _simuladoDao.buscarPorId(id);
    } catch (e) {
      throw Exception('Erro ao buscar simulado: $e');
    }
  }

  Future<void> atualizarSimulado(Simulado simulado) async {
    try {
      await _simuladoDao.atualizar(simulado);
    } catch (e) {
      throw Exception('Erro ao atualizar simulado: $e');
    }
  }

  Future<void> excluirSimulado(int id) async {
    try {
      await _simuladoDao.excluir(id);
    } catch (e) {
      throw Exception('Erro ao excluir simulado: $e');
    }
  }

  Future<Questao> criarQuestao(Questao questao) async {
    try {
      final now = DateTime.now();
      final questaoParaSalvar = Questao(
        id: questao.id,
        questaoBase: questao.questaoBase,
        simulado: questao.simulado,
        tipoQuestao: questao.tipoQuestao,
        conteudo: questao.conteudo,
        urlImagem: questao.urlImagem,
        explicacao: questao.explicacao,
        pontos: questao.pontos ?? 1,
        versao: questao.versao ?? 1,
        estaAtiva: questao.estaAtiva ?? true,
        professor: questao.professor,
        criadoEm: now,
        atualizadoEm: now,
      );

      final id = await _questaoDao.inserir(questaoParaSalvar);
      return questaoParaSalvar;
    } catch (e) {
      throw Exception('Erro ao criar questão: $e');
    }
  }

  Future<List<Questao>> obterQuestoesPorSimulado(int simuladoId) async {
    try {
      return await _questaoDao.buscarPorSimulado(simuladoId);
    } catch (e) {
      throw Exception('Erro ao buscar questões: $e');
    }
  }

  Future<void> atualizarQuestao(Questao questao) async {
    try {
      await _questaoDao.atualizar(questao);
    } catch (e) {
      throw Exception('Erro ao atualizar questão: $e');
    }
  }

  Future<void> excluirQuestao(int id) async {
    try {
      await _questaoDao.excluir(id);
    } catch (e) {
      throw Exception('Erro ao excluir questão: $e');
    }
  }

  Future<List<Exame>> obterExamesDisponiveis() async {
    try {
      return await _exameDao.buscarAtivos();
    } catch (e) {
      throw Exception('Erro ao buscar exames: $e');
    }
  }

  Future<void> criarExamesDefault() async {
    try {
      final exames = await _exameDao.buscarTodos();
      if (exames.isEmpty) {
        final now = DateTime.now();
        await _exameDao.inserir(
          Exame(
            titulo: 'AWS Cloud Practitioner',
            descricao: 'Certificação AWS Cloud Practitioner',
            categoria: 'Cloud Computing',
            estaAtivo: true,
            nivelDificuldade: 2,
            criadoEm: now,
            atualizadoEm: now,
          ),
        );

        await _exameDao.inserir(
          Exame(
            titulo: 'Azure Fundamentals',
            descricao: 'Certificação Microsoft Azure Fundamentals',
            categoria: 'Cloud Computing',
            estaAtivo: true,
            nivelDificuldade: 2,
            criadoEm: now,
            atualizadoEm: now,
          ),
        );

        await _exameDao.inserir(
          Exame(
            titulo: 'Google Cloud Associate',
            descricao: 'Certificação Google Cloud Associate',
            categoria: 'Cloud Computing',
            estaAtivo: true,
            nivelDificuldade: 3,
            criadoEm: now,
            atualizadoEm: now,
          ),
        );

        await _exameDao.inserir(
          Exame(
            titulo: 'CompTIA Security+',
            descricao: 'Certificação CompTIA Security+',
            categoria: 'Cybersecurity',
            estaAtivo: true,
            nivelDificuldade: 3,
            criadoEm: now,
            atualizadoEm: now,
          ),
        );
      }
    } catch (e) {
      throw Exception('Erro ao criar exames padrão: $e');
    }
  }

  Future<List<TipoQuestao>> obterTiposQuestao() async {
    try {
      return await _tipoQuestaoDao.buscarTodos();
    } catch (e) {
      throw Exception('Erro ao buscar tipos de questão: $e');
    }
  }

  Future<void> criarTiposQuestaoDefault() async {
    try {
      await _tipoQuestaoDao.inserirTiposDefault();
    } catch (e) {
      throw Exception('Erro ao criar tipos de questão padrão: $e');
    }
  }

  Future<Simulado> criarSimuladoCompleto(
    Simulado simulado,
    List<Questao> questoes,
  ) async {
    try {
      final simuladoCriado = await criarSimulado(simulado);

      for (final questao in questoes) {
        final questaoComSimulado = Questao(
          id: questao.id,
          questaoBase: questao.questaoBase,
          simulado: simuladoCriado,
          tipoQuestao: questao.tipoQuestao,
          conteudo: questao.conteudo,
          urlImagem: questao.urlImagem,
          explicacao: questao.explicacao,
          pontos: questao.pontos,
          versao: questao.versao,
          estaAtiva: questao.estaAtiva,
          professor: questao.professor,
        );

        await criarQuestao(questaoComSimulado);
      }

      return simuladoCriado;
    } catch (e) {
      throw Exception('Erro ao criar simulado completo: $e');
    }
  }

  Future<void> inicializarDadosDefault() async {
    try {
      await criarTiposQuestaoDefault();
      await criarExamesDefault();
    } catch (e) {
      throw Exception('Erro ao inicializar dados padrão: $e');
    }
  }

  bool validarSimulado(Simulado simulado) {
    if (simulado.titulo == null || simulado.titulo!.trim().isEmpty) {
      return false;
    }
    if (simulado.descricao == null || simulado.descricao!.trim().isEmpty) {
      return false;
    }
    if (simulado.exame == null) {
      return false;
    }
    if (simulado.pontuacaoAprovacao == null ||
        simulado.pontuacaoAprovacao! < 0 ||
        simulado.pontuacaoAprovacao! > 100) {
      return false;
    }
    if (simulado.tempoLimite == null || simulado.tempoLimite! <= 0) {
      return false;
    }
    return true;
  }

  bool validarQuestao(Questao questao) {
    if (questao.conteudo == null || questao.conteudo!.trim().isEmpty) {
      return false;
    }
    if (questao.tipoQuestao == null) {
      return false;
    }
    if (questao.pontos == null || questao.pontos! <= 0) {
      return false;
    }
    return true;
  }
}

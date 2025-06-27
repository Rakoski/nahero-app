import 'package:flutter_app_helio/comum/configs/banco/conexao.dart';
import 'package:flutter_app_helio/modelo/entidades/prova/entidades/prova.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/entidades/usuario/entidades/usuario.dart';

class SimuladoDao {
  final Conexao conexao = Conexao();

  Future<int> inserir(Simulado simulado) async {
    final db = await conexao.database;
    return await db.insert('simulados', {
      'exame_id': simulado.exame?.id,
      'titulo': simulado.titulo,
      'descricao': simulado.descricao,
      'pontuacao_aprovacao': simulado.pontuacaoAprovacao,
      'professor_id': simulado.professor?.id,
      'tempo_limite': simulado.tempoLimite,
      'nivel_dificuldade': simulado.nivelDificuldade,
      'esta_ativo': simulado.estaAtivo == true ? 1 : 0,
      'criado_em': simulado.criadoEm?.toIso8601String(),
      'atualizado_em': simulado.atualizadoEm?.toIso8601String(),
      'excluido_em': simulado.excluidoEm?.toIso8601String(),
    });
  }

  Future<List<Simulado>> buscarTodos() async {
    final db = await conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT s.*, e.titulo as exame_titulo, u.nome as professor_nome
      FROM simulados s
      LEFT JOIN exames e ON s.exame_id = e.id
      LEFT JOIN usuarios u ON s.professor_id = u.id
      WHERE s.excluido_em IS NULL
      ORDER BY s.criado_em DESC
    ''');

    return List.generate(maps.length, (i) {
      return _mapToSimulado(maps[i]);
    });
  }

  Future<Simulado?> buscarPorId(int id) async {
    final db = await conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, e.titulo as exame_titulo, u.nome as professor_nome
      FROM simulados s
      LEFT JOIN exames e ON s.exame_id = e.id
      LEFT JOIN usuarios u ON s.professor_id = u.id
      WHERE s.id = ? AND s.excluido_em IS NULL
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      return _mapToSimulado(maps.first);
    }
    return null;
  }

  Future<int> atualizar(Simulado simulado) async {
    final db = await conexao.database;
    return await db.update(
      'simulados',
      {
        'exame_id': simulado.exame?.id,
        'titulo': simulado.titulo,
        'descricao': simulado.descricao,
        'pontuacao_aprovacao': simulado.pontuacaoAprovacao,
        'professor_id': simulado.professor?.id,
        'tempo_limite': simulado.tempoLimite,
        'nivel_dificuldade': simulado.nivelDificuldade,
        'esta_ativo': simulado.estaAtivo == true ? 1 : 0,
        'atualizado_em': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [simulado.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await conexao.database;
    return await db.update(
      'simulados',
      {'excluido_em': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Simulado>> buscarPorExame(int exameId) async {
    final db = await conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT s.*, e.titulo as exame_titulo, u.nome as professor_nome
      FROM simulados s
      LEFT JOIN exames e ON s.exame_id = e.id
      LEFT JOIN usuarios u ON s.professor_id = u.id
      WHERE s.exame_id = ? AND s.excluido_em IS NULL
      ORDER BY s.criado_em DESC
    ''',
      [exameId],
    );

    return List.generate(maps.length, (i) {
      return _mapToSimulado(maps[i]);
    });
  }

  Simulado _mapToSimulado(Map<String, dynamic> map) {
    return Simulado(
      id: map['id']?.toString(),
      exame:
          map['exame_id'] != null
              ? Exame(
                id: map['exame_id']?.toString(),
                titulo: map['exame_titulo'],
              )
              : null,
      titulo: map['titulo'],
      descricao: map['descricao'],
      pontuacaoAprovacao: map['pontuacao_aprovacao'],
      professor:
          map['professor_id'] != null
              ? Usuario(
                id: map['professor_id']?.toString(),
                nome: map['professor_nome'],
              )
              : null,
      tempoLimite: map['tempo_limite'],
      nivelDificuldade: map['nivel_dificuldade'],
      estaAtivo: map['esta_ativo'] == 1,
      criadoEm:
          map['criado_em'] != null ? DateTime.parse(map['criado_em']) : null,
      atualizadoEm:
          map['atualizado_em'] != null
              ? DateTime.parse(map['atualizado_em'])
              : null,
      excluidoEm:
          map['excluido_em'] != null
              ? DateTime.parse(map['excluido_em'])
              : null,
    );
  }
}

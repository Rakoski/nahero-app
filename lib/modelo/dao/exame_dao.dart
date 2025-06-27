import 'package:flutter_app_helio/comum/configs/banco/conexao.dart';
import 'package:flutter_app_helio/modelo/entidades/prova/entidades/prova.dart';
import 'package:flutter_app_helio/modelo/entidades/usuario/entidades/usuario.dart';

class ExameDao {
  final Conexao _conexao = Conexao();

  Future<int> inserir(Exame exame) async {
    final db = await _conexao.database;
    return await db.insert('exames', {
      'titulo': exame.titulo,
      'descricao': exame.descricao,
      'professor_id': exame.professor?.id,
      'categoria': exame.categoria,

      'esta_ativo': exame.estaAtivo == true ? 1 : 0,
      'nivel_dificuldade': exame.nivelDificuldade,
      'criado_em': exame.criadoEm?.toIso8601String(),
      'atualizado_em': exame.atualizadoEm?.toIso8601String(),
      'excluido_em': exame.excluidoEm?.toIso8601String(),
    });
  }

  Future<List<Exame>> buscarTodos() async {
    final db = await _conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT e.*, u.nome as professor_nome
      FROM exames e
      LEFT JOIN usuarios u ON e.professor_id = u.id
      WHERE e.excluido_em IS NULL
      ORDER BY e.titulo ASC
    ''');

    return List.generate(maps.length, (i) {
      return _mapToExame(maps[i]);
    });
  }

  Future<Exame?> buscarPorId(int id) async {
    final db = await _conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT e.*, u.nome as professor_nome
      FROM exames e
      LEFT JOIN usuarios u ON e.professor_id = u.id
      WHERE e.id = ? AND e.excluido_em IS NULL
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      return _mapToExame(maps.first);
    }
    return null;
  }

  Future<int> atualizar(Exame exame) async {
    final db = await _conexao.database;
    return await db.update(
      'exames',
      {
        'titulo': exame.titulo,
        'descricao': exame.descricao,
        'professor_id': exame.professor?.id,
        'categoria': exame.categoria,
        'esta_ativo': exame.estaAtivo == true ? 1 : 0,
        'nivel_dificuldade': exame.nivelDificuldade,
        'atualizado_em': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [exame.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await _conexao.database;
    return await db.update(
      'exames',
      {'excluido_em': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Exame>> buscarAtivos() async {
    final db = await _conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT e.*, u.nome as professor_nome
      FROM exames e
      LEFT JOIN usuarios u ON e.professor_id = u.id
      WHERE e.esta_ativo = 1 AND e.excluido_em IS NULL
      ORDER BY e.titulo ASC
    ''');

    return List.generate(maps.length, (i) {
      return _mapToExame(maps[i]);
    });
  }

  Exame _mapToExame(Map<String, dynamic> map) {
    return Exame(
      id: map['id']?.toString(),
      titulo: map['titulo'],
      descricao: map['descricao'],
      professor:
          map['professor_id'] != null
              ? Usuario(
                id: map['professor_id']?.toString(),
                nome: map['professor_nome'],
              )
              : null,
      categoria: map['categoria'],
      estaAtivo: map['esta_ativo'] == 1,
      nivelDificuldade: map['nivel_dificuldade'],
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

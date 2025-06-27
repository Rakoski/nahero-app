import 'package:flutter_app_helio/comum/configs/banco/conexao.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/tipo_questao.dart';

class TipoQuestaoDao {
  final Conexao _conexao = Conexao();

  Future<int> inserir(TipoQuestao tipoQuestao) async {
    final db = await _conexao.database;
    return await db.insert('tipo_questao', {
      'nome': tipoQuestao.nome,
      'criado_em': tipoQuestao.criadoEm?.toIso8601String(),
      'atualizado_em': tipoQuestao.atualizadoEm?.toIso8601String(),
      'excluido_em': tipoQuestao.excluidoEm?.toIso8601String(),
    });
  }

  Future<List<TipoQuestao>> buscarTodos() async {
    final db = await _conexao.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tipo_questao',
      where: 'excluido_em IS NULL',
      orderBy: 'nome ASC',
    );

    return List.generate(maps.length, (i) {
      return _mapToTipoQuestao(maps[i]);
    });
  }

  Future<TipoQuestao?> buscarPorId(int id) async {
    final db = await _conexao.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tipo_questao',
      where: 'id = ? AND excluido_em IS NULL',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return _mapToTipoQuestao(maps.first);
    }
    return null;
  }

  Future<int> atualizar(TipoQuestao tipoQuestao) async {
    final db = await _conexao.database;
    return await db.update(
      'tipo_questao',
      {
        'nome': tipoQuestao.nome,
        'atualizado_em': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [tipoQuestao.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await _conexao.database;
    return await db.update(
      'tipo_questao',
      {'excluido_em': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> inserirTiposDefault() async {
    final tipos = await buscarTodos();
    if (tipos.isEmpty) {
      await inserir(TipoQuestao(nome: 'Múltipla Escolha'));
      await inserir(TipoQuestao(nome: 'Verdadeiro/Falso'));
      await inserir(TipoQuestao(nome: 'Dissertativa'));
    }
  }

  TipoQuestao _mapToTipoQuestao(Map<String, dynamic> map) {
    return TipoQuestao(
      id: map['id']?.toString(),
      nome: map['nome'],
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

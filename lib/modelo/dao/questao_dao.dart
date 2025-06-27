import 'package:flutter_app_helio/comum/configs/banco/conexao.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/questao.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/simulado.dart';
import 'package:flutter_app_helio/modelo/entidades/simulado/entidades/tipo_questao.dart';
import 'package:flutter_app_helio/modelo/entidades/usuario/entidades/usuario.dart';

class QuestaoDao {
  final Conexao conexao = Conexao();

  Future<int> inserir(Questao questao) async {
    final db = await conexao.database;
    return await db.insert('questoes', {
      'questao_base_id': questao.questaoBase?.id,
      'simulado_id': questao.simulado?.id,
      'tipo_questao_id': questao.tipoQuestao?.id,
      'conteudo': questao.conteudo,
      'url_imagem': questao.urlImagem,
      'explicacao': questao.explicacao,
      'pontos': questao.pontos ?? 1,
      'versao': questao.versao ?? 1,
      'esta_ativa': questao.estaAtiva == true ? 1 : 0,
      'professor_id': questao.professor?.id,
      'criado_em': questao.criadoEm?.toIso8601String(),
      'atualizado_em': questao.atualizadoEm?.toIso8601String(),
      'excluido_em': questao.excluidoEm?.toIso8601String(),
    });
  }

  Future<List<Questao>> buscarPorSimulado(int simuladoId) async {
    final db = await conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT q.*, t.nome as tipo_nome, u.nome as professor_nome
      FROM questoes q
      LEFT JOIN tipo_questao t ON q.tipo_questao_id = t.id
      LEFT JOIN usuarios u ON q.professor_id = u.id
      WHERE q.simulado_id = ? AND q.excluido_em IS NULL
      ORDER BY q.criado_em ASC
    ''',
      [simuladoId],
    );

    return List.generate(maps.length, (i) {
      return _mapToQuestao(maps[i]);
    });
  }

  Future<Questao?> buscarPorId(int id) async {
    final db = await conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT q.*, t.nome as tipo_nome, u.nome as professor_nome
      FROM questoes q
      LEFT JOIN tipo_questao t ON q.tipo_questao_id = t.id
      LEFT JOIN usuarios u ON q.professor_id = u.id
      WHERE q.id = ? AND q.excluido_em IS NULL
    ''',
      [id],
    );

    if (maps.isNotEmpty) {
      return _mapToQuestao(maps.first);
    }
    return null;
  }

  Future<int> atualizar(Questao questao) async {
    final db = await conexao.database;
    return await db.update(
      'questoes',
      {
        'questao_base_id': questao.questaoBase?.id,
        'simulado_id': questao.simulado?.id,
        'tipo_questao_id': questao.tipoQuestao?.id,
        'conteudo': questao.conteudo,
        'url_imagem': questao.urlImagem,
        'explicacao': questao.explicacao,
        'pontos': questao.pontos ?? 1,
        'versao': questao.versao ?? 1,
        'esta_ativa': questao.estaAtiva == true ? 1 : 0,
        'professor_id': questao.professor?.id,
        'atualizado_em': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [questao.id],
    );
  }

  Future<int> excluir(int id) async {
    final db = await conexao.database;
    return await db.update(
      'questoes',
      {'excluido_em': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Questao>> buscarTodas() async {
    final db = await conexao.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT q.*, t.nome as tipo_nome, u.nome as professor_nome
      FROM questoes q
      LEFT JOIN tipo_questao t ON q.tipo_questao_id = t.id
      LEFT JOIN usuarios u ON q.professor_id = u.id
      WHERE q.excluido_em IS NULL
      ORDER BY q.criado_em DESC
    ''');

    return List.generate(maps.length, (i) {
      return _mapToQuestao(maps[i]);
    });
  }

  Questao _mapToQuestao(Map<String, dynamic> map) {
    return Questao(
      id: map['id']?.toString(),
      questaoBase:
          map['questao_base_id'] != null
              ? Questao(id: map['questao_base_id']?.toString())
              : null,
      simulado:
          map['simulado_id'] != null
              ? Simulado(id: map['simulado_id']?.toString())
              : null,
      tipoQuestao:
          map['tipo_questao_id'] != null
              ? TipoQuestao(
                id: map['tipo_questao_id']?.toString(),
                nome: map['tipo_nome'],
              )
              : null,
      conteudo: map['conteudo'],
      urlImagem: map['url_imagem'],
      explicacao: map['explicacao'],
      pontos: map['pontos'],
      versao: map['versao'],
      estaAtiva: map['esta_ativa'] == 1,
      professor:
          map['professor_id'] != null
              ? Usuario(
                id: map['professor_id']?.toString(),
                nome: map['professor_nome'],
              )
              : null,
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

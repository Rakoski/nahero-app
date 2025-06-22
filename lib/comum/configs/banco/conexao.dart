import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexao {
  static final Conexao _conexao = Conexao._internal();
  factory Conexao() => _conexao;
  Conexao._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nahero_app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        email TEXT,
        cpf TEXT,
        numero_passaporte TEXT,
        bio TEXT,
        senha TEXT,
        telefone TEXT,
        url_avatar TEXT,
        email_confirmado_em TEXT,
        id_cliente_externo TEXT,
        token_recuperacao_senha TEXT,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE enderecos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cep TEXT,
        rua TEXT,
        numero TEXT,
        complemento TEXT,
        bairro TEXT,
        cidade TEXT,
        estado TEXT,
        pais TEXT DEFAULT 'Brasil',
        usuario_id INTEGER,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE cargos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE permissoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE usuario_cargos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        cargo_id INTEGER NOT NULL,
        criado_em TEXT,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id),
        FOREIGN KEY (cargo_id) REFERENCES cargos (id),
        UNIQUE(usuario_id, cargo_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE cargo_permissoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cargo_id INTEGER NOT NULL,
        permissao_id INTEGER NOT NULL,
        criado_em TEXT,
        FOREIGN KEY (cargo_id) REFERENCES cargos (id),
        FOREIGN KEY (permissao_id) REFERENCES permissoes (id),
        UNIQUE(cargo_id, permissao_id)
      )
    ''');

    await db.execute('''
      CREATE TABLE exames(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        descricao TEXT,
        professor_id INTEGER,
        categoria TEXT,
        esta_ativo INTEGER DEFAULT 1,
        nivel_dificuldade INTEGER,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (professor_id) REFERENCES usuarios (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE status_matricula(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        descricao TEXT,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE matriculas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        estudante_id INTEGER NOT NULL,
        exame_id INTEGER NOT NULL,
        status_id INTEGER NOT NULL,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (estudante_id) REFERENCES usuarios (id),
        FOREIGN KEY (exame_id) REFERENCES exames (id),
        FOREIGN KEY (status_id) REFERENCES status_matricula (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE simulados(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        exame_id INTEGER,
        titulo TEXT,
        descricao TEXT,
        pontuacao_aprovacao INTEGER,
        professor_id INTEGER,
        tempo_limite INTEGER,
        nivel_dificuldade INTEGER,
        esta_ativo INTEGER DEFAULT 1,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (exame_id) REFERENCES exames (id),
        FOREIGN KEY (professor_id) REFERENCES usuarios (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE tipo_questao(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE questoes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        questao_base_id INTEGER,
        simulado_id INTEGER,
        tipo_questao_id INTEGER,
        conteudo TEXT,
        url_imagem TEXT,
        explicacao TEXT,
        pontos INTEGER DEFAULT 1,
        versao INTEGER DEFAULT 1,
        esta_ativa INTEGER DEFAULT 1,
        professor_id INTEGER,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (questao_base_id) REFERENCES questoes (id),
        FOREIGN KEY (simulado_id) REFERENCES simulados (id),
        FOREIGN KEY (tipo_questao_id) REFERENCES tipo_questao (id),
        FOREIGN KEY (professor_id) REFERENCES usuarios (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE alternativas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        alternativa_base_id INTEGER,
        questao_id INTEGER,
        url_imagem TEXT,
        conteudo TEXT,
        esta_correta INTEGER,
        versao INTEGER DEFAULT 1,
        esta_ativa INTEGER DEFAULT 1,
        professor_id INTEGER,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (alternativa_base_id) REFERENCES alternativas (id),
        FOREIGN KEY (questao_id) REFERENCES questoes (id),
        FOREIGN KEY (professor_id) REFERENCES usuarios (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE status_simulado(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        descricao TEXT,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE tentativas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        matricula_id INTEGER,
        simulado_id INTEGER,
        status_tentativa_id INTEGER,
        hora_inicio TEXT,
        hora_fim TEXT,
        pontuacao INTEGER,
        aprovado INTEGER,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (matricula_id) REFERENCES matriculas (id),
        FOREIGN KEY (simulado_id) REFERENCES simulados (id),
        FOREIGN KEY (status_tentativa_id) REFERENCES status_simulado (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE respostas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        simulado_id INTEGER,
        questao_id TEXT,
        questao_versao INTEGER,
        alternativa_selecionada_id TEXT,
        alternativa_selecionada_versao INTEGER,
        esta_correta INTEGER,
        criado_em TEXT,
        atualizado_em TEXT,
        excluido_em TEXT,
        FOREIGN KEY (simulado_id) REFERENCES simulados (id)
      )
    ''');

    await db.execute('CREATE INDEX idx_usuarios_email ON usuarios(email)');
    await db.execute('CREATE INDEX idx_usuarios_cpf ON usuarios(cpf)');
    await db.execute(
      'CREATE INDEX idx_matriculas_estudante ON matriculas(estudante_id)',
    );
    await db.execute(
      'CREATE INDEX idx_matriculas_exame ON matriculas(exame_id)',
    );
    await db.execute(
      'CREATE INDEX idx_questoes_simulado ON questoes(simulado_id)',
    );
    await db.execute(
      'CREATE INDEX idx_alternativas_questao ON alternativas(questao_id)',
    );
    await db.execute(
      'CREATE INDEX idx_tentativas_matricula ON tentativas(matricula_id)',
    );
    await db.execute(
      'CREATE INDEX idx_respostas_simulado ON respostas(simulado_id)',
    );
  }

  Future<void> close() async {
    final db = await database;
    db.close();
  }
}

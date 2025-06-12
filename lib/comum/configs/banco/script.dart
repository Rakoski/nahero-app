final _exame = '''
CREATE TABLE exame (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  titulo TEXT,
  descricao TEXT,
  professor_id INTEGER,
  categoria TEXT,
  esta_ativo INTEGER DEFAULT 1,
  nivel_dificuldade INTEGER,
  FOREIGN KEY (professor_id) REFERENCES usuario (id)
)
''';

final _usuario = '''
CREATE TABLE usuario (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  nome TEXT,
  email TEXT UNIQUE,
  cpf TEXT,
  numero_passaporte TEXT,
  bio TEXT,
  senha TEXT,
  telefone TEXT,
  url_avatar TEXT,
  email_confirmado_em TEXT,
  id_cliente_externo TEXT,
  token_recuperacao_senha TEXT
)
''';

final _endereco = '''
CREATE TABLE endereco (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  cep TEXT,
  rua TEXT,
  numero TEXT,
  complemento TEXT,
  bairro TEXT,
  cidade TEXT,
  estado TEXT,
  pais TEXT DEFAULT 'Brasil',
  usuario_id INTEGER,
  FOREIGN KEY (usuario_id) REFERENCES usuario (id)
)
''';

final _cargo = '''
CREATE TABLE cargo (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  nome TEXT
)
''';

final _permissao = '''
CREATE TABLE permissao (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  descricao TEXT
)
''';

final _usuarioCargo = '''
CREATE TABLE usuario_cargo (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  usuario_id INTEGER,
  cargo_id INTEGER,
  criado_em TEXT,
  FOREIGN KEY (usuario_id) REFERENCES usuario (id),
  FOREIGN KEY (cargo_id) REFERENCES cargo (id),
  UNIQUE(usuario_id, cargo_id)
)
''';

final _cargoPermissao = '''
CREATE TABLE cargo_permissao (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  cargo_id INTEGER,
  permissao_id INTEGER,
  criado_em TEXT,
  FOREIGN KEY (cargo_id) REFERENCES cargo (id),
  FOREIGN KEY (permissao_id) REFERENCES permissao (id),
  UNIQUE(cargo_id, permissao_id)
)
''';

final _statusMatricula = '''
CREATE TABLE status_matricula (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  nome TEXT,
  descricao TEXT
)
''';

final _matricula = '''
CREATE TABLE matricula (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  estudante_id INTEGER NOT NULL,
  exame_id INTEGER NOT NULL,
  status_id INTEGER NOT NULL,
  FOREIGN KEY (estudante_id) REFERENCES usuario (id),
  FOREIGN KEY (exame_id) REFERENCES exame (id),
  FOREIGN KEY (status_id) REFERENCES status_matricula (id)
)
''';

final _simulado = '''
CREATE TABLE simulado (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  exame_id INTEGER,
  titulo TEXT,
  descricao TEXT,
  pontuacao_aprovacao INTEGER,
  professor_id INTEGER,
  tempo_limite INTEGER,
  nivel_dificuldade INTEGER,
  esta_ativo INTEGER DEFAULT 1,
  FOREIGN KEY (exame_id) REFERENCES exame (id),
  FOREIGN KEY (professor_id) REFERENCES usuario (id)
)
''';

final _tipoQuestao = '''
CREATE TABLE tipo_questao (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  nome TEXT
)
''';

final _questao = '''
CREATE TABLE questao (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
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
  FOREIGN KEY (questao_base_id) REFERENCES questao (id),
  FOREIGN KEY (simulado_id) REFERENCES simulado (id),
  FOREIGN KEY (tipo_questao_id) REFERENCES tipo_questao (id),
  FOREIGN KEY (professor_id) REFERENCES usuario (id)
)
''';

final _alternativa = '''
CREATE TABLE alternativa (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  alternativa_base_id INTEGER,
  questao_id INTEGER,
  url_imagem TEXT,
  conteudo TEXT,
  esta_correta INTEGER,
  versao INTEGER DEFAULT 1,
  esta_ativa INTEGER DEFAULT 1,
  professor_id INTEGER,
  FOREIGN KEY (alternativa_base_id) REFERENCES alternativa (id),
  FOREIGN KEY (questao_id) REFERENCES questao (id),
  FOREIGN KEY (professor_id) REFERENCES usuario (id)
)
''';

final _statusSimulado = '''
CREATE TABLE status_simulado (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  nome TEXT,
  descricao TEXT
)
''';

final _tentativa = '''
CREATE TABLE tentativa (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  matricula_id INTEGER,
  simulado_id INTEGER,
  status_tentativa_id INTEGER,
  hora_inicio TEXT,
  hora_fim TEXT,
  pontuacao INTEGER,
  aprovado INTEGER,
  FOREIGN KEY (matricula_id) REFERENCES matricula (id),
  FOREIGN KEY (simulado_id) REFERENCES simulado (id),
  FOREIGN KEY (status_tentativa_id) REFERENCES status_simulado (id)
)
''';

final _resposta = '''
CREATE TABLE resposta (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  criado_em TEXT,
  atualizado_em TEXT,
  excluido_em TEXT,
  simulado_id INTEGER,
  questao_id TEXT,
  questao_versao INTEGER,
  alternativa_selecionada_id TEXT,
  alternativa_selecionada_versao INTEGER,
  esta_correta INTEGER,
  FOREIGN KEY (simulado_id) REFERENCES simulado (id)
)
''';

final _indices = [
  'CREATE INDEX idx_usuario_email ON usuario (email)',
  'CREATE INDEX idx_usuario_cpf ON usuario (cpf)',
  'CREATE INDEX idx_endereco_usuario ON endereco (usuario_id)',
  'CREATE INDEX idx_matricula_estudante ON matricula (estudante_id)',
  'CREATE INDEX idx_matricula_exame ON matricula (exame_id)',
  'CREATE INDEX idx_simulado_exame ON simulado (exame_id)',
  'CREATE INDEX idx_simulado_professor ON simulado (professor_id)',
  'CREATE INDEX idx_questao_simulado ON questao (simulado_id)',
  'CREATE INDEX idx_questao_tipo ON questao (tipo_questao_id)',
  'CREATE INDEX idx_alternativa_questao ON alternativa (questao_id)',
  'CREATE INDEX idx_tentativa_matricula ON tentativa (matricula_id)',
  'CREATE INDEX idx_tentativa_simulado ON tentativa (simulado_id)',
  'CREATE INDEX idx_resposta_simulado ON resposta (simulado_id)',
];

final _dadosIniciais = [
  "INSERT INTO status_matricula (nome, descricao, criado_em) VALUES ('Ativa', 'Matrícula ativa no sistema', datetime('now'))",
  "INSERT INTO status_matricula (nome, descricao, criado_em) VALUES ('Inativa', 'Matrícula inativa no sistema', datetime('now'))",
  "INSERT INTO status_matricula (nome, descricao, criado_em) VALUES ('Suspensa', 'Matrícula temporariamente suspensa', datetime('now'))",

  "INSERT INTO status_simulado (nome, descricao, criado_em) VALUES ('Não Iniciado', 'Tentativa ainda não foi iniciada', datetime('now'))",
  "INSERT INTO status_simulado (nome, descricao, criado_em) VALUES ('Em Andamento', 'Tentativa em progresso', datetime('now'))",
  "INSERT INTO status_simulado (nome, descricao, criado_em) VALUES ('Finalizada', 'Tentativa concluída', datetime('now'))",
  "INSERT INTO status_simulado (nome, descricao, criado_em) VALUES ('Cancelada', 'Tentativa cancelada', datetime('now'))",

  "INSERT INTO tipo_questao (nome, criado_em) VALUES ('Múltipla Escolha', datetime('now'))",
  "INSERT INTO tipo_questao (nome, criado_em) VALUES ('Verdadeiro/Falso', datetime('now'))",
  "INSERT INTO tipo_questao (nome, criado_em) VALUES ('Dissertativa', datetime('now'))",
  "INSERT INTO tipo_questao (nome, criado_em) VALUES ('Preenchimento de Lacunas', datetime('now'))",

  "INSERT INTO permissao (descricao, criado_em) VALUES ('CRIAR_EXAME', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('EDITAR_EXAME', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('EXCLUIR_EXAME', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('VISUALIZAR_EXAME', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('CRIAR_SIMULADO', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('EDITAR_SIMULADO', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('EXCLUIR_SIMULADO', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('VISUALIZAR_SIMULADO', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('GERENCIAR_USUARIOS', datetime('now'))",
  "INSERT INTO permissao (descricao, criado_em) VALUES ('VISUALIZAR_RELATORIOS', datetime('now'))",

  "INSERT INTO cargo (nome, criado_em) VALUES ('Administrador', datetime('now'))",
  "INSERT INTO cargo (nome, criado_em) VALUES ('Professor', datetime('now'))",
  "INSERT INTO cargo (nome, criado_em) VALUES ('Estudante', datetime('now'))",

  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) SELECT 1, id, datetime('now') FROM permissao",

  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (2, (SELECT id FROM permissao WHERE descricao = 'CRIAR_EXAME'), datetime('now'))",
  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (2, (SELECT id FROM permissao WHERE descricao = 'EDITAR_EXAME'), datetime('now'))",
  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (2, (SELECT id FROM permissao WHERE descricao = 'VISUALIZAR_EXAME'), datetime('now'))",
  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (2, (SELECT id FROM permissao WHERE descricao = 'CRIAR_SIMULADO'), datetime('now'))",
  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (2, (SELECT id FROM permissao WHERE descricao = 'EDITAR_SIMULADO'), datetime('now'))",
  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (2, (SELECT id FROM permissao WHERE descricao = 'VISUALIZAR_SIMULADO'), datetime('now'))",
  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (2, (SELECT id FROM permissao WHERE descricao = 'VISUALIZAR_RELATORIOS'), datetime('now'))",

  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (3, (SELECT id FROM permissao WHERE descricao = 'VISUALIZAR_EXAME'), datetime('now'))",
  "INSERT INTO cargo_permissao (cargo_id, permissao_id, criado_em) VALUES (3, (SELECT id FROM permissao WHERE descricao = 'VISUALIZAR_SIMULADO'), datetime('now'))",
];

final criarTabelas = [
  _usuario,
  _endereco,
  _cargo,
  _permissao,
  _usuarioCargo,
  _cargoPermissao,
  _exame,
  _statusMatricula,
  _matricula,
  _simulado,
  _tipoQuestao,
  _questao,
  _alternativa,
  _statusSimulado,
  _tentativa,
  _resposta,
  ..._indices,
  ..._dadosIniciais,
];

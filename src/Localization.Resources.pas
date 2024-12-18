unit Localization.Resources;

interface

resourcestring
// SERVER STRINGS
  RES_MERCADOLIVRE_RECEIVED_NOTIFICATION = 'Requisição recebida de: %s';
  RES_ERROR_ON_DATA_INSERT = 'Não foi possível inserir dados: %s';
  RES_SERVER_STOPPED = 'O Servidor foi parado';
  RES_SERVER_STARTED = 'O Servidor iniciado No Host [%s] na porta [%s]';
  RES_LOGGING_VIEWER_SET = 'O local de exibição do log foi definido';
  RES_SERVER_PORT_SET = 'O Servidor está configurado para observar a porta %s';
  RES_CERTIFICATE_FILE_FOUND = 'O Arquivo de Certificado foi encontrado';
  RES_CERTIFICATE_FILE_NOT_FOUND = 'O Arquivo de Certificado não foi encontrado';
  RES_CERTIFICATE_LOADED_ACTIVE = 'O certificado foi carregado e está ativo';
  RES_CERTIFICATE_LOAD_FAILED = 'Falha ao carregar Arquivo de Certificado: %s';
  RES_KEY_FILE_NOT_FOUND = 'O Arquivo de Chave de Assinatura do certificado não foi encontrado';
  RES_LOG_STRING = '[%s] [%s]   (%s)';
  RES_LOG_STRING_STORAGE = '(%s, %s, %s)';
  RES_LOG_STRING_COLORED = '||| [%s] - [%s]';

  //TERMS
  RES_BLANK = ' ';
  RES_QUESTION_MARK = '?';
  RES_LABEL_PORT = 'Porta';
  RES_USE_SSL_LABEL = 'Usar SSL';
  RES_MINLOGLEVEL_LABEL = 'Nível Mínimo de Log';
  RES_DATABASE = 'Banco de Dados';
  RES_USERNAME = 'Nome de Usuário';
  RES_PASSWORD = 'Senha';
  RES_HOST = 'Endereço do Servidor';
  RES_CERTIFICATE = 'Certificado';
  RES_ROOT_CERTIFICATE = 'Certificado Raíz';
  RES_KEY_FILE = 'Chave Privada';
  RES_SETTINGS = 'Configurações';
  RES_SAVE = 'Salvar';
  RES_OPEN = 'Abrir';
  RES_EXCEPTION_FILE_DOESNT_EXIST = 'O Arquivo Não Existe';
  RES_DISCARD_CHAGNES_QUERY = 'Você quer descartar todas as modificações?';
  RES_MAX_CONCURRENT_CONNECTIONS = 'Conexões Simultâneas';
  RES_ARE_YOU_SURE_YOU_WANT = 'Você tem certeza que quer';
  RES_ARE_YOU_SURE = 'Você tem certeza?';
  RES_KILL_SERVER = 'Encerrar o Servidor';
  RES_START_RUNNING = 'Iniciar em Execução';
  RES_VERIFY_CONFIG_PATH = 'Verificar Caminho do Arquivo de Configurações';


// MAIN FORM
  RES_START_SERVER_BUTTON = 'Iniciar Servidor';
  RES_STOP_SERVER_BUTTON = 'Parar Servidor';
  RES_MAINFORM_CAPTION = 'Serviço de Notificações de Marketplaces';
  RES_TRAY_HINT = 'Serviço de Notificações';
  RES_TRAY_BALLON_HINT_HIDDEN = 'Aplicativo Escondido na System Tray';
  RES_TRAY_BALLON_TITLE = 'Serviço de Notificações';
  RES_MAINMENU_TOOLS_BUTTON = 'Ferramentas';
  RES_MAINMENU_SETTINGS_BUTTON = 'Configurações';
  RES_MAINMENU_REFRESHSETTINGS_BUTTON = 'Reaplicar Configurações';
  RES_MAINMENU_TESTS_BUTTON = 'Testes';
  RES_MAINMENU_DATABASEFIRETEST_BUTTON = 'Teste de Conexão do Banco de Dados';
  RES_MAINMENU_SSLSTARTTEST_BUTTON = 'Teste de Ativação do Certificado SSL';

  RES_EXCEPTION_SSL_DISABLED = 'Uso de SSL está desabilitado. Habilite nas Configurações';
  RES_EXCEPTION_REFRESH_SETTINGS_WITH_ACTIVE_SERVER = 'Não é possível aplicar configuração com o servidor ativo';
  RES_DATABASE_ERROR = 'Erro de Banco de Dados';
  RES_DATABASE_FIRETEST_SUCCESSFUL = 'Teste de inicialização de banco de dados bem sucedido!';
  RES_APPLICATION_LOG = 'Log do Aplicativo';
  RES_VIEW_LOG_PROPERTIES = 'Ver Propriedades do Logger';
  RES_THREAD_ERROR = 'Erro de Thread: %s';
  RES_STARTUP_ERROR = 'Erro de Inicialização: %s';

// GENERAL STRING TEMPLATES
  RES_LOG_FILENAME = 'LOG-%s.txt';

implementation

end.

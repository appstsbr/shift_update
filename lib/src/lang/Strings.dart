/// class [Strings] é reposanvel pelo mapeamento de strings que são
/// usadas dentro dos templaites

class Strings {
  static Strings? _instance;

  Strings._() {}

  factory Strings() {
    if (_instance == null) {
      print("instance null");
      _instance = Strings._();
    }
    return _instance!;
  }

  Map<String, dynamic> map = {
    "login_screen": {
      "login": "Entrar",
      "privacypolicy": "Politica de privacidade",
      "form_user": "Usuário DC",
      "form_pass": "Senha",
      "validation_user": "Por favor digite seu usuário",
      "validation_pass": "Por favor digite sua senha"
    },
    "errors": {
      "error_login": "Usuário ou senha incorretos",
      "error_server": "Erro ao se conectar ao servidor",
      "error_unknow": "Erro desconhecido",
      "error_token": "Token inválido",
      "error_upload_image": "Erro ao enviar imagem",
      "error": "Ocorreu algum erro..."
    },
    "titles": {
      "notifications": "Notificações",
      "events": "Eventos",
      "profile": "Perfil",
      "all": "Todos",
      "opened": "Abertos",
      "done": "Concluídos",
      "details": "Detalhes",
      "history": "Histórico",
      "participants": "Participantes"
    },
    "event_screen": {
      "message_empty": "Nenhum evento encontrado",
      "message_empty_opened": "Nenhum evento está aberto",
      "message_empty_done": "Nenhum evento foi concluído",
      "message_no_details": "Essa mensagem não tem detalhes",
      "event_1": "Aberto",
      "event_3": "Atualização",
      "event_4": "Ticket alterado",
      "event_5": "Concluído",
      "event_6": "Chat",
      "event_other": "Outro",
      "informative": "Informativo",
      "notification_read": "Todas notificações visualizadas",
      "notification_not_read": "Notificações não visualizadas",
      "chat_write_message": "Digite sua mensagem",
      "chat_imagem": "Imagem",
      "chat_done":
          "Chat não está mais disponível, pois o evento foi encerrado.",
      "chat_disable": "Chat não liberado"
    },
    "detail_screen": {
      "info_event": "Informações",
      "last_att": "Ultima atualização",
      "time": "Horário",
      "event": "Evento",
      "description": "Descrição",
      "type": "Tipo",
      "ticket": "Ticket",
      "opened": "Aberto em"
    },
    "profile_screen": {
      "change_pass": "Trocar senha",
      "logout": "Sair",
      "email": "E-mail",
      "phone": "Telefone",
      "message_logout": "Deseja mesmo sair da sua conta",
      "no": "Não",
      "yes": "Sim",
      "validation_image":
          "O formato da imagem deve ser .jpg, .jpeg, .png ou .bmp",
      "validation_new_pass_empty": "Por favor digite a nova senha",
      "validation_new_pass_length": "Sua senha deve ter pelos menos 6 dígitos",
      "validation_new_pass_confirm_empty": "Repita sua nova senha",
      "validation_new_pass_confirm_equals": "Repita a nova senha corretamente",
      "form_new_pass": "Nova senha",
      "form_new_pass_confirm": "Confirmar nova senha",
      "message_change_pass": "Sua senha foi alterada com sucesso",
      "image_gallery": "Galeria",
      "image_camera": "Câmera",
      "cancel": "Cancelar"
    },
    "notification_screen": {
      "message_empty": "Nenhum notificação",
      "message_remove": "Notificação removida"
    },
    "group_screen": {
      "participants": "Participantes",
      "details": "Detalhes do grupo",
      "name": "Nome do grupo",
      "search": "Procure um usuário",
      "empty": "Nenhum usuário",
      "edit_part": "Gerenciar participantes",
      "new_group": "Novo grupo",
      "empty_groups": "Nenhum grupo",
      "exit_group": "Sair do grupo",
      "exit_group_confirm": "Deseja mesmo sair do grupo?",
      "delete_group": "Deletar grupo",
      "delete_group_confirm": "Deseja mesmo deletar esse grupo?",
      "add_admin_permission": "Colocar como administrador",
      "remove_admin_permission": "Retirar permissão administrador"
    }
  };
  late _Strings titles = _Strings({});
  late _Strings errors = _Strings({});
  late _Strings loginScreen = _Strings({});
  late _Strings eventScreen = _Strings({});
  late _Strings detailScreen = _Strings({});
  late _Strings profileScreen = _Strings({});
  late _Strings notificationScreen = _Strings({});
  late _Strings groupScreen = _Strings({});

  void init({required Map<String, dynamic> map}) {
    if (map == null) map = this.map;
    titles = _Strings(map["titles"]);
    errors = _Strings(map["errors"]);
    loginScreen = _Strings(map["login_screen"]);
    eventScreen = _Strings(map["event_screen"]);
    detailScreen = _Strings(map["detail_screen"]);
    profileScreen = _Strings(map["profile_screen"]);
    notificationScreen = _Strings(map["notification_screen"]);
    groupScreen = _Strings(map["group_screen"]);
  }
}

class _Strings {
  Map<String, dynamic> data;
  _Strings(this.data);
  String get(String key) {
    if (data == null) return "";
    if (data.containsKey(key))
      return data[key];
    else
      return "";
  }
}

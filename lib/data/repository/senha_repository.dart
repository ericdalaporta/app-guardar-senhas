import '../model/senha.dart';
import '../service/senha_service.dart';

/// REPOSITORY
///
/// Responsável por organizar o acesso aos dados de senhas.
/// O Controller não conversa diretamente com o Service.
/// Ele fala com o Repository.
class SenhaRepository {
  // Guarda a instância do service que será usada pelo repository.
  final SenhaService service;

  // Construtor do repository.
  SenhaRepository({
    // O service é obrigatório porque o repository depende dele para funcionar.
    required this.service,
  });

  /// Lista todas as senhas.
  List<Senha> listar() {
    // Pede ao service a lista de todas as senhas.
    // O repository está servindo como intermediário entre controller e service.
    return service.getAll();
  }

  /// Adiciona uma nova senha.
  void adicionar(Senha senha) {
    // Envia a senha para o service inserir na fonte de dados.
    service.insert(senha);
  }

  /// Atualiza uma senha.
  void atualizar(Senha senha) {
    // Envia a senha atualizada para o service.
    service.update(senha);
  }

  /// Remove uma senha.
  void remover(String id) {
    // Pede ao service a exclusão da senha com o id informado.
    service.delete(id);
  }

  /// Busca uma senha pelo id.
  Senha? buscarPorId(String id) {
    // Solicita ao service uma senha específica pelo id.
    return service.findById(id);
  }
}

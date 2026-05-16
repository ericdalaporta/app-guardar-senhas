import '../model/senha.dart';

class SenhaService {
  // Lista privada que guarda as senhas apenas enquanto o app está em execução.
  final List<Senha> _senhas = [];

  /// Retorna uma cópia da lista de senhas.
  List<Senha> getAll() {
    // copia da lista _senhas e retornar uma nova lista com os mesmos elementos.
    // Isso evita expor diretamente a lista interna _senhas.
    // se quem recebeu alterar, não irá alterar a lista original
    return List<Senha>.from(_senhas);
  }

  /// Adiciona uma nova senha na memória.
  void insert(Senha senha) {
    // Adiciona o objeto senha ao final da lista.
    _senhas.add(senha);
  }

  /// Atualiza uma senha existente com base no id.
  void update(Senha senhaAtualizada) {
    // procura na lista _senhas o índice do primeiro item cujo id seja igual
    // ao id de senhaAtualizada, e guarde esse índice em index
    final index =
        _senhas.indexWhere((senha) => senha.id == senhaAtualizada.id);

    // Se encontrou a senha, o índice será diferente de -1.
    if (index != -1) {
      // Substitui a senha antiga pelo novo objeto atualizado.
      _senhas[index] = senhaAtualizada;
    }
  }

  /// Remove uma senha pelo id.
  void delete(String id) {
    // Remove da lista toda senha cujo id seja igual ao id informado.
    _senhas.removeWhere((senha) => senha.id == id);
  }

  /// Busca uma senha pelo id.
  /// "?" podendo retornar um objeto Senha ou null
  Senha? findById(String id) {
    try {
      // Retorna a primeira senha cujo id seja igual ao informado.
      return _senhas.firstWhere((senha) => senha.id == id);
    } catch (_) {
      // Se não encontrar nenhuma senha, firstWhere lança erro.
      // Nesse caso, retorna null.
      return null;
    }
  }
}

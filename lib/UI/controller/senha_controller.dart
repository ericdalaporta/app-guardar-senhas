import 'package:flutter/material.dart';

import '../../data/model/senha.dart';
import '../../data/repository/senha_repository.dart';

/// CONTROLLER
/// Controla a lógica da tela de gerenciamento de senhas
/// ChangeNotifier é uma classe do Flutter usada para avisar a
/// interface quando algum dado mudou.
class SenhaController extends ChangeNotifier {
  // O controller depende do repository para acessar e alterar os dados.
  final SenhaRepository repository;

  // Construtor do controller.
  SenhaController({
    // O repository é obrigatório porque o controller precisa dele para funcionar
    required this.repository,
  });

  // Lista privada que representa o estado atual das senhas na interface.
  List<Senha> _senhas = [];

  // Getter público para permitir que a interface leia a lista de senhas.
  List<Senha> get senhas => _senhas;

  /// Carrega as senhas do repository para a interface.
  void carregarSenhas() {
    // Busca a lista atual de senhas no repository.
    _senhas = repository.listar();

    // notifyListeners() é o ponto central da reatividade neste controller.
    //
    // Quando este método é chamado:
    // - o Provider percebe que houve mudança no controller;
    // - widgets que estão ouvindo este controller são avisados;
    // - a interface pode ser reconstruída automaticamente.
    //
    // Em outras palavras:
    // sem notifyListeners(), a tela não saberia que os dados mudaram.
    notifyListeners();
  }

  /// Adiciona uma nova senha.
  void adicionarSenha({
    required String servico,
    required String nome,
    required String senha,
  }) {
    // Cria um novo objeto Senha a partir dos dados recebidos da interface.
    final novaSenha = Senha(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      servico: servico,
      nome: nome,
      senha: senha,
    );

    // Envia a nova senha para o repository.
    repository.adicionar(novaSenha);
    carregarSenhas();
  }

  /// Atualiza uma senha existente.
  void atualizarSenha({
    required String id,
    required String servico,
    required String nome,
    required String senha,
  }) {
    // Cria um novo objeto representando a senha já atualizada.
    final senhaAtualizada = Senha(
      id: id,
      servico: servico,
      nome: nome,
      senha: senha,
    );

    // Envia a senha atualizada para o repository.
    repository.atualizar(senhaAtualizada);
    carregarSenhas();
  }

  /// Remove uma senha.
  void removerSenha(String id) {
    // Pede ao repository a exclusão da senha.
    repository.remover(id);

    // Recarrega a lista e notifica os ouvintes.
    carregarSenhas();
  }

  /// Busca uma senha pelo id.
  Senha? buscarSenhaPorId(String id) {
    // Retorna uma senha específica consultando o repository.
    return repository.buscarPorId(id);
  }
}

/*
========================================================================
ONDE ESTÁ A REATIVIDADE NESTE CONTROLLER
========================================================================

1) A classe herda de ChangeNotifier:
   class SenhaController extends ChangeNotifier

   Isso torna o controller "observável".

2) A interface lê este controller pelo Provider.

3) Sempre que os dados mudam, o controller chama:
   notifyListeners();

4) Quando notifyListeners() é executado:
   - widgets ouvintes são avisados
   - a tela pode reconstruir automaticamente

Fluxo:
usuário interage -> controller altera dados -> notifyListeners() -> UI atualiza
*/

import 'package:flutter/material.dart'; 
//disponibilizar objetos e permitir reatividade entre controller e interface.
import 'package:provider/provider.dart'; 

// repositório-organiza o acesso aos dados.
import 'data/repository/senha_repository.dart'; 
// serviço- responsável pelo acesso real à fonte de dados
import 'data/service/senha_service.dart'; 
//controller-a lógica e o estado observado pela interface
import 'ui/controller/senha_controller.dart'; 
//página principal- exibida na tela inicial do app
import 'ui/page/senha_page.dart'; 


void main() {

  runApp(const MyApp());
  // O widget passado para runApp se torna a raiz da árvore de widgets.  
}

//digite stl -->>clique em StatelessWidget<<---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // =========================================================
    // Montagem das dependências da arquitetura
    // =========================================================
    //// objetos principais da arquitetura:
    // Service -> Repository -> Controller
    //Além da separação das reponsabilidades estna a injeção de 
    //dependências. O objetivo é deixar claro quem depende de quem.

    final senhaService = SenhaService();
    // O service é a camada que executa o acesso real aos dados
    // em memória,arqivo, SQLite, Firebase.

    final senhaRepository = SenhaRepository(service: senhaService);
    // O repository recebe o service por injeção de dependência.
    // Isso significa que ele é responsável por organizar o acesso aos dados 
    // O repository ajuda a organizar o acesso aos dados e 
    //a desacoplar a UI da fonte real de dados(service).
      
    return MultiProvider(
      // MultiProvider permite registrar vários providers de uma vez
      providers: [
        ChangeNotifierProvider<SenhaController>(
          // ChangeNotifierProvider é um provider especializado em objetos
          // que seguem o padrão ChangeNotifier
          // Em outras palavras:
          // - o controller guarda o estado;
          // - quando o estado muda, ele chama notifyListeners();
          // - os widgets que estão ouvindo esse controller são reconstruídos.          
          create: (_) => SenhaController(
            repository: senhaRepository,
            // Cria o SenhaController e injeta nele o repositório.
            // Assim, o controller não acessa dados diretamente;
            // ele conversa com o repository, mantendo a arquitetura organizada.
          )..carregarSenhas(),          
          // O operador .. é chamado de cascade notation
          //permite chamar método ..carregarSenhas().
          //
          // Então, este trecho:
          // SenhaController(...)..carregarSenhas()
          // 1) cria o controller
          // 2) chama carregarSenhas()
          // 3) retorna o próprio controller para o provider
          //
          // Se dentro de carregarSenhas() houver atualização de estado e
          // chamada de notifyListeners(), a interface poderá reagir automaticamente
          //
          // Importante:
          // A REATIVIDADE COMPLETA não acontece somente aqui.
          // Aqui ela é PREPARADA.
          // Ela se completa quando:
          // - o SenhaController herda de ChangeNotifier
          // - o controller chama notifyListeners()
          // - a interface usa context.watch, Consumer ou Selector
        ),                
      ],

      child: MaterialApp(
      // MaterialApp é o widget principal de configuração visual do app.

        debugShowCheckedModeBanner: false,
        // Remove a faixa vermelha de DEBUG no canto da aplicação.

        title: 'Gerenciador de Senhas',
        // Define o título do aplicativo.

        theme: ThemeData(
          // ThemeData define a aparência global do aplicativo:
          colorSchemeSeed: Colors.blue,
          // Define azul como cor base para gerar o esquema de cores do app.
        ),

        home: const SenhaPage(),

      ),
    );
  }
}
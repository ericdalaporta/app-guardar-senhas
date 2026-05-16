import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/model/senha.dart';
import '../controller/senha_controller.dart';

class SenhaPage extends StatefulWidget {
  const SenhaPage({super.key});

  @override
  State<SenhaPage> createState() => _SenhaPageState();
}

class _SenhaPageState extends State<SenhaPage> {
  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SenhaController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Senhas'),
        centerTitle: true,
      ),
      body: controller.senhas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma senha cadastrada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: controller.senhas.length,
              itemBuilder: (context, index) {
                final senha = controller.senhas[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.lock),
                    ),
                    title: Text(senha.servico),
                    subtitle: Text(senha.nome),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Editar',
                          onPressed: () {
                            _abrirFormulario(context, senha: senha);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: 'Excluir',
                          onPressed: () {
                            _confirmarExclusao(context, senha);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _abrirFormulario(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _abrirFormulario(BuildContext context, {Senha? senha}) {
    final servicoController = TextEditingController(
      text: senha?.servico ?? '',
    );
    final nomeController = TextEditingController(
      text: senha?.nome ?? '',
    );
    final senhaController = TextEditingController(
      text: senha?.senha ?? '',
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            senha == null ? 'Nova Senha' : 'Editar Senha',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: servicoController,
                  decoration: const InputDecoration(
                    labelText: 'Serviço',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: senhaController,
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final servico = servicoController.text.trim();
                final nome = nomeController.text.trim();
                final senhaText = senhaController.text.trim();

                if (servico.isEmpty || nome.isEmpty || senhaText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Preencha todos os campos.'),
                    ),
                  );
                  return;
                }

                final controller = context.read<SenhaController>();

                if (senha == null) {
                  controller.adicionarSenha(
                    servico: servico,
                    nome: nome,
                    senha: senhaText,
                  );
                } else {
                  controller.atualizarSenha(
                    id: senha.id,
                    servico: servico,
                    nome: nome,
                    senha: senhaText,
                  );
                }

                Navigator.pop(dialogContext);
              },
              child: Text(
                senha == null ? 'Salvar' : 'Atualizar',
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmarExclusao(BuildContext context, Senha senha) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: Text(
            'Deseja realmente excluir a senha de "${senha.servico}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<SenhaController>().removerSenha(senha.id);
                Navigator.pop(dialogContext);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}

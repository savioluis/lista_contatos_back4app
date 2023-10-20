import 'dart:io';

import 'package:lista_contatos/model/contato_model.dart';
import 'package:lista_contatos/pages/contato_page.dart';
import 'package:lista_contatos/repository/contato_repository.dart';
import 'package:flutter/material.dart';

class ListaContatosPage extends StatefulWidget {
  final ContatoRepository repository;

  ListaContatosPage({required this.repository});

  @override
  _ListaContatosPageState createState() => _ListaContatosPageState();
}

class _ListaContatosPageState extends State<ListaContatosPage> {
  late List<Contato> contatos;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContatos();
  }

  _loadContatos() async {
    contatos = await widget.repository.buscarTodosContatos();
    setState(() {
      isLoading = false;
    });
  }

  _deleteContato(String objectId) async {
    await widget.repository.deletarContato(objectId);
    _loadContatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Contatos"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contatos.length,
              itemBuilder: (context, index) {
                final contato = contatos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2, color: Colors.black54),
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    title: Text(contato.nome),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contato.telefone),
                        Text('${contato.idade} anos'),
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundImage: contato.imagem.isNotEmpty
                          ? FileImage(File(contato
                              .imagem)) // Aqui foi alterado para FileImage
                          : null,
                      child: contato.imagem.isNotEmpty
                          ? null
                          : const Icon(Icons.person, color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _deleteContato(contato.objectId);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContatoPage(
                            contato: contato,
                            repository: widget.repository,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContatoPage(
                repository: widget.repository,
              ),
            ),
          ).then((_) => _loadContatos()); // Recarrega contatos após voltar
        },
      ),
    );
  }
}

import 'dart:io';

import 'package:lista_contatos/cadastrar_contato.dart';
import 'package:lista_contatos/contato.dart';
import 'package:flutter/material.dart';

class ContactsListPage extends StatefulWidget {
  final ContactRepository repository;

  ContactsListPage({required this.repository});

  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
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
                  padding: const EdgeInsets.only(top: 16.0),
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
                          builder: (context) => ContactRegistrationPage(
                            contact: contato,
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
              builder: (context) => ContactRegistrationPage(
                repository: widget.repository,
              ),
            ),
          ).then((_) => _loadContatos()); // Recarrega contatos após voltar
        },
      ),
    );
  }
}

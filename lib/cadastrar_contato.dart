import 'dart:io';
import 'package:lista_contatos/contato.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ContactRegistrationPage extends StatefulWidget {
  final Contato? contact;
  final ContactRepository repository;

  const ContactRegistrationPage({this.contact, required this.repository});

  @override
  _ContactRegistrationPageState createState() =>
      _ContactRegistrationPageState();
}

class _ContactRegistrationPageState extends State<ContactRegistrationPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  String? _imagePath;
  int _age = 1;

  final _phoneRegex =
      RegExp(r"^\([1-9]{2}\) (?:[2-8]|9[1-9])[0-9]{3}-[0-9]{4}$");

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String newPath =
          '${directory.path}/${DateTime.now().toIso8601String()}.png';
      final File newImage = await File(image.path).copy(newPath);

      setState(() {
        _imagePath = newImage.path;
      });
    }
  }

  Future<void> _chooseImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory directory = await getApplicationDocumentsDirectory();
      final String newPath =
          '${directory.path}/${DateTime.now().toIso8601String()}.png';
      final File newImage = await File(image.path).copy(newPath);

      setState(() {
        _imagePath = newImage.path;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      _nameController.text = widget.contact!.nome;
      _phoneController.text = widget.contact!.telefone;
      _age = widget.contact!.idade;
      _imagePath = widget.contact!.imagem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact == null ? "Cadastro de Contato" : "Editar Contato",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_imagePath != null)
                Image.file(
                  File(_imagePath!),
                  width: 100,
                  height: 100,
                ),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text("Capturar foto"),
              ),
              ElevatedButton(
                onPressed: _chooseImageFromGallery,
                child: const Text("Escolher da galeria"),
              ),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  } else if (!_phoneRegex.hasMatch(value)) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),
              Slider(
                value: _age.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _age = value.toInt();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Idade selecionada com sucesso')),
                    );
                  });
                },
                min: 1,
                max: 100,
                divisions: 99,
                label: '$_age anos',
              ),
              ElevatedButton(
                onPressed: () async {
                  final newContact = Contato(
                    objectId: widget.contact?.objectId ?? '',
                    nome: _nameController.text,
                    imagem: _imagePath ?? "",
                    idade: _age,
                    telefone: _phoneController.text,
                  );

                  if (widget.contact == null) {
                    await widget.repository.novoContato(newContact);
                  } else {
                    await widget.repository
                        .atualizarContato(widget.contact!.objectId, newContact);
                  }

                  Navigator.pop(context);
                },
                child: Text(widget.contact == null ? "Salvar" : "Atualizar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

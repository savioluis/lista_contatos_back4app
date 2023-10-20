import 'dart:io';
import 'package:lista_contatos/model/contato_model.dart';
import 'package:lista_contatos/repository/contato_repository.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ContatoPage extends StatefulWidget {
  final Contato? contato;
  final ContatoRepository repository;

  const ContatoPage({this.contato, required this.repository});

  @override
  _ContatoPageState createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  String? _imagePath;
  int _idade = 1;

  final _telefoneRegex =
      RegExp(r"^\([1-9]{2}\) (?:[2-8]|9[1-9])[0-9]{3}-[0-9]{4}$");

  Future<void> _escolherImagemCamera() async {
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

  Future<void> _escolherImagemGaleria() async {
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
    if (widget.contato != null) {
      _nomeController.text = widget.contato!.nome;
      _telefoneController.text = widget.contato!.telefone;
      _idade = widget.contato!.idade;
      _imagePath = widget.contato!.imagem;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contato == null ? "Cadastro de Contato" : "Editar Contato",
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
                onPressed: _escolherImagemCamera,
                child: const Text("Capturar foto"),
              ),
              ElevatedButton(
                onPressed: _escolherImagemGaleria,
                child: const Text("Escolher da galeria"),
              ),
              TextField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  } else if (!_telefoneRegex.hasMatch(value)) {
                    return 'Telefone inválido';
                  }
                  return null;
                },
              ),
              Slider(
                value: _idade.toDouble(),
                onChanged: (double value) {
                  setState(() {
                    _idade = value.toInt();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Idade selecionada com sucesso')),
                    );
                  });
                },
                min: 1,
                max: 100,
                divisions: 99,
                label: '$_idade anos',
              ),
              ElevatedButton(
                onPressed: () async {
                  final novoContato = Contato(
                    objectId: widget.contato?.objectId ?? '',
                    nome: _nomeController.text,
                    imagem: _imagePath ?? "",
                    idade: _idade,
                    telefone: _telefoneController.text,
                  );

                  if (widget.contato == null) {
                    await widget.repository.novoContato(novoContato);
                  } else {
                    await widget.repository.atualizarContato(
                        widget.contato!.objectId, novoContato);
                  }

                  Navigator.pop(context);
                },
                child: Text(widget.contato == null ? "Salvar" : "Atualizar"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

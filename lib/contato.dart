import 'package:lista_contatos/http_provider.dart';

class Contato {
  final String objectId;
  final String nome;
  final String imagem;
  final int idade;
  final String telefone;

  Contato({
    required this.objectId,
    required this.nome,
    required this.imagem,
    required this.idade,
    required this.telefone,
  });

  factory Contato.fromJson(Map<String, dynamic> json) {
    return Contato(
      objectId: json['objectId'],
      nome: json['nome'] ?? "",
      imagem: json['imagem'] ?? "",
      idade: json['idade'] ?? 0,
      telefone: json['telefone'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'imagem': imagem,
      'idade': idade,
      'telefone': telefone,
    };
  }
}

class ContactRepository {
  final HttpProvider _httpProvider;

  ContactRepository(this._httpProvider);

  Future<Contato> novoContato(Contato contact) async {
    final response =
        await _httpProvider.post('classes/contatos', data: contact.toJson());
        print(response.data);
    return Contato.fromJson(response.data);
  }

  Future<List<Contato>> buscarTodosContatos() async {
    final response = await _httpProvider.get('classes/contatos');
    final List results = response.data['results'];
    return results.map((json) => Contato.fromJson(json)).toList();
  }

  Future<void> atualizarContato(String objectId, Contato contact) async {
    await _httpProvider.put('classes/contatos/$objectId',
        data: contact.toJson());
  }

  Future<void> deletarContato(String objectId) async {
    await _httpProvider.delete('classes/contatos/$objectId');
  }
}

import 'package:lista_contatos/services/http_provider.dart';

import '../model/contato_model.dart';

class ContatoRepository {
  final HttpProvider _httpProvider;

  ContatoRepository(this._httpProvider);

  Future<Contato> novoContato(Contato contact) async {
    final response =
        await _httpProvider.post('classes/contatos', data: contact.toJson());
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

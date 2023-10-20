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

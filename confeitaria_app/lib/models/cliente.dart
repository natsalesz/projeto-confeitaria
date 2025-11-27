class Cliente {
  int? id;
  String nome;
  String email;
  String telefone;
  String? dataCriacao;

  Cliente({
    this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    this.dataCriacao,
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      telefone: json['telefone'],
      dataCriacao: json['data_criacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
    };
  }
}
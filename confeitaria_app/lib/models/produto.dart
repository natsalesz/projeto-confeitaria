class Produto {
  int? id;
  String nome;
  String descricao;
  double preco;
  String categoria;
  String imgUrl;
  int estoque;
  String? dataCriacao;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.categoria,
    required this.imgUrl,
    required this.estoque,
    this.dataCriacao,
  });

  factory Produto.fromJson(Map<String, dynamic> json) {
    return Produto(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      preco: double.parse(json['preco'].toString()),
      categoria: json['categoria'],
      imgUrl: json['img_url'],
      estoque: json['estoque'],
      dataCriacao: json['data_criacao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'categoria': categoria,
      'img_url': imgUrl,
      'estoque': estoque,
    };
  }

  String get iconeCategoria {
    switch (categoria) {
      case 'bolo':
        return '🎂';
      case 'docinho':
        return '🍬';
      case 'kit':
        return '🎁';
      default:
        return '📦';
    }
  }

  String get nomeCategoria {
    switch (categoria) {
      case 'bolo':
        return 'Bolo';
      case 'docinho':
        return 'Docinho';
      case 'kit':
        return 'Kit Festa';
      default:
        return 'Produto';
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/produto.dart';
import '../models/cliente.dart';
import '../models/pedido.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:5000';

  // Produtos
  static Future<List<Produto>> listarProdutos() async {
    final response = await http.get(Uri.parse('$baseUrl/produtos'));
    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return dados.map((json) => Produto.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar produtos');
    }
  }

  static Future<Produto> obterProduto(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/produtos/$id'));
    if (response.statusCode == 200) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar produto');
    }
  }

  static Future<Produto> criarProduto(Produto produto) async {
    final response = await http.post(
      Uri.parse('$baseUrl/produtos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode == 201) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar produto');
    }
  }

  static Future<Produto> atualizarProduto(Produto produto) async {
    final response = await http.put(
      Uri.parse('$baseUrl/produtos/${produto.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(produto.toJson()),
    );
    if (response.statusCode == 200) {
      return Produto.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar produto');
    }
  }

  static Future<void> excluirProduto(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/produtos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir produto');
    }
  }

  // Clientes
  static Future<List<Cliente>> listarClientes() async {
    final response = await http.get(Uri.parse('$baseUrl/clientes'));
    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return dados.map((json) => Cliente.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar clientes');
    }
  }

  static Future<Cliente> obterCliente(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/clientes/$id'));
    if (response.statusCode == 200) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar cliente');
    }
  }

  static Future<Cliente> criarCliente(Cliente cliente) async {
    final response = await http.post(
      Uri.parse('$baseUrl/clientes'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode == 201) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar cliente');
    }
  }

  static Future<Cliente> atualizarCliente(Cliente cliente) async {
    final response = await http.put(
      Uri.parse('$baseUrl/clientes/${cliente.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(cliente.toJson()),
    );
    if (response.statusCode == 200) {
      return Cliente.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar cliente');
    }
  }

  static Future<void> excluirCliente(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/clientes/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir cliente');
    }
  }

  // Pedidos
  static Future<List<Pedido>> listarPedidos() async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos'));
    if (response.statusCode == 200) {
      final List<dynamic> dados = json.decode(response.body);
      return dados.map((json) => Pedido.fromJson(json)).toList();
    } else {
      throw Exception('Falha ao carregar pedidos');
    }
  }

  static Future<Pedido> obterPedido(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/pedidos/$id'));
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar pedido');
    }
  }

  static Future<Pedido> criarPedido(Pedido pedido) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pedidos'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(pedido.toJson()),
    );
    if (response.statusCode == 201) {
      return Pedido.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao criar pedido');
    }
  }

  static Future<Pedido> atualizarPedido(Pedido pedido) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pedidos/${pedido.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'status': pedido.status}),
    );
    if (response.statusCode == 200) {
      return Pedido.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao atualizar pedido');
    }
  }

  static Future<void> excluirPedido(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pedidos/$id'));
    if (response.statusCode != 200) {
      throw Exception('Falha ao excluir pedido');
    }
  }
}
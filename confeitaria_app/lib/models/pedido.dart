import 'package:flutter/material.dart';

class Pedido {
  int? id;
  int clienteId;
  String? dataPedido;
  double valorTotal;
  String status;
  List<dynamic> itens;
  String? nomeCliente;

  Pedido({
    this.id,
    required this.clienteId,
    this.dataPedido,
    required this.valorTotal,
    required this.status,
    required this.itens,
    this.nomeCliente,
  });

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      clienteId: json['cliente_id'],
      dataPedido: json['data_pedido'],
      valorTotal: double.parse(json['valor_total'].toString()),
      status: json['status'],
      itens: json['itens'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cliente_id': clienteId,
      'itens': itens,
    };
  }

  String get statusFormatado {
    switch (status) {
      case 'pendente':
        return 'Pendente';
      case 'confirmado':
        return 'Confirmado';
      case 'entregue':
        return 'Entregue';
      default:
        return status;
    }
  }

  Color get corStatus {
    switch (status) {
      case 'pendente':
        return Colors.orange;
      case 'confirmado':
        return Colors.blue;
      case 'entregue':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // ✅ GETTER dataFormatada QUE ESTAVA FALTANDO
  String get dataFormatada {
    if (dataPedido == null) return 'Data não informada';
    
    try {
      DateTime data = DateTime.parse(dataPedido!);
      return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year} às ${data.hour.toString().padLeft(2, '0')}:${data.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dataPedido!;
    }
  }

 int get quantidadeTotalItens {
    if (itens.isEmpty) return 0;
    
    int total = 0;
    for (var item in itens) {
      if (item is Map<String, dynamic>) {
        total += (item['quantidade'] as num).toInt();
      }
    }
    return total;
  }

  // ✅ GETTER nomesProdutos QUE ESTAVA FALTANDO
  String get nomesProdutos {
    if (itens.isEmpty) return 'Nenhum item';
    
    List<String> nomes = [];
    for (var item in itens) {
      if (item is Map<String, dynamic>) {
        nomes.add(item['produto_nome'] ?? 'Produto desconhecido');
      }
    }
    
    if (nomes.length > 2) {
      return '${nomes.take(2).join(', ')} e +${nomes.length - 2}';
    }
    return nomes.join(', ');
  }

  // Método para calcular o total do pedido
  double calcularTotal() {
    if (itens.isEmpty) return 0.0;
    
    double total = 0.0;
    for (var item in itens) {
      if (item is Map<String, dynamic>) {
        total += (item['quantidade'] ?? 0) * (item['preco_unitario'] ?? 0.0);
      }
    }
    return total;
  }
}
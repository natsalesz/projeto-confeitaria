import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/pedido.dart';
import 'package:confeitaria_app/services/api_service.dart';

class DetalhesPedido extends StatefulWidget {
  final Pedido pedido;

  const DetalhesPedido({super.key, required this.pedido});

  @override
  State<DetalhesPedido> createState() => _DetalhesPedidoState();
}

class _DetalhesPedidoState extends State<DetalhesPedido> {
  late Pedido _pedido;

  @override
  void initState() {
    super.initState();
    _pedido = widget.pedido;
  }

  Future<void> _atualizarStatus(String novoStatus) async {
    try {
      final pedidoAtualizado = await ApiService.atualizarPedido(
        Pedido(
          id: _pedido.id,
          clienteId: _pedido.clienteId,
          valorTotal: _pedido.valorTotal,
          status: novoStatus,
          itens: _pedido.itens,
        ),
      );

      setState(() {
        _pedido = pedidoAtualizado;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Status atualizado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar status: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedido #${_pedido.id}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status do Pedido
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status do Pedido',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _pedido.corStatus,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _pedido.statusFormatado,
                          style: TextStyle(
                            fontSize: 16,
                            color: _pedido.corStatus,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          onSelected: _atualizarStatus,
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'pendente',
                              child: Text('Marcar como Pendente'),
                            ),
                            const PopupMenuItem(
                              value: 'confirmado',
                              child: Text('Marcar como Confirmado'),
                            ),
                            const PopupMenuItem(
                              value: 'entregue',
                              child: Text('Marcar como Entregue'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Informações do Pedido
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informações do Pedido',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Data: ${_pedido.dataFormatada}'),
                    Text('Cliente ID: ${_pedido.clienteId}'),
                    Text('Total: R\$${_pedido.valorTotal.toStringAsFixed(2)}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Itens do Pedido
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Itens do Pedido',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ..._pedido.itens.map((item) {
                      return ListTile(
                        leading: const Icon(Icons.cake),
                        title: Text(item['produto_nome'] ?? 'Produto'),
                        subtitle: Text(
                            'Quantidade: ${item['quantidade']} × R\$${item['preco_unitario']}'),
                        trailing: Text(
                          'R\$${(item['quantidade'] * item['preco_unitario']).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/pedido.dart';
import 'package:confeitaria_app/services/api_service.dart';
import 'formulario_pedido.dart';
import 'detalhes_pedido.dart'; 

class ListaPedidos extends StatefulWidget {
  const ListaPedidos({super.key});

  @override
  State<ListaPedidos> createState() => _ListaPedidosState();
}

class _ListaPedidosState extends State<ListaPedidos> {
  List<Pedido> _pedidos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarPedidos();
  }

  Future<void> _carregarPedidos() async {
    try {
      final pedidos = await ApiService.listarPedidos();
      setState(() {
        _pedidos = pedidos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      _mostrarErro('Erro ao carregar pedidos: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navegarParaFormularioPedido() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormularioPedido()),
    ).then((_) => _carregarPedidos());
  }

  Future<void> _excluirPedido(Pedido pedido) async {
    final confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o pedido #${pedido.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmar == true) {
      try {
        await ApiService.excluirPedido(pedido.id!);
        
        if (!mounted) return;
        
        _carregarPedidos();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido excluído com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          _mostrarErro('Erro ao excluir pedido: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum pedido cadastrado',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _pedidos.length,
                  // No ListView.builder, dentro do itemBuilder:
itemBuilder: (context, index) {
  final pedido = _pedidos[index];
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: ListTile(
      leading: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: pedido.corStatus,
          shape: BoxShape.circle,
        ),
      ),
      title: Text('Pedido #${pedido.id}'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Status: ${pedido.statusFormatado}'),
          Text('Data: ${pedido.dataFormatada}'),
          Text('Total: R\$${pedido.valorTotal.toStringAsFixed(2)}'),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton( icon: const Icon(Icons.visibility, color: Colors.blue), onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalhesPedido(pedido: pedido),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _excluirPedido(pedido),
            ),
        ],
          ),
      
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalhesPedido(pedido: pedido),
            ),
          );
        },
      ),
    );
  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaFormularioPedido,
        child: const Icon(Icons.add),
      ),
    );
  }
}
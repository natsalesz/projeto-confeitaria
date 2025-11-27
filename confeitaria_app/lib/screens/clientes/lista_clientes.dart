import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/cliente.dart';
import 'package:confeitaria_app/services/api_service.dart';
import 'formulario_cliente.dart';

class ListaClientes extends StatefulWidget {
  const ListaClientes({super.key});

  @override
  State<ListaClientes> createState() => _ListaClientesState();
}

class _ListaClientesState extends State<ListaClientes> {
  List<Cliente> _clientes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarClientes();
  }

  Future<void> _carregarClientes() async {
    try {
      final clientes = await ApiService.listarClientes();
      setState(() {
        _clientes = clientes;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      _mostrarErro('Erro ao carregar clientes: $e');
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

  void _navegarParaFormularioCliente() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormularioCliente()),
    ).then((_) => _carregarClientes());
  }

  void _editarCliente(Cliente cliente) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioCliente(cliente: cliente),
      ),
    ).then((_) => _carregarClientes());
  }
Future<void> _excluirCliente(Cliente cliente) async {
    final confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o cliente "${cliente.nome}"?'),
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
        await ApiService.excluirCliente(cliente.id!);
        
        if (!mounted) return;
        
        _carregarClientes();
  
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cliente excluído com sucesso!')),
          );
        }
      } catch (e) {
        if (mounted) {
          _mostrarErro('Erro ao excluir cliente: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _clientes.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum cliente cadastrado',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _clientes.length,
                  itemBuilder: (context, index) {
                    final cliente = _clientes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                        title: Text(cliente.nome),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cliente.email),
                            if (cliente.telefone.isNotEmpty)
                              Text(cliente.telefone),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarCliente(cliente),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirCliente(cliente),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaFormularioCliente,
        child: const Icon(Icons.add),
      ),
    );
  }
}
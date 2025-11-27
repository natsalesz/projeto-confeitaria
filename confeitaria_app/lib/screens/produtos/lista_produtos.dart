import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/produto.dart';
import 'package:confeitaria_app/services/api_service.dart';
import 'formulario_produto.dart';
import 'detalhes_produto.dart';

class ListaProdutos extends StatefulWidget {
  const ListaProdutos({super.key});

  @override
  State<ListaProdutos> createState() => _ListaProdutosState();
}

class _ListaProdutosState extends State<ListaProdutos> {
  List<Produto> _produtos = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
  }

  Future<void> _carregarProdutos() async {
    try {
      final produtos = await ApiService.listarProdutos();
      setState(() {
        _produtos = produtos;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      _mostrarErro('Erro ao carregar produtos: $e');
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

  void _navegarParaFormularioProduto() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FormularioProduto()),
    ).then((_) => _carregarProdutos());
  }

  void _editarProduto(Produto produto) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormularioProduto(produto: produto),
      ),
    ).then((_) => _carregarProdutos());
  }

  Future<void> _excluirProduto(Produto produto) async {
    final confirmar = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: Text('Deseja excluir o produto "${produto.nome}"?'),
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

    if (confirmar == true) {
      try {
        await ApiService.excluirProduto(produto.id!);
        _carregarProdutos();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto excluído com sucesso!')),
        );
      } catch (e) {
        _mostrarErro('Erro ao excluir produto: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {  // ← ESTE MÉTODO ESTAVA FALTANDO!
    return Scaffold(
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _produtos.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum produto cadastrado',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : ListView.builder(
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    final produto = _produtos[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: Text(
                          produto.iconeCategoria,
                          style: const TextStyle(fontSize: 24),
                        ),
                        title: Text(produto.nome),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('R\$${produto.preco.toStringAsFixed(2)}'),
                            Text('${produto.nomeCategoria} • Estoque: ${produto.estoque}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _editarProduto(produto),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _excluirProduto(produto),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                          context,
                          MaterialPageRoute(
                          builder: (context) => DetalhesProduto(produto: produto),
                          ),
                        );
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaFormularioProduto,
        child: const Icon(Icons.add),
      ),
    );
  }
}
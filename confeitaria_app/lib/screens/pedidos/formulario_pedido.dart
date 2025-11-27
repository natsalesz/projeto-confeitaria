import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/pedido.dart';
import 'package:confeitaria_app/models/cliente.dart';
import 'package:confeitaria_app/models/produto.dart';
import 'package:confeitaria_app/services/api_service.dart';

class FormularioPedido extends StatefulWidget {
  const FormularioPedido({super.key});

  @override
  State<FormularioPedido> createState() => _FormularioPedidoState();
}

class _FormularioPedidoState extends State<FormularioPedido> {
  final List<ItemPedido> _itens = [];
  List<Cliente> _clientes = [];
  List<Produto> _produtos = [];
  Cliente? _clienteSelecionado;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

 Future<void> _carregarDados() async {
  try {
    // Carregar separadamente para evitar problemas de tipo
    final clientes = await ApiService.listarClientes();
    final produtos = await ApiService.listarProdutos();

    if (!mounted) return;

    setState(() {
      _clientes = clientes;
      _produtos = produtos;
      _carregando = false;
    });
  } catch (e) {
    if (!mounted) return;
    
    _mostrarErro('Erro ao carregar dados: $e');
    setState(() {
      _carregando = false;
    });
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

  void _adicionarItem() {
    showDialog(
      context: context,
      builder: (context) => DialogItemPedido(
        produtos: _produtos,
        onAdicionar: (produtoId, quantidade, precoUnitario) {
          setState(() {
            _itens.add(ItemPedido(
              produtoId: produtoId,
              quantidade: quantidade,
              precoUnitario: precoUnitario,
            ));
          });
        },
      ),
    );
  }

  void _removerItem(int index) {
    setState(() {
      _itens.removeAt(index);
    });
  }

  Future<void> _criarPedido() async {
  if (_clienteSelecionado == null) {
    _mostrarErro('Por favor, selecione um cliente');
    return;
  }

  if (_itens.isEmpty) {
    _mostrarErro('Por favor, adicione pelo menos um item ao pedido');
    return;
  }

  try {
    final pedido = Pedido(
      clienteId: _clienteSelecionado!.id!,
      valorTotal: _calcularTotal(),
      status: 'pendente',
      itens: _itens.map((item) => item.toMap()).toList(),
    );

    await ApiService.criarPedido(pedido);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pedido criado com sucesso!')),
    );
    
    Navigator.pop(context);
  } catch (e) {
    if (!mounted) return;
    _mostrarErro('Erro ao criar pedido: $e');
  }
}

  double _calcularTotal() {
    return _itens.fold(0.0, (total, item) => total + (item.quantidade * item.precoUnitario));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Pedido'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _criarPedido,
          ),
        ],
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seleção de Cliente
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cliente',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<Cliente>(
                            initialValue: _clienteSelecionado,
                            decoration: const InputDecoration(
                              labelText: 'Selecione um cliente',
                              border: OutlineInputBorder(),
                            ),
                            items: _clientes.map((cliente) {
                              return DropdownMenuItem(
                                value: cliente,
                                child: Text(cliente.nome),
                              );
                            }).toList(),
                            onChanged: (cliente) {
                              setState(() {
                                _clienteSelecionado = cliente;
                              });
                            },
                          ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Itens do Pedido',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: _adicionarItem,
                                icon: const Icon(Icons.add),
                                label: const Text('Adicionar Item'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.pink,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          if (_itens.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  'Nenhum item adicionado\nClique em "Adicionar Item" para começar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            )
                          else
                            Column(
                              children: _itens.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final produto = _produtos.firstWhere(
                                  (p) => p.id == item.produtoId,
                                  orElse: () => Produto(
                                    nome: 'Produto não encontrado',
                                    descricao: '',
                                    preco: 0.0,
                                    categoria: 'bolo',
                                    imgUrl: '',
                                    estoque: 0,
                                  ),
                                );

                                return ListTile(
                                  leading: Text(
                                    produto.iconeCategoria,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  title: Text(produto.nome),
                                  subtitle: Text(
                                    '${item.quantidade} × R\$${item.precoUnitario.toStringAsFixed(2)}',
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'R\$${(item.quantidade * item.precoUnitario).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removerItem(index),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),

                          if (_itens.isNotEmpty) ...[
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total do Pedido:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'R\$${_calcularTotal().toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.pink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Botão de criar pedido
                  if (_itens.isNotEmpty && _clienteSelecionado != null)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _criarPedido,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Finalizar Pedido',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class ItemPedido {
  final int produtoId;
  final int quantidade;
  final double precoUnitario;

  ItemPedido({
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario,
  });

  Map<String, dynamic> toMap() {
    return {
      'produto_id': produtoId,
      'quantidade': quantidade,
      'preco_unitario': precoUnitario,
    };
  }
}

class DialogItemPedido extends StatefulWidget {
  final List<Produto> produtos;
  final Function(int, int, double) onAdicionar;

  const DialogItemPedido({
    super.key,
    required this.produtos,
    required this.onAdicionar,
  });

  @override
  State<DialogItemPedido> createState() => _DialogItemPedidoState();
}

class _DialogItemPedidoState extends State<DialogItemPedido> {
  Produto? _produtoSelecionado;
  final _quantidadeController = TextEditingController(text: '1');

  void _adicionar() {
    if (_produtoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, selecione um produto')),
      );
      return;
    }

    final quantidade = int.tryParse(_quantidadeController.text) ?? 1;
    if (quantidade <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira uma quantidade válida')),
      );
      return;
    }

    widget.onAdicionar(
      _produtoSelecionado!.id!,
      quantidade,
      _produtoSelecionado!.preco,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adicionar Item ao Pedido'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<Produto>(
            initialValue: _produtoSelecionado,
            decoration: const InputDecoration(
              labelText: 'Selecione um produto',
              border: OutlineInputBorder(),
            ),
            items: widget.produtos.map((produto) {
              return DropdownMenuItem(
                value: produto,
                child: Text(produto.nome),
              );
            }).toList(),
            onChanged: (produto) {
              setState(() {
                _produtoSelecionado = produto;
              });
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantidadeController,
            decoration: const InputDecoration(
              labelText: 'Quantidade',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {}); // Atualizar o total em tempo real
            },
          ),
          if (_produtoSelecionado != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.grey[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'R\$${((_produtoSelecionado!.preco) * (int.tryParse(_quantidadeController.text) ?? 1)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _produtoSelecionado == null ? null : _adicionar,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
          ),
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}
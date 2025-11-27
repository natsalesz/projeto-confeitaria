import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/produto.dart';
import 'package:confeitaria_app/services/api_service.dart';

class FormularioProduto extends StatefulWidget {
  final Produto? produto;

  const FormularioProduto({super.key, this.produto});

  @override
  State<FormularioProduto> createState() => _FormularioProdutoState();
}

class _FormularioProdutoState extends State<FormularioProduto> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();
  final _estoqueController = TextEditingController();
  final _imgUrlController = TextEditingController();
  
  String _categoriaSelecionada = 'bolo';
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.produto != null) {
      _preencherFormulario();
    }
  }

  void _preencherFormulario() {
    final produto = widget.produto!;
    _nomeController.text = produto.nome;
    _descricaoController.text = produto.descricao;
    _precoController.text = produto.preco.toString();
    _estoqueController.text = produto.estoque.toString();
    _imgUrlController.text = produto.imgUrl;
    _categoriaSelecionada = produto.categoria;
  }

  Future<void> _salvarProduto() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _salvando = true;
    });

    try {
      final produto = Produto(
        id: widget.produto?.id,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        preco: double.parse(_precoController.text),
        categoria: _categoriaSelecionada,
        imgUrl: _imgUrlController.text,
        estoque: int.parse(_estoqueController.text),
      );

      if (widget.produto == null) {
        await ApiService.criarProduto(produto);
      } else {
        await ApiService.atualizarProduto(produto);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar produto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _salvando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.produto == null ? 'Novo Produto' : 'Editar Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvando ? null : _salvarProduto,
          ),
        ],
      ),
      body: _salvando
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Produto',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome do produto';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descricaoController,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _precoController,
                      decoration: const InputDecoration(
                        labelText: 'Preço (R\$)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o preço';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Por favor, insira um preço válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _categoriaSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'bolo',
                          child: Text('🎂 Bolo'),
                        ),
                        DropdownMenuItem(
                          value: 'docinho',
                          child: Text('🍬 Docinho'),
                        ),
                        DropdownMenuItem(
                          value: 'kit',
                          child: Text('🎁 Kit Festa'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _categoriaSelecionada = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _estoqueController,
                      decoration: const InputDecoration(
                        labelText: 'Estoque',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira a quantidade em estoque';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Por favor, insira um número válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _imgUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL da Imagem (opcional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _salvando ? null : _salvarProduto,
                      child: _salvando
                          ? const CircularProgressIndicator()
                          : Text(widget.produto == null ? 'Criar Produto' : 'Atualizar Produto'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    _estoqueController.dispose();
    _imgUrlController.dispose();
    super.dispose();
  }
}
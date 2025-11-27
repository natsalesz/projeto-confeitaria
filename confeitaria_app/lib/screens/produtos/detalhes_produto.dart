import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/produto.dart';

class DetalhesProduto extends StatelessWidget {
  final Produto produto;

  const DetalhesProduto({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(produto.nome),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagem do produto
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                image: produto.imgUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(produto.imgUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: produto.imgUrl.isEmpty
                  ? Icon(
                      Icons.cake,
                      size: 80,
                      color: Colors.grey[400],
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            
            // Nome e Categoria
            Row(
              children: [
                Text(
                  produto.iconeCategoria,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    produto.nome,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Categoria
            Chip(
              label: Text(
                produto.nomeCategoria,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: _getCorCategoria(produto.categoria),
            ),
            const SizedBox(height: 16),
            
            // Descrição
            Text(
              produto.descricao,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            
            // Informações de Preço e Estoque
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Preço:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'R\$${produto.preco.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Text(
                          'Estoque:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${produto.estoque} unidades',
                          style: TextStyle(
                            fontSize: 16,
                            color: produto.estoque > 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          produto.estoque > 0 ? 'Disponível' : 'Fora de estoque',
                          style: TextStyle(
                            fontSize: 16,
                            color: produto.estoque > 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
        
          ],
        ),
      ),
    );
  }
  
  Color _getCorCategoria(String categoria) {
    switch (categoria) {
      case 'bolo':
        return Colors.pink;
      case 'docinho':
        return Colors.purple;
      case 'kit':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:confeitaria_app/models/cliente.dart';
import 'package:confeitaria_app/services/api_service.dart';

class FormularioCliente extends StatefulWidget {
  final Cliente? cliente;

  const FormularioCliente({super.key, this.cliente});

  @override
  State<FormularioCliente> createState() => _FormularioClienteState();
}

class _FormularioClienteState extends State<FormularioCliente> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    if (widget.cliente != null) {
      _preencherFormulario();
    }
  }

  void _preencherFormulario() {
    final cliente = widget.cliente!;
    _nomeController.text = cliente.nome;
    _emailController.text = cliente.email;
    _telefoneController.text = cliente.telefone;
  }

  Future<void> _salvarCliente() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _salvando = true;
    });

    try {
      final cliente = Cliente(
        id: widget.cliente?.id,
        nome: _nomeController.text,
        email: _emailController.text,
        telefone: _telefoneController.text,
      );

      if (widget.cliente == null) {
        await ApiService.criarCliente(cliente);
      } else {
        await ApiService.atualizarCliente(cliente);
      }

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar cliente: $e'),
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
        title: Text(widget.cliente == null ? 'Novo Cliente' : 'Editar Cliente'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvando ? null : _salvarCliente,
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
                        labelText: 'Nome Completo',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o nome do cliente';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira o e-mail';
                        }
                        if (!value.contains('@')) {
                          return 'Por favor, insira um e-mail válido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _telefoneController,
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _salvando ? null : _salvarCliente,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _salvando
                          ? const CircularProgressIndicator()
                          : Text(widget.cliente == null ? 'Criar Cliente' : 'Atualizar Cliente'),
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
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }
}
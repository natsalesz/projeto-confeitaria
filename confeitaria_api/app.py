from flask import Flask, jsonify, request
from flask_cors import CORS
from database import Database
from models.produto import Produto
from models.cliente import Cliente
from models.pedido import Pedido
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)
CORS(app)


# Configuração do banco de dados
db_config = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'user': os.getenv('DB_USER', 'root'),
    'password': os.getenv('DB_PASSWORD', ''),
    'database': os.getenv('DB_NAME', 'confeitaria_db')
}

database = Database(db_config)

# Rotas para Produtos
@app.route('/produtos', methods=['GET'])
def listar_produtos():
    try:
        produtos = Produto.listar_todos(database)
        return jsonify([produto.para_dict() for produto in produtos])
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/produtos/<int:id>', methods=['GET'])
def obter_produto(id):
    try:
        produto = Produto.obter_por_id(database, id)
        if produto:
            return jsonify(produto.para_dict())
        return jsonify({'erro': 'Produto não encontrado'}), 404
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/produtos', methods=['POST'])
def criar_produto():
    try:
        dados = request.get_json()
        produto = Produto(
            nome=dados['nome'],
            descricao=dados.get('descricao', ''),
            preco=dados['preco'],
            categoria=dados['categoria'],
            img_url=dados.get('img_url', ''),
            estoque=dados.get('estoque', 0)
        )
        produto.salvar(database)
        return jsonify(produto.para_dict()), 201
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/produtos/<int:id>', methods=['PUT'])
def atualizar_produto(id):
    try:
        dados = request.get_json()
        produto = Produto.obter_por_id(database, id)
        if not produto:
            return jsonify({'erro': 'Produto não encontrado'}), 404
        
        produto.nome = dados.get('nome', produto.nome)
        produto.descricao = dados.get('descricao', produto.descricao)
        produto.preco = dados.get('preco', produto.preco)
        produto.categoria = dados.get('categoria', produto.categoria)
        produto.img_url = dados.get('img_url', produto.img_url)
        produto.estoque = dados.get('estoque', produto.estoque)
        
        produto.atualizar(database)
        return jsonify(produto.para_dict())
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/produtos/<int:id>', methods=['DELETE'])
def excluir_produto(id):
    try:
        produto = Produto.obter_por_id(database, id)
        if not produto:
            return jsonify({'erro': 'Produto não encontrado'}), 404
        
        produto.excluir(database)
        return jsonify({'mensagem': 'Produto excluído com sucesso'})
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


# Rotas para Clientes
@app.route('/clientes', methods=['GET'])
def listar_clientes():
    try:
        clientes = Cliente.listar_todos(database)
        return jsonify([cliente.para_dict() for cliente in clientes])
    except Exception as e:
        return jsonify({'erro': str(e)}), 500

@app.route('/clientes/<int:id>', methods=['GET'])
def obter_cliente(id):
    try:
        cliente = Cliente.obter_por_id(database, id)
        if cliente:
            return jsonify(cliente.para_dict())
        return jsonify({'erro': 'Cliente não encontrado'}), 404
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/clientes', methods=['POST'])
def criar_cliente():
    try:
        dados = request.get_json()
        cliente = Cliente(
            nome=dados['nome'],
            email=dados['email'],
            telefone=dados.get('telefone', '')
        )
        cliente.salvar(database)
        return jsonify(cliente.para_dict()), 201
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/clientes/<int:id>', methods=['PUT'])
def atualizar_cliente(id):
    try:
        dados = request.get_json()
        cliente = Cliente.obter_por_id(database, id)
        if not cliente:
            return jsonify({'erro': 'Cliente não encontrado'}), 404
        
        cliente.nome = dados.get('nome', cliente.nome)
        cliente.email = dados.get('email', cliente.email)
        cliente.telefone = dados.get('telefone', cliente.telefone)
        
        cliente.atualizar(database)
        return jsonify(cliente.para_dict())
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/clientes/<int:id>', methods=['DELETE'])
def excluir_cliente(id):
    try:
        cliente = Cliente.obter_por_id(database, id)
        if not cliente:
            return jsonify({'erro': 'Cliente não encontrado'}), 404
        
        cliente.excluir(database)
        return jsonify({'mensagem': 'Cliente excluído com sucesso'})
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


# Rotas para Pedidos
@app.route('/pedidos', methods=['GET'])
def listar_pedidos():
    try:
        pedidos = Pedido.listar_todos(database)
        return jsonify([pedido.para_dict() for pedido in pedidos])
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/pedidos/<int:id>', methods=['GET'])
def obter_pedido(id):
    try:
        pedido = Pedido.obter_por_id(database, id)
        if pedido:
            return jsonify(pedido.para_dict())
        return jsonify({'erro': 'Pedido não encontrado'}), 404
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/pedidos', methods=['POST'])
def criar_pedido():
    try:
        dados = request.get_json()
        pedido = Pedido(
            cliente_id=dados['cliente_id'],
            itens=dados['itens']
        )
        pedido.salvar(database)
        return jsonify(pedido.para_dict()), 201
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/pedidos/<int:id>', methods=['PUT'])
def atualizar_pedido(id):
    try:
        dados = request.get_json()
        pedido = Pedido.obter_por_id(database, id)
        if not pedido:
            return jsonify({'erro': 'Pedido não encontrado'}), 404
        
        pedido.status = dados.get('status', pedido.status)
        pedido.atualizar(database)
        return jsonify(pedido.para_dict())
    except Exception as e:
        return jsonify({'erro': str(e)}), 500


@app.route('/pedidos/<int:id>', methods=['DELETE'])
def excluir_pedido(id):
    try:
        pedido = Pedido.obter_por_id(database, id)
        if not pedido:
            return jsonify({'erro': 'Pedido não encontrado'}), 404
        
        pedido.excluir(database)
        return jsonify({'mensagem': 'Pedido excluído com sucesso'})
    except Exception as e:
        return jsonify({'erro': str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
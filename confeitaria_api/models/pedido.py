class Pedido:
    def __init__(self, id=None, cliente_id=None, data_pedido=None, valor_total=0.0, status='pendente', itens=None):
        self.id = id
        self.cliente_id = cliente_id
        self.data_pedido = data_pedido
        self.valor_total = valor_total
        self.status = status
        self.itens = itens or []
    
    def para_dict(self):
        return {
            'id': self.id,
            'cliente_id': self.cliente_id,
            'data_pedido': self.data_pedido.isoformat() if self.data_pedido else None,
            'valor_total': float(self.valor_total),
            'status': self.status,
            'itens': self.itens
        }
    
    @classmethod
    def listar_todos(cls, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM pedidos ORDER BY id DESC")
                resultados = cursor.fetchall()
                pedidos = []
                for resultado in resultados:
                    pedido = cls(
                        id=resultado[0] if isinstance(resultado, (list, tuple)) else resultado['id'],
                        cliente_id=resultado[1] if isinstance(resultado, (list, tuple)) else resultado['cliente_id'],
                        data_pedido=resultado[2] if isinstance(resultado, (list, tuple)) else resultado['data_pedido'],
                        valor_total=resultado[3] if isinstance(resultado, (list, tuple)) else resultado['valor_total'],
                        status=resultado[4] if isinstance(resultado, (list, tuple)) else resultado['status']
                    )
                    # Carregar itens do pedido
                    cursor.execute("""
                        SELECT ip.*, p.nome as produto_nome 
                        FROM itens_pedido ip 
                        JOIN produtos p ON ip.produto_id = p.id 
                        WHERE ip.pedido_id = %s
                    """, (pedido.id,))
                    itens_resultado = cursor.fetchall()
                    pedido.itens = []
                    for item in itens_resultado:
                        if isinstance(item, (list, tuple)):
                            pedido.itens.append({
                                'id': item[0],
                                'pedido_id': item[1],
                                'produto_id': item[2],
                                'quantidade': item[3],
                                'preco_unitario': float(item[4]),
                                'produto_nome': item[5]
                            })
                        else:
                            pedido.itens.append({
                                'id': item['id'],
                                'pedido_id': item['pedido_id'],
                                'produto_id': item['produto_id'],
                                'quantidade': item['quantidade'],
                                'preco_unitario': float(item['preco_unitario']),
                                'produto_nome': item['produto_nome']
                            })
                    pedidos.append(pedido)
                return pedidos
        finally:
            connection.close()
    
    @classmethod
    def obter_por_id(cls, database, id):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM pedidos WHERE id = %s", (id,))
                resultado = cursor.fetchone()
                if resultado:
                    pedido = cls(
                        id=resultado[0] if isinstance(resultado, (list, tuple)) else resultado['id'],
                        cliente_id=resultado[1] if isinstance(resultado, (list, tuple)) else resultado['cliente_id'],
                        data_pedido=resultado[2] if isinstance(resultado, (list, tuple)) else resultado['data_pedido'],
                        valor_total=resultado[3] if isinstance(resultado, (list, tuple)) else resultado['valor_total'],
                        status=resultado[4] if isinstance(resultado, (list, tuple)) else resultado['status']
                    )
                    # Carregar itens do pedido
                    cursor.execute("""
                        SELECT ip.*, p.nome as produto_nome 
                        FROM itens_pedido ip 
                        JOIN produtos p ON ip.produto_id = p.id 
                        WHERE ip.pedido_id = %s
                    """, (pedido.id,))
                    itens_resultado = cursor.fetchall()
                    pedido.itens = []
                    for item in itens_resultado:
                        if isinstance(item, (list, tuple)):
                            pedido.itens.append({
                                'id': item[0],
                                'pedido_id': item[1],
                                'produto_id': item[2],
                                'quantidade': item[3],
                                'preco_unitario': float(item[4]),
                                'produto_nome': item[5]
                            })
                        else:
                            pedido.itens.append({
                                'id': item['id'],
                                'pedido_id': item['pedido_id'],
                                'produto_id': item['produto_id'],
                                'quantidade': item['quantidade'],
                                'preco_unitario': float(item['preco_unitario']),
                                'produto_nome': item['produto_nome']
                            })
                    return pedido
                return None
        finally:
            connection.close()
    
    def salvar(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                # Calcular valor total
                valor_total = sum(item['quantidade'] * item['preco_unitario'] for item in self.itens)
                
                # Inserir pedido
                sql = "INSERT INTO pedidos (cliente_id, valor_total, status) VALUES (%s, %s, %s)"
                cursor.execute(sql, (self.cliente_id, valor_total, self.status))
                self.id = cursor.lastrowid
                
                # Inserir itens do pedido
                for item in self.itens:
                    sql = """INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario) 
                             VALUES (%s, %s, %s, %s)"""
                    cursor.execute(sql, (self.id, item['produto_id'], item['quantidade'], item['preco_unitario']))
                
                connection.commit()
        finally:
            connection.close()
    
    def atualizar(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                sql = "UPDATE pedidos SET status=%s WHERE id=%s"
                cursor.execute(sql, (self.status, self.id))
                connection.commit()
        finally:
            connection.close()
    
    def excluir(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("DELETE FROM pedidos WHERE id = %s", (self.id,))
                connection.commit()
        finally:
            connection.close()
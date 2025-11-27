class Produto:
    def __init__(self, id=None, nome='', descricao='', preco=0.0, categoria='', img_url='', estoque=0, data_criacao=None):
        self.id = id
        self.nome = nome
        self.descricao = descricao
        self.preco = preco
        self.categoria = categoria
        self.img_url = img_url
        self.estoque = estoque
        self.data_criacao = data_criacao
    
    def para_dict(self):
        return {
            'id': self.id,
            'nome': self.nome,
            'descricao': self.descricao,
            'preco': float(self.preco),
            'categoria': self.categoria,
            'img_url': self.img_url,
            'estoque': self.estoque,
            'data_criacao': self.data_criacao.isoformat() if self.data_criacao else None
        }
    
    @classmethod
    def listar_todos(cls, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM produtos ORDER BY id DESC")
                resultados = cursor.fetchall()
                produtos = []
                for resultado in resultados:
                    # mysql-connector retorna um dicionário diferente
                    produto = cls(
                        id=resultado[0] if isinstance(resultado, (list, tuple)) else resultado['id'],
                        nome=resultado[1] if isinstance(resultado, (list, tuple)) else resultado['nome'],
                        descricao=resultado[2] if isinstance(resultado, (list, tuple)) else resultado['descricao'],
                        preco=resultado[3] if isinstance(resultado, (list, tuple)) else resultado['preco'],
                        categoria=resultado[4] if isinstance(resultado, (list, tuple)) else resultado['categoria'],
                        img_url=resultado[5] if isinstance(resultado, (list, tuple)) else resultado['img_url'],
                        estoque=resultado[6] if isinstance(resultado, (list, tuple)) else resultado['estoque'],
                        data_criacao=resultado[7] if isinstance(resultado, (list, tuple)) else resultado['data_criacao']
                    )
                    produtos.append(produto)
                return produtos
        finally:
            connection.close()
    
    @classmethod
    def obter_por_id(cls, database, id):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM produtos WHERE id = %s", (id,))
                resultado = cursor.fetchone()
                if resultado:
                    return cls(
                        id=resultado[0] if isinstance(resultado, (list, tuple)) else resultado['id'],
                        nome=resultado[1] if isinstance(resultado, (list, tuple)) else resultado['nome'],
                        descricao=resultado[2] if isinstance(resultado, (list, tuple)) else resultado['descricao'],
                        preco=resultado[3] if isinstance(resultado, (list, tuple)) else resultado['preco'],
                        categoria=resultado[4] if isinstance(resultado, (list, tuple)) else resultado['categoria'],
                        img_url=resultado[5] if isinstance(resultado, (list, tuple)) else resultado['img_url'],
                        estoque=resultado[6] if isinstance(resultado, (list, tuple)) else resultado['estoque'],
                        data_criacao=resultado[7] if isinstance(resultado, (list, tuple)) else resultado['data_criacao']
                    )
                return None
        finally:
            connection.close()
    
    def salvar(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                sql = """INSERT INTO produtos (nome, descricao, preco, categoria, img_url, estoque) 
                         VALUES (%s, %s, %s, %s, %s, %s)"""
                cursor.execute(sql, (self.nome, self.descricao, self.preco, self.categoria, self.img_url, self.estoque))
                connection.commit()
                self.id = cursor.lastrowid
        finally:
            connection.close()
    
    def atualizar(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                sql = """UPDATE produtos SET nome=%s, descricao=%s, preco=%s, categoria=%s, 
                         img_url=%s, estoque=%s WHERE id=%s"""
                cursor.execute(sql, (self.nome, self.descricao, self.preco, self.categoria, 
                                   self.img_url, self.estoque, self.id))
                connection.commit()
        finally:
            connection.close()
    
    def excluir(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("DELETE FROM produtos WHERE id = %s", (self.id,))
                connection.commit()
        finally:
            connection.close()
class Cliente:
    def __init__(self, id=None, nome='', email='', telefone='', data_criacao=None):
        self.id = id
        self.nome = nome
        self.email = email
        self.telefone = telefone
        self.data_criacao = data_criacao
    
    def para_dict(self):
        return {
            'id': self.id,
            'nome': self.nome,
            'email': self.email,
            'telefone': self.telefone,
            'data_criacao': self.data_criacao.isoformat() if self.data_criacao else None
        }
    
    @classmethod
    def listar_todos(cls, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM clientes ORDER BY id DESC")
                resultados = cursor.fetchall()
                clientes = []
                for resultado in resultados:
                    cliente = cls(
                        id=resultado[0] if isinstance(resultado, (list, tuple)) else resultado['id'],
                        nome=resultado[1] if isinstance(resultado, (list, tuple)) else resultado['nome'],
                        email=resultado[2] if isinstance(resultado, (list, tuple)) else resultado['email'],
                        telefone=resultado[3] if isinstance(resultado, (list, tuple)) else resultado['telefone'],
                        data_criacao=resultado[4] if isinstance(resultado, (list, tuple)) else resultado['data_criacao']
                    )
                    clientes.append(cliente)
                return clientes
        finally:
            connection.close()
    
    @classmethod
    def obter_por_id(cls, database, id):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("SELECT * FROM clientes WHERE id = %s", (id,))
                resultado = cursor.fetchone()
                if resultado:
                    return cls(
                        id=resultado[0] if isinstance(resultado, (list, tuple)) else resultado['id'],
                        nome=resultado[1] if isinstance(resultado, (list, tuple)) else resultado['nome'],
                        email=resultado[2] if isinstance(resultado, (list, tuple)) else resultado['email'],
                        telefone=resultado[3] if isinstance(resultado, (list, tuple)) else resultado['telefone'],
                        data_criacao=resultado[4] if isinstance(resultado, (list, tuple)) else resultado['data_criacao']
                    )
                return None
        finally:
            connection.close()
    
    def salvar(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                sql = "INSERT INTO clientes (nome, email, telefone) VALUES (%s, %s, %s)"
                cursor.execute(sql, (self.nome, self.email, self.telefone))
                connection.commit()
                self.id = cursor.lastrowid
        finally:
            connection.close()
    
    def atualizar(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                sql = "UPDATE clientes SET nome=%s, email=%s, telefone=%s WHERE id=%s"
                cursor.execute(sql, (self.nome, self.email, self.telefone, self.id))
                connection.commit()
        finally:
            connection.close()
    
    def excluir(self, database):
        connection = database.get_connection()
        try:
            with connection.cursor() as cursor:
                cursor.execute("DELETE FROM clientes WHERE id = %s", (self.id,))
                connection.commit()
        finally:
            connection.close()
import pymysql

class Database:
    def __init__(self, config):
        self.config = config
    
    def get_connection(self):
        return pymysql.connect(
            host=self.config['host'],
            user=self.config['user'],
            password=self.config['password'],
            database=self.config['database'],
            charset='utf8mb4',
            cursorclass=pymysql.cursors.DictCursor
        )
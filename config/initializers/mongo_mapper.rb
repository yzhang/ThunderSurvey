MongoMapper.database = 'conforge'

logger = Logger.new('log/development.log')
MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :logger => logger)

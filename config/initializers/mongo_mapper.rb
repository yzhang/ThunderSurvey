logger = Logger.new('log/development.log')
MongoMapper.connection = Mongo::Connection.new('127.0.0.1', 27017, :logger => logger)
MongoMapper.database = 'qiangda'

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect_to_master if forked
   end
end
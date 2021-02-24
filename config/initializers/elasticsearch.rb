# enables logging of all traffic to/from the Elasticsearch client
# if the LOG_ELASTICSEARCH environment varitable is truthy

LOG_ELASTICSEARCH = ENV.fetch("LOG_ELASTICSEARCH", "false")
should_log = ActiveModel::Type::Boolean.new.cast(LOG_ELASTICSEARCH)

if should_log
  Elasticsearch::Model.client = Elasticsearch::Client.new(log: true)
end

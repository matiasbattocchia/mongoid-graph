require "mongoid"
require "mongoid/graph"

Mongoid.configure do |config|
  config.connect_to('mongoid-graph_test')
end

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  config.before do
    Mongoid.purge!
  end
end

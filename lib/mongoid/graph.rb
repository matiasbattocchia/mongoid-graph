require 'mongoid/graph/version'
require 'mongoid/graph/node'
require 'mongoid/graph/link'

module Mongoid
  module Graph
    class NodeError < StandardError; end
    class LinkError < StandardError; end

    def self.dot nodes
      dot = "digraph g {\n"
      nodes.each do |source|
        source.endpoints(:out).each do |target|
          dot << "  #{source.id} -> #{target.id};\n"
        end
      end
      dot + '}'
    end

  end
end

require 'mongoid/graph/version'
require 'mongoid/graph/node'
require 'mongoid/graph/link'
require 'array'

module Mongoid
  module Graph
    class NodeError < StandardError; end
    class LinkError < StandardError; end

    def self.dot nodes
      dot = "digraph g {\n"
      nodes.each do |source|
        source.endpoints(:out).each do |target|
          dot << "  #{source.label} -> #{target.label};\n"
        end
      end
      dot + '}'
    end

    def self.dagre nodes
      dagre = []
      nodes.each do |source|
        source.endpoints(:out).each do |target|
          dagre << {sourceId: source.id.to_s, source: source.label, targetId: target.id.to_s, target: target.label}
        end
      end
      dagre
    end

  end
end

module Mongoid
  module Graph
    module Node

      def self.included(base)
        base.class_eval do
          field :predecessors, default: []
          field :successors, default: []
        end
      end

      def connect_to target, link = nil, source = self
        s = [source.class.to_s, source.id]
        t = [target.class.to_s, target.id]
        
        if link
          raise LinkError, 'Link already in use. Disconnect it first!' if link.source || link.target
        
          l = [link.class.to_s, link.id]
          
          link.update_attributes(source: s, target: t)
        else
          l = []
        end

        source.update_attributes(
          successors: source.read_attribute(:successors) << t + l)

        target.update_attributes(
          predecessors: target.read_attribute(:predecessors) << s + l)
        
        {source: source, link: link, target: target}
      end

      def endpoints direction = :both, nodes: nil, links: nil

        case direction
        when :in
          nodes = read_attribute(:predecessors)
        when :out
          nodes = read_attribute(:successors)
        else
          nodes = read_attribute(:predecessors) + read_attribute(:successors)
        end

        # TODO: Sort by class and find multiple ids at once.
        # TODO: Establish a criteria for sorting the result before return it.
        nodes.uniq.map do |node|
          node[0].constantize.find node[1]
        end.compact
      end

    end
  end
end

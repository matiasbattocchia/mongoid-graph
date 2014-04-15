module Mongoid
  module Graph
    module Node

      def self.included(base)
        base.class_eval do
          field :predecessors, default: []
          field :successors, default: []
        end
      end

      def label
        id.to_s
      end

      def connect_to target, link = nil, source = self
        s = [source.class.to_s, source.id]
        t = [target.class.to_s, target.id]
        
        if link
          raise LinkError, 'Link already in use. Disconnect it first!' if link.source || link.target
        
          l = [link.class.to_s, link.id]
          
          link.source = s
          link.target = t
          link.save
        else
          l = []
        end

        source.successors << t + l
        target.predecessors << s + l

        source.save
        target.save

        {source: source, link: link, target: target}
      end

      def disconnect_from target, link = nil, source = self
        s = [source.class.to_s, source.id]
        t = [target.class.to_s, target.id]

        if link
          #raise LinkError, 'Link already in use. Disconnect it first!' if link.source || link.target
        
          l = [link.class.to_s, link.id]
          
          link.source = nil
          link.target = nil
          link.save
        else
          l = []
        end
        
        source.successors >> t + l
        target.predecessors >> s + l

        source.save
        target.save

        {source: source, link: link, target: target}
      end

      def endpoints direction = :both, nodes: nil, links: nil
        case direction
        when :in
          nodes = predecessors
        when :out
          nodes = successors
        else
          nodes = predecessors + successors
        end

        # TODO: Sort by class and find multiple ids at once.
        # TODO: Establish a criteria for sorting results before return them.
        nodes.uniq.map do |node|
          node[0].constantize.find node[1]
        end.compact
      end

      def endpoints? direction = :both
        case direction
        when :in
          nodes = predecessors
        when :out
          nodes = successors
        else
          nodes = predecessors + successors
        end

        nodes.empty?
      end
    end
  end
end

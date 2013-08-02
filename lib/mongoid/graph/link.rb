module Mongoid
  module Graph
    module Link

      def self.included(base)
        base.class_eval do
          field :source
          field :target
        end
      end

    end
  end
end

module Nanoc
  module DocumentViewMixin
    # @api private
    NONE = Object.new.freeze

    # @api private
    def initialize(document, context)
      super(context)
      @document = document
    end

    # @api private
    def unwrap
      @document
    end

    # @see Object#==
    def ==(other)
      other.respond_to?(:identifier) && identifier == other.identifier
    end
    alias eql? ==

    # @see Object#hash
    def hash
      self.class.hash ^ identifier.hash
    end

    # @return [Nanoc::Identifier]
    def identifier
      unwrap.identifier
    end

    # @see Hash#[]
    def [](key)
      @context.dependency_tracker.bounce(unwrap)
      unwrap.attributes[key]
    end

    # @return [Hash]
    def attributes
      @context.dependency_tracker.bounce(unwrap)
      unwrap.attributes
    end

    # @see Hash#fetch
    def fetch(key, fallback = NONE, &_block)
      @context.dependency_tracker.bounce(unwrap)

      if unwrap.attributes.key?(key)
        unwrap.attributes[key]
      elsif !fallback.equal?(NONE)
        fallback
      elsif block_given?
        yield(key)
      else
        raise KeyError, "key not found: #{key.inspect}"
      end
    end

    # @see Hash#key?
    def key?(key)
      @context.dependency_tracker.bounce(unwrap)
      unwrap.attributes.key?(key)
    end

    # @api private
    def reference
      unwrap.reference
    end

    # @api private
    def raw_content
      unwrap.content.string
    end
  end
end

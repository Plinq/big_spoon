require 'big_spoon/hook'

module BigSpoon
  module ClassMethods
    def hooks(options = {}, &block)
      @hooks ||= Hook.for(self)
      @hooks.instance_eval(&block) if block_given?

      unless respond_to?(:_big_spoon_original_method_added)
        class << self
          alias :_big_spoon_original_method_added :method_added
          def _big_spoon_alias_method_added(method_to_hook, *args)
            if @hooks.should_hook?(method_to_hook)
              @hooks.hook! method_to_hook
            end
          end
          alias :method_added :_big_spoon_alias_method_added
        end
      end
      @hooks
    end # `hooks` method
    
    private
    def method_missing(method_name, *args)
      case method_name.to_s
      when /^after_(.+)$/
        hooks.after $1, *args
      when /^before_(.+)$/
        hooks.before $1, *args
      else
        super
      end
    end
  end # `ClassMethods` module
end # `BigSpoon` module

Object.extend BigSpoon::ClassMethods

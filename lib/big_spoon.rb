require 'big_spoon/hook'

module BigSpoon
  module ClassMethods
    def spoon(options = {}, &block)
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
    end # `big_spoon` method

    private
    def method_missing_with_big_spoon(method_name, *args, &block)
      case method_name.to_s
      when 'hooks'
        spoon *args, &block
      when 'after'
        hooks.after *args, &block
      when /^after_(.+)$/
        hooks.after $1, *args, &block
      when 'before'
        hooks.before *args, &block
      when /^before_(.+)$/
        hooks.before $1, *args, &block
      else
        method_missing_without_big_spoon(method_name, *args)
      end
    end
  end # `ClassMethods` module
end # `BigSpoon` module

Object.class_eval do
  extend BigSpoon::ClassMethods
  class << self
    alias :method_missing_without_big_spoon :method_missing
    alias :method_missing :method_missing_with_big_spoon
  end
end


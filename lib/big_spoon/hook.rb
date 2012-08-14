module BigSpoon
  class Hook
    class << self
      def for(klass)
        all[klass.to_s] ||= new(klass)
      end

      private
      def all
        @all ||= {}
      end
    end

    attr_accessor :klass

    # Define a method to execute after another
    def after(method_to_hook, method_to_call = nil, options = {}, &block)
      hook(:after, method_to_hook, method_to_call, options, &block)
    end

    # Define a method to execute before another
    def before(method_to_hook, method_to_call = nil, options = {}, &block)
      hook(:before, method_to_hook, method_to_call, options, &block)
    end

    # def clear!
    #   methods.each do |method_to_hook, hooks|
    #     unhook! method_to_hook
    #   end
    #   methods.clear
    # end

    # Execute after a method
    def execute_after(method_to_hook, instance)
      execute(:after, method_to_hook, instance)
    end

    # Execute before a method
    def execute_before(method_to_hook, instance)
      execute(:before, method_to_hook, instance)
    end

    # Alias a method for hookable-ness
    def hook!(method_to_hook)
      hooked_method = hooked_method(method_to_hook)
      original_method = original_method(method_to_hook)
      line = __LINE__; alias_these_hooks = <<-hooks
      alias :#{original_method} :#{method_to_hook}
      def #{hooked_method}(*args)
        Hook.for(self.class).execute_before(:#{method_to_hook}, self)
        result = #{original_method}(*args)
        Hook.for(self.class).execute_after(:#{method_to_hook}, self)
        result
      end
      alias :#{method_to_hook} :#{hooked_method}
      hooks
      klass.class_eval alias_these_hooks, __FILE__, line.succ
    end

    def initialize(klass)
      self.klass = klass
    end

    def should_hook?(method_to_hook)
      methods[method_to_hook.to_sym] && hookable?(method_to_hook) && !hooked?(method_to_hook)
    end

    def unhook!(method_to_hook)
      hooked_method = hooked_method(method_to_hook)
      original_method = original_method(method_to_hook)
      line = __LINE__; alias_these_hooks = <<-hooks
      alias :#{method_to_hook} #{original_method}
      remove_method #{hooked_method}
      hooks
      klass.class_eval alias_these_hooks, __FILE__, line.succ
    end

    private
    def execute(before_or_after, method_to_hook, instance)
      methods[method_to_hook] ||= {}
      methods[method_to_hook][before_or_after] ||= []
      methods[method_to_hook][before_or_after].each do |method_definition|
        execute_for_reals = if method_definition[:if].is_a?(Proc)
          instance.instance_eval(&method_definition[:if])
        elsif method_definition[:if]
          instance.send(method_definition[:if])
        elsif method_definition[:unless].is_a?(Proc)
          !instance.instance_eval(&method_definition[:unless])
        elsif method_definition[:unless]
          !instance.send(method_definition[:unless])
        else
          true
        end
        if execute_for_reals
          case method_definition[:method]
          when Proc
            instance.instance_eval(&method_definition[:method])
          else
            instance.send(method_definition[:method])
          end
        end
      end
    end

    def hook(before_or_after, method_to_hook, method_to_call = nil, options = {}, &block)
      method_to_hook = method_to_hook.to_sym
      if method_to_call.is_a? Hash
        options = method_to_call
        method_to_call = nil
      end
      if block_given?
        method_to_call = block
      else
        method_to_call = method_to_call.to_sym
      end

      methods[method_to_hook] ||= {}
      methods[method_to_hook][before_or_after] ||= []
      method_definition = options.merge({:method => method_to_call})
      methods[method_to_hook][before_or_after].push(method_definition) unless methods[method_to_hook][before_or_after].any? do |other_method_definition|
        other_method_definition[:method] == method_to_call
      end

      hook!(method_to_hook) if should_hook?(method_to_hook)
    end

    def hookable?(method_to_hook)
      klass.method_defined?(method_to_hook)
    end

    def hooked?(method_to_hook)
      klass.method_defined?(hooked_method(method_to_hook))
    end

    def hooked_method(method_to_hook)
      "_big_spoon_alias_#{method_to_hook}"
    end

    def method_missing(method_name, *args)
      case method_name.to_s
      when /^after_(.+)$/
        after $1, *args
      when /^before_(.+)$/
        before $1, *args
      else
        super
      end
    end

    def methods
      @methods ||= {}
    end

    def original_method(method_to_hook)
      "_big_spoon_original_#{method_to_hook}"
    end
  end
end

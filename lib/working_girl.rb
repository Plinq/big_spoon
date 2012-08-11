require 'working_girl/hook'

module WorkingGirl
  module ClassMethods
    def hooks(options = {}, &block)
      @hooks ||= Hook.for(self)
      @hooks.instance_eval(&block) if block_given?

      unless respond_to?(:_working_girl_original_method_added)
        class << self
          alias :_working_girl_original_method_added :method_added
          def _working_girl_alias_method_added(method_to_hook, *args)
            if @hooks.should_hook?(method_to_hook)
              @hooks.hook! method_to_hook
            end
          end
          alias :method_added :_working_girl_alias_method_added
        end
      end
      @hooks
    end # `hooks` method
  end # `ClassMethods` module
end # `WorkingGirl` module

Object.extend WorkingGirl::ClassMethods

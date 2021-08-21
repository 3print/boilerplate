module BaseHelper
  def included(receiver)
    if self.const_defined? :ExampleGroupMethods
      receiver.extend self::ExampleGroupMethods
    end

    if self.const_defined? :ExampleMethods
      receiver.send :include, self::ExampleMethods
    end
  end
end

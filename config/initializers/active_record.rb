module ActiveRecord
  class Base
    extend ToggleAttributes
    include Displayable
    include ValidationState
  end
end

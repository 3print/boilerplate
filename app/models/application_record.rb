class ApplicationRecord < ActiveRecord::Base
  include CommonExtensions

  self.abstract_class = true
end

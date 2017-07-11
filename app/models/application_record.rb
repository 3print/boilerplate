class ApplicationRecord < ActiveRecord::Base
  include Concerns::CommonExtensions

  self.abstract_class = true
end

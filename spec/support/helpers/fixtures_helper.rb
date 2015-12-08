require File.expand_path('../base_helper', __FILE__)

module FixturesHelper
  extend BaseHelper
  module ExampleMethods
    def image_fixture_path name='default.png'
      File.join(Rails.root, 'spec', 'fixtures', 'images', name)
    end

    def image_fixture name='default.png'
      File.open image_fixture_path(name), 'r'
    end

    def file_fixture_path name='file.txt'
      File.join(Rails.root, 'spec', 'fixtures', 'files', name)
    end

    def file_fixture name='file.txt'
      File.open file_fixture_path(name), 'r'
    end
  end
end

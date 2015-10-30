module DelayedImages
  def self.included base
    base.send :extend, ClassMethods
  end

  module ClassMethods
    def has_images *columns

      self.class_attribute :_images, :_images_tmp
      self._images     = columns
      self._images_tmp = columns.map {|c| :"#{c}_tmp" }

      self.define_callbacks :images_update

      columns.each do |column|
        uploader = ImageUploader
        column, uploader = column if column.is_a?(Array)
        self.mount_uploader column, uploader

        class_eval <<-RUBY, __FILE__, __LINE__+1

          def #{column}_tmp= value
            if value.present? && value != #{column}.url
              write_attribute :#{column}_tmp, value
              write_attribute :#{column}, nil
            else
              write_attribute :#{column}_tmp, nil
            end
          end

          def process_#{column}_tmp
            if #{column}_tmp?
              self.remote_#{column}_url = #{column}_tmp
              self.#{column}_tmp = nil
            end
          end

          def #{column}?
            super || #{column}_tmp?
          end

        RUBY

      end

      class_eval <<-RUBY, __FILE__, __LINE__+1

        def update_images
          run_callbacks :images_update do
            # TODO
            self._images.each do |column|
              self.send "process_\#{column}_tmp"
            end
            self.save!
            # Autosync.pack!("uuid = '\#{self.uuid}'") if self.respond_to?(:uuid)
          end
        end

        def images_ready?
          self._images.none? {|column| send "\#{column}_tmp?" }
        end

        def any_images_changed?
          self._images.any? {|column| send "\#{column}_changed?" }
        end

      RUBY

      self.after_save do
        self.delay(priority: 6).update_images unless images_ready?
      end

    end
  end
end

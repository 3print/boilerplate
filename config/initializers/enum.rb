
ActiveRecord::Enum.module_eval do
  def inherited(base) # :nodoc:
    base.defined_enums = defined_enums.deep_dup

    base.class_attribute(:defined_multiple_enums)
    base.defined_multiple_enums = {}
    base.defined_multiple_enums = defined_multiple_enums.deep_dup if respond_to?(:defined_multiple_enums)
    super
  end

  def enum(definitions)
    klass = self
    enum_prefix = definitions.delete(:_prefix)
    enum_suffix = definitions.delete(:_suffix)
    enum_multiple = definitions.delete(:_multiple)

    definitions.each do |name, values|
      # statuses = { }
      enum_values = ActiveSupport::HashWithIndifferentAccess.new
      name        = name.to_sym

      # def self.statuses statuses end
      detect_enum_conflict!(name, name.to_s.pluralize, true)
      klass.singleton_class.send(:define_method, name.to_s.pluralize) { enum_values }

      _enum_methods_module.module_eval do

        #    ##     ## ##     ## ##       ######## ####
        #    ###   ### ##     ## ##          ##     ##
        #    #### #### ##     ## ##          ##     ##
        #    ## ### ## ##     ## ##          ##     ##
        #    ##     ## ##     ## ##          ##     ##
        #    ##     ## ##     ## ##          ##     ##
        #    ##     ##  #######  ########    ##    ####
        if enum_multiple
          klass.send(:detect_enum_conflict!, name, "#{name}=")
          define_method("#{name}=") do |value|
            if value.all? { |v| enum_values.has_key?(v) || v.blank? }
              self[name] = value.map { |v| enum_values[v] }.uniq.compact
            elsif value.all? { |v| enum_values.has_value?(v) }
              # Assigning a value directly is not a end-user feature, hence it's not documented.
              # This is used internally to make building objects from the generated scopes work
              # as expected, i.e. +Conversation.archived.build.archived?+ should be true.
              self[name] = value.uniq.compact
            else
              raise ArgumentError, "'#{value}' is not a valid #{name}"
            end
          end
          # def status() statuses.key self[:status] end
          klass.send(:detect_enum_conflict!, name, name)
          define_method(name) { self[name].map { |v| enum_values.key(v) } }

          # def status_before_type_cast() statuses.key self[:status] end
          klass.send(:detect_enum_conflict!, name, "#{name}_before_type_cast")
          define_method("#{name}_before_type_cast") do
            self[name].map { |v| enum_values.key(v) }
          end

          pairs = values.respond_to?(:each_pair) ? values.each_pair : values.each_with_index

          pairs.each do |value, i|
            if enum_prefix == true
              prefix = "#{name}_"
            elsif enum_prefix
              prefix = "#{enum_prefix}_"
            else
              prefix = ''
            end

            if enum_suffix == true
              suffix = "_#{name}"
            elsif enum_suffix
              suffix = "_#{enum_suffix}"
            else
              suffix = ''
            end

            value_method_name = "#{prefix}#{value}#{suffix}"
            enum_values[value] = i

            # def active?() status == 0 end
            klass.send(:detect_enum_conflict!, name, "#{value_method_name}?")
            define_method("#{value_method_name}?") { self[name].include?(i) }

            # def active!() update! status: :active end
            klass.send(:detect_enum_conflict!, name, "#{value_method_name}!")
            define_method("#{value_method_name}!") {
              update! name => (self[name] + [enum_values[value]]).uniq
            }

            # scope :active, -> { where status: 0 }
            klass.send(:detect_enum_conflict!, name, value_method_name, true)
            klass.scope value_method_name, -> {
              klass.where("? = ANY (#{name})", i)
            }
          end

        #     ######  #### ##    ##  ######   ##       ########
        #    ##    ##  ##  ###   ## ##    ##  ##       ##
        #    ##        ##  ####  ## ##        ##       ##
        #     ######   ##  ## ## ## ##   #### ##       ######
        #          ##  ##  ##  #### ##    ##  ##       ##
        #    ##    ##  ##  ##   ### ##    ##  ##       ##
        #     ######  #### ##    ##  ######   ######## ########
        else
          # def status=(value) self[:status] = statuses[value] end
          klass.send(:detect_enum_conflict!, name, "#{name}=")
          define_method("#{name}=") { |value|
            if enum_values.has_key?(value) || value.blank?
              self[name] = enum_values[value]
            elsif enum_values.has_value?(value)
              # Assigning a value directly is not a end-user feature, hence it's not documented.
              # This is used internally to make building objects from the generated scopes work
              # as expected, i.e. +Conversation.archived.build.archived?+ should be true.
              self[name] = value
            else
              raise ArgumentError, "'#{value}' is not a valid #{name}"
            end
          }

          # def status() statuses.key self[:status] end
          klass.send(:detect_enum_conflict!, name, name)
          define_method(name) { enum_values.key self[name] }

          # def status_before_type_cast() statuses.key self[:status] end
          klass.send(:detect_enum_conflict!, name, "#{name}_before_type_cast")
          define_method("#{name}_before_type_cast") { enum_values.key self[name] }

          pairs = values.respond_to?(:each_pair) ? values.each_pair : values.each_with_index

          pairs.each do |value, i|
            if enum_prefix == true
              prefix = "#{name}_"
            elsif enum_prefix
              prefix = "#{enum_prefix}_"
            else
              prefix = ''
            end

            if enum_suffix == true
              suffix = "_#{name}"
            elsif enum_suffix
              suffix = "_#{enum_suffix}"
            else
              suffix = ''
            end

            value_method_name = "#{prefix}#{value}#{suffix}"
            enum_values[value] = i

            # def active?() status == 0 end
            klass.send(:detect_enum_conflict!, name, "#{value_method_name}?")
            define_method("#{value_method_name}?") { self[name] == i }

            # def active!() update! status: :active end
            klass.send(:detect_enum_conflict!, name, "#{value_method_name}!")
            define_method("#{value_method_name}!") { update! name => value }

            # scope :active, -> { where status: 0 }
            klass.send(:detect_enum_conflict!, name, value_method_name, true)
            klass.scope value_method_name, -> { klass.where name => i }
          end
        end
      end
      defined_enums[name.to_s] = enum_values
      defined_multiple_enums[name.to_s] = enum_values if enum_multiple
    end
  end
end

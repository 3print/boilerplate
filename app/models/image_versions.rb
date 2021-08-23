
module ImageVersions
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    def expose_versions_for(attr, versions)
      define_method :"exposed_versions_for_#{attr}" do
        versions
      end

      after_save do
        if saved_change_to_attribute?(:"#{attr}_regions")
          send(attr).recreate_versions!
        end
      end
    end
  end

  module InstanceMethods
    # Given carrierwave is processing files as soon as they're assigned
    # using attr= we need to patch assign_attributes to delay assignments
    # of files with regions
    def assign_attributes(attributes)
      attributes = Hash(attributes).stringify_keys

      # Find all fields with a _regions appendix that also have a defined
      # value
      attr_with_regions = attributes.keys
      .select { |k| /_regions$/ =~ k }
      .map { |k| k.gsub('_regions', '') }
      .select {|k| attributes[k].present? }
      .map { |k| [k, attributes[k]] }
      .to_h

      # Discard the file attr from the hash
      attr_with_regions.each_pair do |k, v|
        attributes.delete(k)
      end

      # Assign the rest of the attributes
      super

      # Finally, assign the files for the fields with regions
      attr_with_regions.each_pair do |k, v|
        self.send(:"#{k}=", v)
      end
    end
  end
end

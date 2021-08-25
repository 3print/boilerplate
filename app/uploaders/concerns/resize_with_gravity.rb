module ResizeWithGravity
  def resize_to_fill (*args)
    args = args[0].call if args[0].is_a?(Proc)

    gravity_key = :"#{mounted_as}_gravity"
    if self.model.respond_to?(gravity_key) && gravity = self.model.send(gravity_key)
      args[2] = "Magick::#{gravity.sub("#{mounted_as}_", "").camelize}Gravity".constantize
    end

    super(*args)
  end
end

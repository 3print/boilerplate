module JsonExtensions
  def arrayify(param_object)
    if param_object.is_a?(Hash)
      if param_object.keys.all? {|k| k.to_s =~ /^\d$/ }
        param_object.keys.sort.map {|k| arrayify(param_object[k]) }
      else
        param_object.each_pair do |k,v|
          param_object[k] = arrayify(v)
        end
        param_object
      end
    else
      param_object
    end
  end
end

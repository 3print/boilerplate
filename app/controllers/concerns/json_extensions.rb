module JsonExtensions
  def arrayify(param_object)
    if param_object.is_a?(ActionController::Parameters)
      if param_object.keys.all? {|k| k.to_s =~ /^\d+$/ }
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

  def rubyify(param_object)
    if param_object.is_a?(ActionController::Parameters)
      out = nil
      if param_object.keys.all? {|k| k.to_s =~ /^\d+$/ }
        out = {}.with_indifferent_access
        param_object.keys.sort.each do |k|
          out[k] = rubyify(param_object[k])
        end
      else
        out = {}.with_indifferent_access
        param_object.each_pair do |k, v|
          out[k] = rubyify(v)
        end
      end
      out
    else
      if param_object =~ /^\d+$/
        param_object.to_i
      elsif param_object =~ /^\d*\.\d+$/
        param_object.to_f
      elsif param_object == 'true'
        true
      elsif param_object == 'false'
        false
      elsif param_object == ''
        nil
      else
        param_object
      end
    end
  end
end

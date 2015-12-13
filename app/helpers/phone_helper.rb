module PhoneHelper
  def phone_number(phone)
    return '' if phone.nil?
    match = /(.+)?(\d{10})/.match phone.gsub(/[^\d\+]/, '')
    return phone if match.nil?

    prefix = match[1]
    numbers = match[2].gsub(/(.{2})/, '\1 ')
    [prefix, numbers].compact.join(' ')
  end
end

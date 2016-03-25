module PunditHelper
  def can?(method, record, attribute=nil)
    if attribute.present?
      policy(record).send(:"#{method}?", attribute)
    else
      policy(record).send(:"#{method}?")
    end
  end
end

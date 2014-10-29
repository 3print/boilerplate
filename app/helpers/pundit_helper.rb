module PunditHelper
  def can?(method, record)
    policy(record).send(:"#{method}?")
  end
end

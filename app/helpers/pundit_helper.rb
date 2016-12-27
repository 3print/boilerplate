module PunditHelper
  def can?(method, record, attribute=nil)
    if record.is_a?(Class)
      klass = record
      record = klass.new
    end

    if record.present?
      if attribute.present?
        policy(record).send(:"#{method}?", attribute)
      else
        policy(record).send(:"#{method}?")
      end
    end
  end

  def cannot?(*args)
    !can?(*args)
  end
end

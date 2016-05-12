module PunditHelper
  def can?(method, record, attribute=nil)
    if record.is_a?(Class)
      klass = record
      record = klass.new

      if @store.present?
        if association_columns(record, :belongs_to, :has_one).include?(:store)
          record.store = @store
        elsif association_columns(record, :has_and_belongs_to_many, :has_many).include?(:stores)
          record.stores = [@store]
        end
      end
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

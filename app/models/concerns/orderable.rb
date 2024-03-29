module Orderable

  def update_items_sequences(sequences)
    values = []
    sequences.each_pair do |k,v|
      values << "(#{k},#{v['sequence'].present? ? v['sequence'] : 0})"
    end

    query = """
    UPDATE #{self.table_name} AS s SET
      sequence = c.sequence
    FROM  (values
      #{values.join ",\n"}
    ) AS c(id, sequence)
    WHERE c.id = s.id
    """.gsub(/\s+/, ' ')

    ActiveRecord::Base.connection.execute(query)
  end
end

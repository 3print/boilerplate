require 'active_support/concern'

module Concerns::Orderable
  extend ActiveSupport::Concern

  def update_items_sequences(sequences)
    values = sequences.map {|k,v| "(#{k},#{v['sequence']})"}
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

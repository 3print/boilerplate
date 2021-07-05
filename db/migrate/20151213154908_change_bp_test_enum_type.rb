class ChangeBpTestEnumType < ActiveRecord::Migration[4.2]
  def change
    connection.execute(%q{
      ALTER TABLE bp_tests
      ALTER COLUMN "enum"
      TYPE integer USING CAST("enum" AS integer)
    })
  end
end

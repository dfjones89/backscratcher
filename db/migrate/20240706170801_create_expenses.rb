class CreateExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :expenses do |t|
      t.string :splitwise_id
      t.date :date
      t.decimal :amount
      t.text :description
      t.date :deleted_at
      t.timestamps
    end
  end
end

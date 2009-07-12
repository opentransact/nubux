class CreateTransacts < ActiveRecord::Migration
  def self.up
    create_table :transacts do |t|
      t.decimal :amount, :precision => 15, :scale => 2
      t.integer :payer_id
      t.integer :payee_id
      t.string :memo

      t.timestamps
    end
  end

  def self.down
    drop_table :transacts
  end
end

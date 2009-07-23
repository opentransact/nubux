class AddCallbackUrlToTransact < ActiveRecord::Migration
  def self.up
    add_column :transacts,:callback_url,:string
  end

  def self.down
    remove_column :transacts,:callback_url
  end
end

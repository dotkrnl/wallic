class CreateWallets < ActiveRecord::Migration
  def change
    create_table :wallets do |t|
      t.string :name
      t.text :detail
      t.string :secret_read
      t.string :secret_rw

      t.timestamps
    end
  end
end

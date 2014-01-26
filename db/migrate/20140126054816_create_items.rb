class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name
      t.text :detail
      t.decimal :delta
      t.timestamp :time
      t.references :wallet, index: true

      t.timestamps
    end
  end
end

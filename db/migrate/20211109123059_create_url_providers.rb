class CreateUrlProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :url_providers do |t|
      t.string :name
      t.integer :links_shortened_amount
      t.boolean :active

      t.timestamps
    end
  end
end

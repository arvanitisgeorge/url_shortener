class AddDefaultValuesToUrlProvider < ActiveRecord::Migration[5.1]
  def change
    change_column_default :url_providers, :links_shortened_amount, 0
    change_column_default :url_providers, :active, 1
    add_index :url_providers, :name, unique: true
  end
end

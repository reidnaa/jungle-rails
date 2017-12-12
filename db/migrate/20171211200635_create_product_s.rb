class CreateProductS < ActiveRecord::Migration
  def change
    create_table :product_s do |t|

      t.timestamps null: false
    end
  end
end

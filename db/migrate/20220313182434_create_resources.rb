class CreateResources < ActiveRecord::Migration[6.1]
  def change
    create_table :resources do |t|
      t.float :latitude
      t.float :longitude
      t.boolean :education
      t.boolean :employment
      t.boolean :food
      t.boolean :health
      t.boolean :housing
      t.boolean :legal
      t.boolean :lgbtq
      t.boolean :money
      t.boolean :multicultural
      t.boolean :transportation
      t.text :description
      t.string :name
      t.timestamps
    end
  end
end

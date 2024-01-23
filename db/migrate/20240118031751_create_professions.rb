class CreateProfessions < ActiveRecord::Migration[7.1]
  def change
    create_table :professions do |t|
      t.integer :industry, null: false

      t.timestamps
    end
  end
end

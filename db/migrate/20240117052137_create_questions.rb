class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :subject , null: false
      t.text :body      , null: false
      t.datetime :deadline
      t.string :keyword , null: false

      t.timestamps
    end
  end
end

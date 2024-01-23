class CreateQuestionProfessions < ActiveRecord::Migration[7.1]
  def change
    create_table :question_professions do |t|
      t.references :question, null: false, foreign_key: true
      t.references :profession, null: false, foreign_key: true

      t.timestamps
    end
  end
end

module AnswersHelper
  def answer_text
    Answer.column_names.select { |column| Answer.columns_hash[column].type == :text }
  end
end

class AnswersController < ApplicationController
  def create
    @answer = current_user.answers.new(answer_params)
    @answer.save
  end

  private

  def answer_params
    params.require(:answer).permit(:must, :want, :body, :question_id)
  end
end

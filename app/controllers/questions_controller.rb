class QuestionsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :set_industries, only: %i[new create]

  # GET /questions or /questions.json
  def index
    # application_controllerに記載
  end

  # GET /questions/1 or /questions/1.json
  def show
    @question = Question.includes(:professions, answers: :user).find(params[:id])
    @answer = Answer.new
    @answers = @question.answers.order(id: :desc).page(params[:page])
    similar = Question.other(@question).ransack(subject_or_body_cont_any: key_word(@question))
    @similar_questions = similar.result(distinct: true).includes(:professions).page(params[:page]).per(10)
  end

  # GET /questions/new
  def new
    @form = QuestionForm.new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
  end

  # POST /questions or /questions.json
  def create
    @form = QuestionForm.new(question_params)

    if @form.save
      redirect_to root_path, flash: { success: '質問を作成しました' }
    else
      flash.now[:error] = '不備があります'
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /questions/1 or /questions/1.json
  def update
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @uestion = current_user.questions.find(params[:id])
    @uestion.destroy!
    redirect_to root_path, status: :see_other, success: '質問を削除しました'
  end

  def mine
    @questions = Question.where(user_id: current_user.id).includes(:professions).page(params[:page]).per(10)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def set_industries
    @industries = Profession.industries
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question_form)
          .permit(:subject, :body, :deadline_time, :deadline_date, profession_ids: [])
          .merge(user_id: current_user.id)
  end

  def key_word(word)
    word.keyword.split(',')
  end
end

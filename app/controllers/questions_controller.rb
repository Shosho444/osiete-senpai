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
    @question = Question.includes(:professions).find(params[:id])
  end

  # GET /questions/new
  def new
    @form = QuestionForm.new
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
end

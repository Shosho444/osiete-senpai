class QuestionsController < ApplicationController
  skip_before_action :require_login, only: [:index, :show]
  before_action :set_question, only: %i[show edit update destroy]

  # GET /questions or /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1 or /questions/1.json
  def show
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
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to question_url(@question), notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1 or /questions/1.json
  def destroy
    @question.destroy!

    respond_to do |format|
      format.html { redirect_to questions_url, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def question_params
    params.require(:question_form).permit(:subject, :body, :deadline, profession_ids: []).merge(user_id: current_user.id)
  end
end

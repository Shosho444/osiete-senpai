class ApplicationController < ActionController::Base
  before_action :require_login, :set_search

  private

  def set_search
    @search = Question.ransack(params[:q])
    @questions = @search.result(distinct: true).includes(:professions)
  end

  def not_authenticated
    redirect_to login_path, flash: { error: 'ログインしてください' }
  end
end

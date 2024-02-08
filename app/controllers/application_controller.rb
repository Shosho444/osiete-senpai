class ApplicationController < ActionController::Base
  before_action :require_login, :set_search

  private

  def set_search
    request = request_judgment(params[:q]) if params[:q]
    @search = Question.ransack(request)
    @questions = @search.result(distinct: true).includes(:professions)
  end

  def not_authenticated
    redirect_to login_path, flash: { error: 'ログインしてください' }
  end

  def request_judgment(hash)
    hash.values[0].match?(/[[:space:]]/) ? hash_change(hash) : hash
  end

  def hash_change(hash)
    value = hash.values[0].split(/[[:space:]]/).reject(&:empty?)
    key = hash.keys[0].dup.concat('_all').freeze
    { key => value }
  end
end

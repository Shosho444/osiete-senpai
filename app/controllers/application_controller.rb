class ApplicationController < ActionController::Base
  before_action :require_login, :set_search

  private

  def set_search
    request = request_judgment(params[:q]) if params[:q]
    @search = Question.ransack(request)
    @questions = @search.result(distinct: true).includes(:professions).page(params[:page]).per(10)
  end

  def not_authenticated
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace('modal', partial: 'hidden/modalal') }
      format.html { redirect_to recommendation_path, data: { turbo_frame: 'review_modal' } }
    end
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

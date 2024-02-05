class IndustriesController < ApplicationController
  skip_before_action :require_login

  def index
    @industries = Profession.industries
  end
end

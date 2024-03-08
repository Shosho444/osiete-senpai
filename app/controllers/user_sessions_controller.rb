class UserSessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :modal]
  def new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      flash[:success] = 'ログインに成功しました'
      redirect_back_or_to root_path
    else
      flash.now[:error] = 'ログインに失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path, status: :see_other, flash: { success: 'ログアウトしました' }
  end

  def modal
  end
end

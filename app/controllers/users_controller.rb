class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :show]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_back_or_to root_path, success: '登録が成功しました'
    else
      flash.now[:error] = '登録が失敗しました'
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to user_path(current_user)
      flash[:success] = 'プロフィール更新しました'
    else
      flash.now[:error] = 'プロフィールを更新出来ませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation)
  end

  def profile_params
    params.require(:user).permit(:name, :introduction)
  end
end

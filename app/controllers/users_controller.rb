class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_back_or_to root_path, success: '登録が成功しました'
    else
      flash.now[:error] = '登録が失敗しました'
      render :new, status: :unprocessable_entity
      # エラーメッセージ表示に必要
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :email_confirmation, :password, :password_confirmation)
  end
end

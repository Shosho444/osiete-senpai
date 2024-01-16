require 'rails_helper'

RSpec.describe User, type: :model do
  it '姓、名、メールがあり、パスワードは3文字以上であれば有効であること' do
    user = build(:user)
    expect(user).to be_valid
  end

  it 'メールはユニークであること' do
    user1 = create(:user)
    user2 = build(:user)
    user2.email = user1.email
    user2.valid?
    expect(user2.errors[:email]).to include('はすでに存在します')
  end

  it '確認用のパスワードメールアドレス姓名は必須項目であること' do
    user = build(:user)
    user.email = nil
    user.name = nil
    user.password_confirmation = nil
    user.valid?
    expect(user.errors[:email]).to include('を入力してください')
    expect(user.errors[:name]).to include('を入力してください')
    expect(user.errors[:password_confirmation]).to include('を入力してください')
  end

  it '姓名は255文字以下であること' do
    user = build(:user)
    user.name = 'a' * 256
    user.email = 'b' * 256
    user.introduction = 'c' * 256
    user.valid?
    expect(user.errors[:name]).to include('は255文字以内で入力してください')
    expect(user.errors[:email]).to include('は255文字以内で入力してください')
    expect(user.errors[:introduction]).to include('は255文字以内で入力してください')
  end

  it 'パスワードとmailの形式が正しいこと' do
    user = build(:user)
    user.email = 'meto@mail'
    user.password = 'b' * 8
    user.valid?
    expect(user.errors[:email]).to include('の形式が正しくありません')
    expect(user.errors[:password]).to include('に英数字を含めてください')
  end

  it '確認用のパスワードメールアドレスが必須項目であること' do
    user = build(:user)
    user.email_confirmation = nil
    user.valid?
    expect(user.errors[:email_confirmation]).to include('を入力してください')
  end
end

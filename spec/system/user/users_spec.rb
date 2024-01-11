require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  context '入力情報正常系' do
    it 'ユーザーが新規作成できること' do
      visit '/users/new'
      expect do
        fill_in '名前', with: 'らんてっく'
        fill_in 'メールアドレス', with: 'example@example.com'
        fill_in '確認用メールアドレス', with: 'example@example.com'
        fill_in 'パスワード', with: 'S12345678'
        fill_in '確認用パスワード', with: 'S12345678'
        click_button '登録'
        Capybara.assert_current_path('/', ignore_query: true)
      end.to change { User.count }.by(1)
      expect(page).to have_content('登録が成功しました'), 'フラッシュメッセージ「ユーザー登録が完了しました」が表示されていません'
    end
  end

  context '入力情報異常系' do
    it 'ユーザーが新規作成できない' do
      visit '/users/new'
      expect do
        fill_in 'メールアドレス', with: 'example@example.com'
        click_button '登録'
      end.to change { User.count }.by(0)
      expect(page).to have_content('登録が失敗しました'), 'フラッシュメッセージ「ユーザー登録に失敗しました」が表示されていません'
    end
  end
end

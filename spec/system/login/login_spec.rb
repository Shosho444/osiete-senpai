require 'rails_helper'

RSpec.describe 'ログイン', type: :system do
  let(:user) { create(:user) }
  describe 'ログイン' do
    it '正常にログインできる' do
      visit '/login'
      fill_in 'email', with: user.email
      fill_in 'password', with: 'test12'
      click_on 'log'
      expect(page).to have_content('ログインに成功しました'), 'フラッシュメッセージ「ログインに成功しました」が表示されていません'
    end
  end

  context 'PWに誤りがある場合' do
    it 'ログインできないこと' do
      visit '/login'
      fill_in 'email', with: user.email
      fill_in 'password', with: '1234test'
      click_button 'ログイン'
      expect(current_path).to eq('/login'), 'ログイン失敗時にログイン画面に戻ってきていません'
      expect(page).to have_content('ログインに失敗しました'), 'フラッシュメッセージ「ログインに失敗しました」が表示されていません'
    end
  end

  describe 'ログアウト' do
    before do
      login_as(user)
    end
    it 'ログアウトできること' do
      click_on('ログアウト')
      expect(current_path).to eq root_path
      expect(page).to have_content('ログアウトしました'), 'フラッシュメッセージ「ログアウトしました」が表示されていません'
    end
  end
end

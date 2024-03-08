require 'rails_helper'

RSpec.describe 'ログイン', type: :system do
  let(:user) { create(:user) }
  context 'ログイン' do
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

  context 'ログインしていない場合' do
    it 'モーダルが表示されること' do
      visit edit_user_path(user)
      expect(current_path).to eq(recommendation_path), 'ログイン失敗時に確認画面に戻ってきていません'
      expect(page).to have_content('ログインが必要です'), 'フラッシュメッセージ「ログインしてください」が表示されていません'
    end
    it 'きちんと登録ページに左遷すること' do
      visit edit_user_path(user)
      within('#check') do
        click_on '新規登録'
      end
      expect(current_path).to eq(new_user_path), '登録ページに遷移しておりません'
    end
  end

  context 'ログアウト' do
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

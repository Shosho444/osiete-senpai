require 'rails_helper'

RSpec.describe 'ユーザー登録', type: :system do
  let(:user) { create(:user) }
  let(:anouser) { create(:user) }
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

  context 'プロフィール' do
    before do
      login_as(user)
    end
    it 'プロフィールが表示される' do
      visit user_path(user)
      expect(page).to have_content(user.email), 'ユーザーのemailが表示されていません'
      expect(page).to have_content(user.name), 'ユーザーのnameが表示されていません'
      expect(page).to have_content('紹介文を追加する'), 'ボタンの表示が変わっていません'
    end
    it 'プロフィールが変更される' do
      visit edit_user_path(user)
      expect do
        fill_in '名前', with: 'ランてくん2号'
        fill_in '自己紹介文', with: 'おいら、頑張るぞ'
        click_button '編集する'
      end.to change { User.count }.by(0)
      expect(current_path).to eq user_path(user)
      expect(page).to have_content('ランてくん2号'), 'ユーザーのnameが変更されていません'
      expect(page).to have_content('おいら、頑張るぞ'), 'ユーザーの紹介文が変更されていません'
      expect(page).to have_content('プロフィールを編集する'), 'ボタンの表示が変わっていません'
    end
    it '名前が未入力の時、変更が失敗する' do
      visit edit_user_path(user)
      expect do
        fill_in '名前', with: nil
        fill_in '自己紹介文', with: 'おいら、頑張るぞ'
        click_button '編集する'
      end.to change { User.count }.by(0)
      expect(page).to have_content('プロフィールを更新出来ませんでした'), 'プロフィールが変更できています'
      expect(page).to have_content('名前を入力してください'), '名前が変更できています'
    end
    it '他人のプロフィールを見れる' do
      visit user_path(anouser)
      expect(page).to have_content(anouser.name), '他のユーザーのnameが表示されていません'
      expect(page).not_to have_content(anouser.email), '他のユーザーのemailが表示されています'
      expect(page).not_to have_content('紹介文を追加する'), 'ボタンが表示されてます'
    end
    it '他人のプロフィールを変更できない' do
      visit edit_user_path(anouser)
      expect do
        fill_in '名前', with: 'ランてくん2号'
        fill_in '自己紹介文', with: 'おいら、頑張るからな'
        click_button '編集する'
      end.to change { User.count }.by(0)
      expect(current_path).to eq user_path(user)
      expect(page).to have_content(user.email), '他のユーザーのnameが変更されています'
      expect(page).to have_content('おいら、頑張るからな'), 'ユーザーの自己紹介が変更できています'
    end
  end
end

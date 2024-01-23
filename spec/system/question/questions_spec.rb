RSpec.describe 'ユーザー登録', type: :system do
  let(:user) { create(:user) }
  let(:anouser) { create(:user) }
  context '質問作成' do
    before do
      login_as(user)
    end
    it '質問が作成される' do
      visit new_question_path
      fill_in 'question_form[subject]', with: '秋がとても好きです。'
      fill_in 'question_form[body]', with: 'あなたはどの季節が好きですか？'
      check('question_form[profession_ids][]', option: '1')
      check('question_form[profession_ids][]', option: '2')
      click_button '質問を作成する'
      expect(page).to have_content('質問を作成しました'), '質問が作成できていません'
    end
    it '必要項目が入力されてない時エラーが出る' do
      visit new_question_path
      fill_in 'question_form[subject]', with: nil
      fill_in 'question_form[body]', with: nil
      click_button '質問を作成する'
      expect(page).to have_content('不備があります'), '質問が作成されてしまいました'
      expect(page).to have_content('テーマは5文字以上で入力してください'), 'テーマのバリテーションが出ておりません'
      expect(page).to have_content('本文は5文字以上で入力してください'), '本文のバリテーションが出ておりません'
      expect(page).to have_content('業種を選択してください'), 'チェックボックスのバリテーションが出ておりません'
    end
  end
end

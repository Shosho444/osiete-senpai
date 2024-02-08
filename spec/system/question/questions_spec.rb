RSpec.describe '質問', type: :system do
  let(:user) { create(:user) }
  let(:anouser) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }
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
  context '質問一覧' do
    before do
      login_as(user)
    end
    it '質問が作成されて一覧に表示される' do
      visit new_question_path
      fill_in 'question_form[subject]', with: '秋がとても好きです。'
      fill_in 'question_form[body]', with: 'あなたはどの季節が好きですか？'
      check('question_form[profession_ids][]', option: '1')
      click_button '質問を作成する'
      expect(page).to have_content('秋がとても好きです。'), '主題が表示されていません'
      expect(page).to have_content('農林水産業'), 'カテゴリが表示されていません'
    end
    it '質問の詳細ページが表示される' do
      visit question_path(question)
      expect(page).to have_content(question.subject), '主題が表示されていません'
      expect(page).to have_content(question.body), '主題が表示されていません'
      expect(page).to have_content(user.name), '主題が表示されていません'
      expect(page).to have_content('農林水産業'), 'カテゴリーが表示されていません'
      expect(page).to have_content('締切期間まで後2日'), '締切が表示されていません'
    end
    it '質問の詳細ページから質問者ページに左遷される' do
      visit question_path(question)
      click_link question.user.name
      expect(current_path).to eq user_path(user)
      expect(page).to have_content(user.name), 'ユーザーの名前が表示されていません'
    end
    it '検索した単語が表示される' do
      visit root_path
      fill_in 'q[subject_or_body_cont]', with: question.subject
      click_button '検索'
      expect(page).to have_content(question.subject), '検索されていません'
    end
    it '分割した単語が表示される' do
      visit root_path
      fill_in 'q[subject_or_body_cont]', with: '秋 好き'
      click_button '検索'
      expect(page).to have_content(question.subject), '検索されていません'
    end
    it '検索項目がない場合、正しく表示される' do
      visit root_path
      fill_in 'q[subject_or_body_cont]', with: 'この項目は見つかりません'
      click_button '検索'
      expect(page).to have_content('なし'), 'なしと表示されていません'
    end
  end
end

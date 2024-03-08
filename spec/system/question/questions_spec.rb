RSpec.describe '質問', type: :system do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
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
      expect(current_path).to eq user_path(question.user)
      expect(page).to have_content(user.name), 'ユーザーの名前が表示されていません'
    end
    it '締切時間が表示される' do
      visit question_path(question)
      expect(page).to have_content("締切期間まで後#{(question.deadline.to_date - Time.zone.today).to_i}日"), '締切日時が表示されていません'
      travel_to Time.current.beginning_of_day.days_since(2) do
        visit question_path(question)
        expect(page).to have_content("締切期間まで後#{question.deadline.hour - Time.current.hour}時間"), '締切時間が表示されていません'
      end
    end
    it '締切時間が過ぎた場合、終了の表示がされる' do
      travel_to Time.current.beginning_of_day.days_since(3) do
        visit question_path(question)
        expect(page).to have_content('締切期間を終了しました'), '終了表示が表示されていません'
      end
    end
    it '検索した単語が表示される' do
      visit root_path
      fill_in 'q[subject_or_body_cont]', with: question.subject
      click_button '検索'
      expect(page).to have_content(question.subject), '検索されていません'
    end
    it '分割した単語が表示される' do
      visit root_path
      fill_in 'q[subject_or_body_cont]', with: 'あなた 何歳'
      click_button '検索'
      expect(page).to have_content(question.subject), '検索されていません'
    end
    it '検索項目がない場合、正しく表示される' do
      visit root_path
      fill_in 'q[subject_or_body_cont]', with: 'この項目は見つかりません'
      click_button '検索'
      expect(page).to have_content('質問がありません'), '質問がありませんと表示されていません'
    end
  end
  context '類似質問がなし' do
    it '類似質問がない場合表示されない' do
      visit question_path(question)
      expect(page).to have_content('類似した質問はありません'), 'メッセージが表示されません。'
    end
  end
  context '類似質問がある' do
    let!(:another_question) { create(:question) }
    it '類似質問がある場合表示される' do
      visit question_path(question)
      expect(page).to have_content(another_question.subject), '類似質問が表示されません。'
    end
  end
  context 'ページネーション' do
    before do
      create_list(:question, 20)
    end
    it 'ページネーションが表示される' do
      visit root_path
      expect(page).to have_selector('.pagination'), 'ページネーションが表示されません。'
      click_on '2', match: :first
      expect(page).to have_content('農林水産業'), '質問が表示されません。'
    end
    it '類似質問でページネーションがが表示される' do
      visit question_path(question)
      expect(page).to have_selector('.pagination'), 'ページネーションが表示されません。'
      click_on '2', match: :first
      expect(page).to have_content('農林水産業'), '質問が表示されません。'
    end
  end
end

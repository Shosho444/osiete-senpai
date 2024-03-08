RSpec.describe '質問', type: :system do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question_id: question.id) }
  context '回答作成' do
    before do
      login_as(user)
    end
    it '必要項目が入力された時成功する' do
      visit question_path(question)
      fill_in 'answer_must', with: '必要事項'
      fill_in 'answer_want', with: '追加事項です'
      fill_in 'answer_body', with: '本文作成を行います'
      click_button '回答を作成する'
      visit question_path(question)
      expect(page).to have_content('必要事項'), 'mustが反映されていません'
      expect(page).to have_content('追加事項です'), 'wantが反映されていません'
      expect(page).to have_content('本文作成を行います'), '本文が反映されていません'
    end
    it '必要項目が入力されてない時エラーが出る' do
      visit question_path(question)
      fill_in 'answer_must', with: nil
      fill_in 'answer_want', with: nil
      fill_in 'answer_body', with: '本文作成'
      click_button '回答を作成する'
      expect(page).to have_content('必要事項を入力してください'), 'mustのバリテーションが出ておりません'
      expect(page).to have_content('追加事項を入力してください'), 'wantのバリテーションが出ておりません'
      expect(page).to have_content('本文は5文字以上で入力してください'), '本文のバリテーションが出ておりません'
    end
  end
  context '回答一覧' do
    before do
      login_as(user)
      create_list(:answer, 20)
    end
    it '内容がきちんと表示されている' do
      visit question_path(question)
      expect(page).to have_content(answer.must), 'mustが表示されていません'
      expect(page).to have_content(answer.want), 'wantが表示されていません'
      expect(page).to have_content(answer.body), '本文が表示されていません'
    end
    it 'ページネーションが表示される' do
      visit question_path(question)
      expect(page).to have_selector('.pagination'), 'ページネーションが表示されません。'
    end
  end
end

RSpec.describe 'カテゴリ', type: :system do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  context 'カテゴリ検索' do
    it 'カテゴリ検索が行われる' do
      visit industries_path
      click_link question.professions.industries.first.first
      expect(current_path).to eq questions_path
      expect(page).to have_content(question.professions.industries.first.first), '質問が表示されていません'
    end
    it 'カテゴリがない場合の表示がされる' do
      visit industries_path
      click_link 'その他の産業'
      expect(current_path).to eq questions_path
      expect(page).to have_content('質問がありません'), '質問がありませんと表示されていません'
    end
  end
end

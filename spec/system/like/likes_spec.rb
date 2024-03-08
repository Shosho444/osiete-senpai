RSpec.describe 'いいね', type: :system do
  let(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question_id: question.id) }
  let!(:question_like) { create(:like, :question, user:) }
  let!(:answer_like) { create(:like, :answer, user:) }
  context '未ログイン' do
    it '質問にいいねを押せること' do
      visit question_path(question)
      find_by_id("notlike-#{question.class.name}-#{question.id}").click
      expect(page).to have_content('ログインが必要です'), 'モーダルが表示されていません'
    end
  end
  context 'いいね作成' do
    before do
      login_as(user)
    end
    it '質問にいいねを押せること' do
      visit question_path(question)
      find_by_id("notlike-#{question.class.name}-#{question.id}").click
      visit question_path(question)
      expect(page).to have_selector("#like-#{question.class.name}-#{question.id}"), 'いいねができておりません'
      expect(question.likes.count).to eq(1)
    end
    it '質問のいいねが解除できること' do
      visit question_path(question_like.likeable_id)
      find_by_id("like-#{question_like.likeable_type}-#{question_like.likeable_id}").click
      visit question_path(question_like.likeable_id)
      expect(page).to have_selector("#notlike-#{question_like.likeable_type}-#{question_like.likeable_id}"), 'いいねが解除できておりません'
      expect(question.likes.count).to eq(0)
    end
    it '回答にいいねを押せること' do
      visit question_path(question)
      find_by_id("notlike-#{answer.class.name}-#{answer.id}").click
      visit question_path(question)
      expect(page).to have_selector("#like-#{answer.class.name}-#{answer.id}"), 'いいねができておりません'
      expect(answer.likes.count).to eq(1)
    end
    it '回答のいいねが解除できること' do
      visit question_path(question)
      find_by_id("notlike-#{answer.class.name}-#{answer.id}").click
      visit question_path(question)
      find_by_id("like-#{answer.class.name}-#{answer.id}").click
      visit question_path(question)
      expect(page).to have_selector("#notlike-#{answer.class.name}-#{answer.id}"), 'いいねが解除できておりません'
      expect(answer.likes.count).to eq(0)
    end
  end
end

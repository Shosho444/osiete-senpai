require 'rails_helper'

RSpec.describe Like, type: :model do
  describe '回答作成' do
    before do
      @liked = create(:like, :question)
      @like = build(:like, :question)
    end

    context '内容に問題がない場合' do
      it 'すべての値が正しく入力されている時バリデーションをスキップすること' do
        expect(@like).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'likeable_idとlikeable_typeが空欄の場合失敗すること' do
        @like.likeable_type = nil
        @like.likeable_id = nil
        @like.valid?
        expect(@like.errors[:likeable_id]).to include('を入力してください')
        expect(@like.errors[:likeable_type]).to include('を入力してください')
      end
      it 'likeable_idとlikeable_typeとuser_idの組み合わせがすでに存在する場合失敗すること' do
        like2 = build(:like, :question)
        like2.likeable_id = @liked.likeable_id
        like2.user = @liked.user
        like2.valid?
        expect(like2.errors.full_messages).to include('Likeableはすでに同じデータが存在します')
      end
    end
  end
end

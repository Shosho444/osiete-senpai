require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe '回答作成' do
    before do
      @answer = build(:answer)
    end

    context '内容に問題がない場合' do
      it 'すべての値が正しく入力されていれば購入できること' do
        expect(@answer).to be_valid
      end
      it '本文が10666文字以下の場合成功すること' do
        @answer.must = 'a' * 10_666
        @answer.want = 'a' * 10_666
        @answer.body = 'a' * 10_666
        expect(@answer).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it 'mustとwantが空欄の場合失敗すること' do
        @answer.must = nil
        @answer.want = nil
        @answer.valid?
        expect(@answer.errors[:must]).to include('を入力してください')
        expect(@answer.errors[:want]).to include('を入力してください')
      end
      it 'bodyが5文字以下の場合失敗すること' do
        @answer.body = '四文字だ'
        @answer.valid?
        expect(@answer.errors[:body]).to include('は5文字以上で入力してください')
      end
      it '入力内容が10667以上の場合失敗すること' do
        @answer.must = 'a' * 10_667
        @answer.want = 'a' * 10_667
        @answer.body = 'a' * 10_667
        @answer.valid?
        expect(@answer.errors[:body]).to include('は10666文字以内で入力してください')
        expect(@answer.errors[:must]).to include('は10666文字以内で入力してください')
        expect(@answer.errors[:want]).to include('は10666文字以内で入力してください')
      end
    end
  end
end

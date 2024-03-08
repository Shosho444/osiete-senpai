require 'rails_helper'

RSpec.describe @questionform, type: :model do
  describe '質問作成' do
    before do
      @login_user = create(:user)
      @questionform = build(:question_form, user_id: @login_user.id)
    end

    context '内容に問題がない場合' do
      it 'すべての値が正しく入力されていれば購入できること' do
        expect(@questionform).to be_valid
      end
      it '業種が空欄でも上手くいくこと' do
        @questionform.deadline_date = ''
        @questionform.deadline_time = ''
        expect(@questionform).to be_valid
      end
      it '本文が10666文字以下の場合成功すること' do
        @questionform.body = 'a' * 10_666
        expect(@questionform).to be_valid
      end
    end

    context '内容に問題がある場合' do
      it '本文とテーマが四文字以下の場合失敗すること' do
        @questionform.subject = '四文字だ'
        @questionform.body = '四文字だ'
        @questionform.valid?
        expect(@questionform.errors[:subject]).to include('は5文字以上で入力してください')
        expect(@questionform.errors[:body]).to include('は5文字以上で入力してください')
      end
      it 'テーマが256文字以上の場合失敗すること' do
        @questionform.subject = 'a' * 256
        @questionform.valid?
        expect(@questionform.errors[:subject]).to include('は255文字以内で入力してください')
      end
      it '本文が65535文字以上の場合失敗すること' do
        @questionform.body = 'a' * 10_667
        @questionform.valid?
        expect(@questionform.errors[:body]).to include('は10666文字以内で入力してください')
      end
      it '業種がない場合失敗すること' do
        @questionform.profession_ids = ''
        @questionform.valid?
        expect(@questionform.errors[:profession_ids]).to include('を選択してください')
      end
      it '12時以前で今日を選んでいる時失敗すること' do
        travel_to Time.current.beginning_of_day do
          @questionform.deadline_date = Time.zone.today
          @questionform.valid?
          expect(@questionform.errors[:deadline]).to include('は明日以降の時間を選択してください')
        end
      end
      it '12時以降で明日を選んでいる時失敗すること' do
        travel_to Time.current.beginning_of_day + 12.hours do
          @questionform.deadline_date = Time.zone.tomorrow
          @questionform.valid?
          expect(@questionform.errors[:deadline]).to include('は明後日以降の時間を選択してください')
        end
      end
      it '日付を選んでいない場合失敗すること' do
        @questionform.deadline_date = ''
        @questionform.valid?
        expect(@questionform.errors.full_messages).to include('日付と時間の両方を入力してください')
      end
      it '時間を選んでいない場合失敗すること' do
        @questionform.deadline_time = ''
        @questionform.valid?
        expect(@questionform.errors.full_messages).to include('日付と時間の両方を入力してください')
      end
    end
  end
end

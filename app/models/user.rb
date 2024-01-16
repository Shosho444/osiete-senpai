class User < ApplicationRecord
  authenticates_with_sorcery!

  pass_f = /\A(?=.*?[a-z])(?=.*?[A-Z])(?=.*?\d)[a-zA-Z\d]+\z/i
  validates :password, length: { minimum: 6 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, format: { with: pass_f, message: 'に英数字を含めてください' }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true, confirmation: true, length: { maximum: 255 }, presence: true
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i, message: 'の形式が正しくありません' }
  validates :email_confirmation, presence: true, if: :email_changed?
  validates :name, presence: true, length: { maximum: 255 }
  validates :introduction, length: { maximum: 255 }

  def introduce
    if introduction.present?
      'プロフィールを編集する'
    else
      '紹介文を追加する'
    end
  end
end

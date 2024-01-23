class Profession < ApplicationRecord
  has_many :question_professions, dependent: :destroy
  has_many :questions, through: :question_professions

  validates :industry, presence: true

  enum industry: {
    '農林水産業': 1,
    '建設業': 2,
    '製造業': 3,
    '運輸・物流業': 4,
    '卸売・小売・飲食業': 5,
    '金融・不動産業': 6,
    '情報通信業': 7,
    'サービス業': 8,
    'その他の産業': 9
  }
end

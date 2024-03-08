class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  with_options presence: true do
    validates :likeable_type
    validates :likeable_id, uniqueness: { scope: [:likeable_type, :user_id],
                                          message: 'はすでに同じデータが存在します' }
  end
end

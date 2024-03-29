module SystemHelper
  def login_as(user)
      visit root_path
      click_link 'ログイン'
      fill_in 'email', with: user.email
      fill_in 'password', with: 'test12'
      click_button 'ログイン'
    end
  end

  def create_like(type,user)
    let!(:like) { create(:like, user:user, likeable_type:type.class.name, likeable_id:type.id) }
  end

  RSpec.configure do |config|
    config.include SystemHelper
  end
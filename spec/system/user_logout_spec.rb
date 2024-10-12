require 'rails_helper'

RSpec.describe 'Books management after login', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    # ログインする
    sign_in user
  end

  scenario 'User can access books index after login' do
    # ログイン後のリダイレクト先 (書籍一覧ページ)
    visit books_path

    click_link 'ログアウト'

    expect(page).to have_content 'ログアウトしました。'
    expect(page).to have_current_path(new_user_session_path)
  end
end

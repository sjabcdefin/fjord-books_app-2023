# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books management after login', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  # ログアウト　パス確認
  scenario 'User can access books index after login(path)' do
    visit books_path

    click_link 'ログアウト'

    expect(page).to have_current_path(new_user_session_path)
  end

  # ログアウト　メッセージ確認
  scenario 'User can access books index after login(message)' do
    visit books_path

    click_link 'ログアウト'

    expect(page).to have_content 'ログアウトしました。'
  end
end

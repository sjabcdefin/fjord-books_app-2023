# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books management after login', type: :system do
  let!(:users) { FactoryBot.create_list(:user, 3) }

  before do
    sign_in users[0]
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

require 'rails_helper'

RSpec.describe 'User Login', type: :system do

  let!(:user) { FactoryBot.create(:user) }

  # ログイン成功確認
  scenario 'User log in successfully with valid data' do
    visit new_user_session_path

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_content 'ログインしました。'
    expect(page).to have_current_path(books_path)
  end

  # ログイン失敗の確認（エラーメッセージの確認）
  # Eメールアドレスが間違っている場合
  scenario 'User log in fails when email is missing' do
    visit new_user_session_path

    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_content "Eメールまたはパスワードが違います。"
    expect(page).to have_current_path(new_user_session_path)
  end

  # パスワードが間違っている場合
  scenario 'User log in fails when password is missing' do
    visit new_user_session_path

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password012'
  
    click_button 'ログイン'
  
    expect(page).to have_content "Eメールまたはパスワードが違います。"
    expect(page).to have_current_path(new_user_session_path)
  end
end

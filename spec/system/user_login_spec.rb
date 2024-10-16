# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Login', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  # ログイン成功 パス確認
  scenario 'User log in successfully with valid data(path)' do
    visit new_user_session_path

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_current_path(books_path)
  end

  # ログイン成功 メッセージ確認
  scenario 'User log in successfully with valid data(message)' do
    visit new_user_session_path

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_content 'ログインしました。'
  end

  # ログイン失敗の確認
  # Eメールアドレスが間違っている場合（パス確認）
  scenario 'User log in fails when email is missing(path)' do
    visit new_user_session_path

    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_current_path(new_user_session_path)
  end

  # Eメールアドレスが間違っている場合（エラーメッセージの確認）
  scenario 'User log in fails when email is missing(message)' do
    visit new_user_session_path

    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: user.password

    click_button 'ログイン'

    expect(page).to have_content 'Eメールまたはパスワードが違います。'
  end

  # パスワードが間違っている場合（パス確認）
  scenario 'User log in fails when password is missing(path)' do
    visit new_user_session_path

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password012'

    click_button 'ログイン'

    expect(page).to have_current_path(new_user_session_path)
  end

  # パスワードが間違っている場合（エラーメッセージの確認）
  scenario 'User log in fails when password is missing(message)' do
    visit new_user_session_path

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password012'

    click_button 'ログイン'

    expect(page).to have_content 'Eメールまたはパスワードが違います。'
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Registration', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  def fill_registration_form_of_newuser
    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'
  end

  def fill_registration_form_of_testuser
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: user.password
    fill_in 'パスワード（確認用）', with: user.password_confirmation
  end

  def fill_registration_form_with_invalid_data
    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password456'
  end

  def fill_registration_form_when_email_is_missing
    fill_in 'Eメール', with: ''
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'
  end

  def fill_registration_form_when_password_length_is_wrong
    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: 'pass'
    fill_in 'パスワード（確認用）', with: 'pass'
  end

  # アカウント登録成功 パス確認
  scenario 'User registers successfully with valid data(path)' do
    visit new_user_registration_path
    fill_registration_form_of_newuser
    click_button 'アカウント登録'

    expect(page).to have_current_path(books_path)
  end

  # アカウント登録成功 メッセージ確認
  scenario 'User registers successfully with valid data(message)' do
    visit new_user_registration_path
    fill_registration_form_of_newuser
    click_button 'アカウント登録'

    expect(page).to have_content 'アカウント登録が完了しました。'
  end

  # 登録失敗の確認
  # Eメールが既に登録されている場合（パス確認）
  scenario 'User registration fails when email has already registrated(path)' do
    visit new_user_registration_path
    fill_registration_form_of_testuser
    click_button 'アカウント登録'

    expect(page).to have_current_path(new_user_registration_path)
  end

  # Eメールが既に登録されている場合（エラーメッセージの確認）
  scenario 'User registration fails when email has already registrated(message)' do
    visit new_user_registration_path
    fill_registration_form_of_testuser
    click_button 'アカウント登録'

    expect(page).to have_content 'Eメールはすでに存在します'
  end

  # パスワード（確認用）とパスワードの入力が不一致の場合（パス確認）
  scenario 'User registration fails with invalid data(path)' do
    visit new_user_registration_path
    fill_registration_form_with_invalid_data
    click_button 'アカウント登録'

    expect(page).to have_current_path(new_user_registration_path)
  end

  # パスワード（確認用）とパスワードの入力が不一致の場合（エラーメッセージの確認）
  scenario 'User registration fails with invalid data(message)' do
    visit new_user_registration_path
    fill_registration_form_with_invalid_data
    click_button 'アカウント登録'

    expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
  end

  # Eメール欄が空欄の場合（パス確認）
  scenario 'User registration fails when email is missing(path)' do
    visit new_user_registration_path
    fill_registration_form_when_email_is_missing
    click_button 'アカウント登録'

    expect(page).to have_current_path(new_user_registration_path)
  end

  # Eメール欄が空欄の場合（エラーメッセージの確認）
  scenario 'User registration fails when email is missing(message)' do
    visit new_user_registration_path
    fill_registration_form_when_email_is_missing
    click_button 'アカウント登録'

    expect(page).to have_content 'Eメールを入力してください'
  end

  # パスワードが5文字以下の場合（パス確認）
  scenario 'User registration fails when password is 5 characters or less(path)' do
    visit new_user_registration_path
    fill_registration_form_when_password_length_is_wrong
    click_button 'アカウント登録'

    expect(page).to have_current_path(new_user_registration_path)
  end

  # パスワードが5文字以下の場合（エラーメッセージの確認）
  scenario 'User registration fails when password is 5 characters or less(message)' do
    visit new_user_registration_path
    fill_registration_form_when_password_length_is_wrong
    click_button 'アカウント登録'

    expect(page).to have_content 'パスワードは6文字以上で入力してください'
  end
end

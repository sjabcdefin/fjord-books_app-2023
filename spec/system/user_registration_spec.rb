require 'rails_helper'

RSpec.describe 'User Registration', type: :system do

  let!(:user) { FactoryBot.create(:user) }

  # アカウント登録成功確認
  scenario 'User registers successfully with valid data' do
    visit new_user_registration_path

    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'

    click_button 'アカウント登録'

    expect(page).to have_content 'アカウント登録が完了しました。'
    expect(page).to have_current_path(books_path)
  end

  # 登録失敗の確認（エラーメッセージの確認）
  # Eメールが既に登録されている場合
  scenario 'User registration fails when email has already registrated' do
    visit new_user_registration_path

    fill_in 'Eメール', with: 'test@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'

    click_button 'アカウント登録'

    expect(page).to have_content "Eメールはすでに存在します"
    expect(page).to have_current_path(new_user_registration_path)
  end

  # パスワード（確認用）とパスワードの入力が不一致の場合
  scenario 'User registration fails with invalid data' do
    visit new_user_registration_path

    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password456' # パスワード不一致

    click_button 'アカウント登録'

    expect(page).to have_content "パスワード（確認用）とパスワードの入力が一致しません"
    expect(page).to have_current_path(new_user_registration_path) # エラーページに留まる
  end

  # Eメール欄が空欄の場合
  scenario 'User registration fails when email is missing' do
    visit new_user_registration_path

    fill_in 'Eメール', with: ''
    fill_in 'パスワード', with: 'password123'
    fill_in 'パスワード（確認用）', with: 'password123'

    click_button 'アカウント登録'

    expect(page).to have_content "Eメールを入力してください"
    expect(page).to have_current_path(new_user_registration_path)
  end

  # パスワードが5文字以下の場合
  scenario 'User registration fails when password is 5 characters or less' do
    visit new_user_registration_path

    fill_in 'Eメール', with: 'newuser@example.com'
    fill_in 'パスワード', with: 'pass'
    fill_in 'パスワード（確認用）', with: 'pass'

    click_button 'アカウント登録'

    expect(page).to have_content "パスワードは6文字以上で入力してください"
    expect(page).to have_current_path(new_user_registration_path)
  end
end

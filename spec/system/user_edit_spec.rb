# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Operation after login', type: :system do
  let!(:users) { FactoryBot.create_list(:user, 3) }

  before do
    sign_in users[0]
  end

  # ユーザ詳細 → ユーザ編集 パス確認
  scenario 'User can edit move to edit user page(path)' do
    visit user_path(users[0])

    click_link 'このユーザを編集'
    expect(page).to have_current_path(edit_user_registration_path(users[0]))
  end

  # ユーザ詳細 → ユーザ編集 コンテンツ確認
  scenario 'User can edit move to edit user page(content)' do
    visit user_path(users[0])

    click_link 'このユーザを編集'
    expect(page).to have_content 'ユーザの編集'
  end

  # ユーザ編集成功 編集後パス確認
  scenario 'User can edit user information(path)' do
    visit edit_user_registration_path(users[0])

    fill_in '名前', with: 'test'

    click_button '更新する'
    expect(page).to have_current_path(user_path(users[0]))
  end

  # ユーザ編集成功 編集後メッセージ確認
  scenario 'User can edit user information(message)' do
    visit edit_user_registration_path(users[0])

    fill_in '名前', with: 'test'

    click_button '更新する'
    expect(page).to have_content 'アカウント情報を変更しました。'
  end

  # ユーザ編集失敗確認
  # 現在のパスワード空欄の場合（パス確認）
  scenario 'User edit fails when current password is missing(path)' do
    visit edit_user_registration_path(users[0])

    fill_in 'パスワード', with: 'newpassword123'
    fill_in 'パスワード（確認用）', with: 'newpassword123'

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(users[0]))
  end

  # 現在のパスワード空欄の場合（エラーメッセージの確認）
  scenario 'User edit fails when current password is missing(message)' do
    visit edit_user_registration_path(users[0])

    fill_in 'パスワード', with: 'newpassword123'
    fill_in 'パスワード（確認用）', with: 'newpassword123'

    click_button '更新する'
    expect(page).to have_content '現在のパスワードを入力してください'
  end

  # パスワード（確認用）とパスワードの入力が不一致の場合（パス確認）
  scenario 'User edit fails with invalid data(path)' do
    visit edit_user_registration_path(users[0])

    fill_in 'パスワード', with: 'newpassword123'
    fill_in '現在のパスワード', with: users[0].password

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(users[0]))
  end

  # パスワード（確認用）とパスワードの入力が不一致の場合（エラーメッセージの確認）
  scenario 'User edit fails with invalid data(message)' do
    visit edit_user_registration_path(users[0])

    fill_in 'パスワード', with: 'newpassword123'
    fill_in '現在のパスワード', with: users[0].password

    click_button '更新する'
    expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
  end

  # Eメール欄が空欄の場合（パス確認）
  scenario 'User edit fails when email is missing(path)' do
    visit edit_user_registration_path(users[0])

    fill_in 'Eメール', with: ''

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(users[0]))
  end

  # Eメール欄が空欄の場合（エラーメッセージの確認）
  scenario 'User edit fails when email is missing(message)' do
    visit edit_user_registration_path(users[0])

    fill_in 'Eメール', with: ''

    click_button '更新する'
    expect(page).to have_content 'Eメールを入力してください'
  end

  # パスワードが7文字以下の場合（パス確認）
  def fill_registration_form_when_password_length_is_wrong
    fill_in 'パスワード', with: 'passwor'
    fill_in 'パスワード（確認用）', with: 'passwor'
    fill_in '現在のパスワード', with: users[0].password
  end

  scenario 'User edit fails when password is 7 characters or less(path)' do
    visit edit_user_registration_path(users[0])

    fill_registration_form_when_password_length_is_wrong

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(users[0]))
  end

  # パスワードが7文字以下の場合（エラーメッセージの確認）
  scenario 'User edit fails when password is 7 characters or less(message)' do
    visit edit_user_registration_path(users[0])

    fill_registration_form_when_password_length_is_wrong

    click_button '更新する'
    expect(page).to have_content 'パスワードは8文字以上で入力してください'
  end
end

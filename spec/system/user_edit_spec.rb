# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Operation after login', type: :system do
  let!(:user) { FactoryBot.create(:user) }

  before do
    sign_in user
  end

  # ユーザ詳細 → ユーザ編集 パス確認
  scenario 'User can edit move to edit user page(path)' do
    visit user_path(user)

    click_link 'このユーザを編集'
    expect(page).to have_current_path(edit_user_registration_path(user))
  end

  # ユーザ詳細 → ユーザ編集 コンテンツ確認
  scenario 'User can edit move to edit user page(content)' do
    visit user_path(user)

    click_link 'このユーザを編集'
    expect(page).to have_content 'ユーザの編集'
  end

  # ユーザ編集成功 編集後パス確認
  scenario 'User can edit user information(path)' do
    visit edit_user_registration_path(user)

    fill_in '名前', with: 'test'

    click_button '更新する'
    expect(page).to have_current_path(user_path(user))
  end

  # ユーザ編集成功 編集後メッセージ確認
  scenario 'User can edit user information(message)' do
    visit edit_user_registration_path(user)

    fill_in '名前', with: 'test'

    click_button '更新する'
    expect(page).to have_content 'アカウント情報を変更しました。'
  end

  # ユーザ編集失敗確認
  # 現在のパスワード空欄の場合（パス確認）
  scenario 'User edit fails when current password is missing(path)' do
    visit edit_user_registration_path(user)

    fill_in 'パスワード', with: 'newpassword123'
    fill_in 'パスワード（確認用）', with: 'newpassword123'

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(user))
  end

  # 現在のパスワード空欄の場合（エラーメッセージの確認）
  scenario 'User edit fails when current password is missing(message)' do
    visit edit_user_registration_path(user)

    fill_in 'パスワード', with: 'newpassword123'
    fill_in 'パスワード（確認用）', with: 'newpassword123'

    click_button '更新する'
    expect(page).to have_content '現在のパスワードを入力してください'
  end

  # パスワード（確認用）とパスワードの入力が不一致の場合（パス確認）
  scenario 'User edit fails with invalid data(path)' do
    visit edit_user_registration_path(user)

    fill_in 'パスワード', with: 'newpassword123'
    fill_in '現在のパスワード', with: user.password

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(user))
  end

  # パスワード（確認用）とパスワードの入力が不一致の場合（エラーメッセージの確認）
  scenario 'User edit fails with invalid data(message)' do
    visit edit_user_registration_path(user)

    fill_in 'パスワード', with: 'newpassword123'
    fill_in '現在のパスワード', with: user.password

    click_button '更新する'
    expect(page).to have_content 'パスワード（確認用）とパスワードの入力が一致しません'
  end

  # Eメール欄が空欄の場合（パス確認）
  scenario 'User edit fails when email is missing(path)' do
    visit edit_user_registration_path(user)

    fill_in 'Eメール', with: ''

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(user))
  end

  # Eメール欄が空欄の場合（エラーメッセージの確認）
  scenario 'User edit fails when email is missing(message)' do
    visit edit_user_registration_path(user)

    fill_in 'Eメール', with: ''

    click_button '更新する'
    expect(page).to have_content 'Eメールを入力してください'
  end

  # パスワードが5文字以下の場合（パス確認）
  def fill_registration_form_when_password_length_is_wrong
    fill_in 'パスワード', with: 'pass'
    fill_in 'パスワード（確認用）', with: 'pass'
    fill_in '現在のパスワード', with: user.password
  end

  scenario 'User edit fails when password is 5 characters or less(path)' do
    visit edit_user_registration_path(user)

    fill_registration_form_when_password_length_is_wrong

    click_button '更新する'
    expect(page).to have_current_path(edit_user_registration_path(user))
  end

  # パスワードが5文字以下の場合（エラーメッセージの確認）
  scenario 'User edit fails when password is 5 characters or less(message)' do
    visit edit_user_registration_path(user)

    fill_registration_form_when_password_length_is_wrong

    click_button '更新する'
    expect(page).to have_content 'パスワードは6文字以上で入力してください'
  end
end

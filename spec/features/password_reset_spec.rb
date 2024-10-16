# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Password Resets', type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
  end

  def send_password_reset_mail
    visit new_user_password_path
    fill_in 'Eメール', with: user.email
    click_button 'パスワードの再設定方法を送信する'
  end

  def access_the_reset_link
    mail = ActionMailer::Base.deliveries.last
    reset_link = extract_reset_link(mail.body.encoded)
    visit reset_link
  end

  def reset_password
    fill_in '新しいパスワード', with: 'newpassword123'
    fill_in '確認用新しいパスワード', with: 'newpassword123'
    click_button 'パスワードを変更する'
  end

  def fill_in_login_form
    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'newpassword123'
    click_button 'ログイン'
  end

  scenario 'User send reset password mail' do
    send_password_reset_mail
    expect(ActionMailer::Base.deliveries.size).to eq(1)
  end

  scenario 'User confirm reset password mail(1)' do
    send_password_reset_mail
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include(user.email)
  end

  scenario 'User confirm reset password mail(2)' do
    send_password_reset_mail
    mail = ActionMailer::Base.deliveries.last
    expect(mail.subject).to eq('パスワードの再設定について')
  end

  scenario 'User confirm reset password mail(3)' do
    send_password_reset_mail
    mail = ActionMailer::Base.deliveries.last
    expect(mail.body.encoded).to include('パスワード変更')
  end

  scenario 'User reset password' do
    send_password_reset_mail
    access_the_reset_link
    reset_password

    expect(page).to have_content('パスワードが正しく変更されました。')
  end

  scenario 'User log in after reset password' do
    send_password_reset_mail
    access_the_reset_link
    reset_password

    fill_in_login_form

    expect(page).to have_content('ログインしました。')
  end

  # メール本文からリセットリンクを抽出するヘルパーメソッド
  def extract_reset_link(mail_body)
    mail_body[/href="([^"]+)"/, 1]
  end
end

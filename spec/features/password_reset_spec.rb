require 'rails_helper'

RSpec.feature "Password Resets", type: :feature do
  let!(:user) { FactoryBot.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear  # テスト中のメール送信をクリア
  end

  scenario "User requests password reset" do
    # パスワードリセットのメール送信をリクエスト
    visit new_user_password_path
    fill_in "Eメール", with: user.email
    click_button "パスワードの再設定方法を送信する"

    # メールが送信されたことを確認
    expect(ActionMailer::Base.deliveries.size).to eq(1)

    # メールの内容を確認
    mail = ActionMailer::Base.deliveries.last
    expect(mail.to).to include(user.email)
    expect(mail.subject).to eq("パスワードの再設定について")

    # パスワード再設定ページのURLがメールに含まれているか確認
    expect(mail.body.encoded).to include("パスワード変更")

    # メール内のリセットリンクを取得
    mail = ActionMailer::Base.deliveries.last
    reset_link = extract_reset_link(mail.body.encoded)

    # リセットリンクにアクセス
    visit reset_link
    expect(page).to have_content("パスワードを変更")

    # 新しいパスワードを入力してリセット
    fill_in "新しいパスワード", with: "newpassword123"
    fill_in "確認用新しいパスワード", with: "newpassword123"
    click_button "パスワードを変更する"

    # パスワードリセット成功メッセージを確認
    expect(page).to have_content("パスワードが正しく変更されました。")

    # 新しいパスワードでサインインができることを確認
    visit new_user_session_path
    fill_in "Eメール", with: user.email
    fill_in "パスワード", with: "newpassword123"
    click_button "ログイン"

    expect(page).to have_content("ログインしました。")
  end

  # メール本文からリセットリンクを抽出するヘルパーメソッド
  def extract_reset_link(mail_body)
    mail_body[/href="([^"]+)"/, 1]
  end
end

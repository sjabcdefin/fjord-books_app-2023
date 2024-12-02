# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:vacation)

    visit new_user_session_path
    fill_in 'Eメール', with: 'carol@example.com'
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました'
  end

  test '日報の一覧ページに移動できる' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test '日報を新規作成できる' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'My Birthday'
    fill_in '内容', with: 'I received a present from my parent.'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'My Birthday'
    assert_text 'I received a present from my parent.'
    click_on '日報の一覧に戻る'
  end

  test '日報を更新できる' do
    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: 'Merry Christmas'
    fill_in '内容', with: 'I received a present from Santa.'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'Merry Christmas'
    assert_text 'I received a present from Santa.'
    click_on '日報の一覧に戻る'
  end

  test '日報を削除できる' do
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
    assert_not page.has_text?('Summer Vacation Start')
    assert_text "Happy Valentine's day"
  end
end

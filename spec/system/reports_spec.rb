# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Operate reports after login', type: :system do
  let!(:users) { FactoryBot.create_list(:user, 3) }
  let!(:report) { FactoryBot.create(:report, user: users[0]) }

  context 'when logged in as the report creator' do
    before do
      sign_in users[0]
    end

    # rootパス → 日報の一覧 パス確認
    scenario 'User can move to report index page(path)' do
      visit root_path

      click_link '日報'
      expect(page).to have_current_path(reports_path)
    end

    # rootパス → 日報の一覧 コンテンツ確認
    scenario 'User can move to report index page(content)' do
      visit root_path

      click_link '日報'
      expect(page).to have_content '日報の一覧'
    end

    # 日報の一覧 → 日報の新規作成 パス確認
    scenario 'User can move to new report page(path)' do
      visit reports_path

      click_link '日報の新規作成'
      expect(page).to have_current_path(new_report_path)
    end

    # 日報の一覧 → 日報の新規作成 コンテンツ確認
    scenario 'User can move to new report page(content)' do
      visit reports_path

      click_link '日報の新規作成'
      expect(page).to have_content '日報の新規作成'
    end

    # 日報の新規作成  作成後コンテンツ確認
    scenario 'User can create report' do
      visit new_report_path

      fill_in 'タイトル', with: 'title'
      fill_in '本文', with: 'content'
      click_button '登録する'

      expect(page).to have_content 'title'
    end

    # 日報の新規作成 作成後メッセージ確認
    scenario 'User can create report(message)' do
      visit new_report_path

      fill_in 'タイトル', with: 'title'
      fill_in '本文', with: 'content'
      click_button '登録する'

      expect(page).to have_content '日報が作成されました。'
    end

    # 日報の詳細 → 日報の編集 パス確認
    scenario 'User can move to edit report page(path)' do
      visit report_path(report)

      click_link 'この日報を編集'
      expect(page).to have_current_path(edit_report_path(report))
    end

    # 日報の詳細 → 日報の編集 コンテンツ確認
    scenario 'User can move to edit report page(content)' do
      visit report_path(report)

      click_link 'この日報を編集'
      expect(page).to have_content '日報の編集'
    end

    # 日報の編集 編集後パス確認
    scenario 'User can update report(path)' do
      visit edit_report_path(report)

      fill_in 'タイトル', with: 'edit title'
      fill_in '本文', with: 'edit content'

      click_button '更新する'
      expect(page).to have_current_path(report_path(report))
    end

    # 日報の編集 編集後メッセージ確認
    scenario 'User can update report(message)' do
      visit edit_report_path(report)

      fill_in 'タイトル', with: 'edit title'
      fill_in '本文', with: 'edit report'

      click_button '更新する'
      expect(page).to have_content '日報が更新されました。'
    end

    # 日報の削除 削除後パス確認
    scenario 'User can destroy report(path)' do
      visit report_path(report)

      click_button 'この日報を削除'
      expect(page).to have_current_path(reports_path)
    end

    # 日報の削除 削除後メッセージ確認
    scenario 'User can destroy report(message)' do
      visit report_path(report)

      click_button 'この日報を削除'
      expect(page).to have_content '日報が削除されました。'
    end
  end

  context 'when logged in as another user' do
    before do
      sign_in users[1]
    end

    # ログインユーザ以外が作成した日報を参照できることを確認
    scenario 'All user can refer to reports' do
      visit root_path

      click_link '日報'
      expect(page).to have_content 'title'
    end

    # 日報を作成したユーザのみが日報を編集できる
    # 作成ユーザ以外の場合は、編集リンクが表示されないことを確認
    scenario 'Only the user create the report can update' do
      visit reports_path

      click_link 'この日報を表示'
      expect(page).not_to have_content 'この日報を編集'
    end

    # 日報を作成したユーザのみが日報を削除できる
    # 作成ユーザ以外の場合は、削除ボタンが表示されないことを確認
    scenario 'Only the user create the report can delete' do
      visit reports_path

      click_link 'この日報を表示'
      expect(page).not_to have_content 'この日報を削除'
    end
  end
end

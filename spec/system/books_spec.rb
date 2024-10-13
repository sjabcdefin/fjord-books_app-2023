# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Operate books after login', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:book) { FactoryBot.create(:book) }

  before do
    sign_in user
  end

  # 本の一覧 → 本の新規作成 パス確認
  scenario 'User can move to new book page(path)' do
    visit books_path

    click_link '本の新規作成'
    expect(page).to have_current_path(new_book_path)
  end

  # 本の一覧 → 本の新規作成 コンテンツ確認
  scenario 'User can move to new book page(content)' do
    visit books_path

    click_link '本の新規作成'
    expect(page).to have_content '本の新規作成'
  end

  # 本の新規作成  作成後コンテンツ確認
  scenario 'User can create book(path)' do
    visit new_book_path

    fill_in 'タイトル', with: 'title'
    fill_in 'メモ', with: 'memo'
    click_button '登録する'

    expect(page).to have_content 'title'
  end

  # 本の新規作成 作成後メッセージ確認
  scenario 'User can create book(message)' do
    visit new_book_path

    fill_in 'タイトル', with: 'title'
    fill_in 'メモ', with: 'memo'
    click_button '登録する'

    expect(page).to have_content '本が作成されました。'
  end

  # 本の詳細 → 本の編集 パス確認
  scenario 'User can move to edit book page(path)' do
    visit book_path(book)

    click_link 'この本を編集'
    expect(page).to have_current_path(book_path(book))
  end

  # 本の詳細 → 本の編集 コンテンツ確認
  scenario 'User can move to edit book page(content)' do
    visit book_path(book)

    click_link 'この本を編集'
    expect(page).to have_content '本の編集'
  end

  # 本の編集 編集後パス確認
  scenario 'User can update book(path)' do
    visit edit_book_path(book)

    fill_in 'タイトル', with: 'edit title'
    fill_in 'メモ', with: 'edit memo'

    click_button '更新する'
    expect(page).to have_current_path(book_path(book))
  end

  # 本の編集 編集後メッセージ確認
  scenario 'User can update book(message)' do
    visit edit_book_path(book)

    fill_in 'タイトル', with: 'edit title'
    fill_in 'メモ', with: 'edit memo'

    click_button '更新する'
    expect(page).to have_content '本が更新されました。'
  end

  # 本の削除 削除後パス確認
  scenario 'User can destroy book(path)' do
    visit book_path(book)

    click_button 'この本を削除'
    expect(page).to have_current_path(books_path)
  end

  # 本の削除 削除後メッセージ確認
  scenario 'User can destroy book(message)' do
    visit book_path(book)

    click_button 'この本を削除'
    expect(page).to have_content '本が削除されました。'
  end
end

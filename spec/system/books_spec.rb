require 'rails_helper'

RSpec.describe 'Operate books after login', type: :system do
  let!(:user) { FactoryBot.create(:user) }
  let!(:book) { FactoryBot.create(:book) }

  before do
    sign_in user
  end

  # 本の新規作成確認
  scenario 'User can create book' do
    visit books_path

    expect(page).to have_content '本の一覧'
    expect(page).to have_current_path(books_path)

    click_link '本の新規作成'
    expect(page).to have_content '本の新規作成'
    expect(page).to have_current_path(new_book_path)

    fill_in 'タイトル', with: 'title'
    fill_in 'メモ', with: 'memo'
    click_button '登録する'

    expect(page).to have_content "本が作成されました。"
  end

  # 本の編集確認
  scenario 'User can update book' do
    visit book_path(book)

    click_link 'この本を編集'
    expect(page).to have_content '本の編集'
    expect(page).to have_current_path(edit_book_path(book))

    fill_in 'タイトル', with: 'edit title'
    fill_in 'メモ', with: 'edit memo'

    click_button '更新する'
    expect(page).to have_content "本が更新されました。"
    expect(page).to have_current_path(book_path(book))
  end

  # 本の削除確認
  scenario 'User can destroy book' do
    visit book_path(book)

    click_button 'この本を削除'
    expect(page).to have_content '本が削除されました。'
    expect(page).to have_current_path(books_path)
  end
end

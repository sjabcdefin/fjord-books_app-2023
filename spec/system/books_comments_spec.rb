# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Operate reports after login', type: :system do
  let!(:users) { FactoryBot.create_list(:user, 3) }
  let!(:book) { FactoryBot.create(:book) }
  let!(:comment) { FactoryBot.create(:comment, user: users[0], commentable: book) }

  def update_comment
    within("turbo-frame#frame_comment_#{comment.id}") do
      find('textarea').set('update comment')
      click_button '更新する'
    end
  end

  context 'when logged in as the report creator' do
    before do
      sign_in users[0]
    end

    # 本の詳細画面にコメントの一覧画面があるかの確認
    scenario 'User can move to book show page(content)' do
      visit book_path(book)

      expect(page).to have_content 'コメントの一覧'
    end

    # コメントの新規作成
    scenario 'User can create comment' do
      visit book_path(book)

      find('textarea').set('new comment')
      click_button '登録する'

      expect(page).to have_content 'new comment'
    end

    # コメントの新規作成 作成後メッセージ確認
    scenario 'User can create comment(message)' do
      visit book_path(book)

      find('textarea').set('new comment')
      click_button '登録する'

      expect(page).to have_content 'コメントが作成されました。'
    end

    # コメントの編集確認
    scenario 'User can update comment' do
      visit book_path(book)

      click_link 'このコメントを編集'

      update_comment

      expect(page).to have_content 'update comment'
    end

    # コメントの編集画面における「戻る」確認
    scenario 'User can move to comment index page' do
      visit book_path(book)

      click_link 'このコメントを編集'

      click_link 'コメントの一覧に戻る'

      expect(page).to have_content 'comment'
    end

    # コメントの削除確認
    scenario 'User can destroy comment' do
      visit book_path(book)

      click_button 'このコメントを削除'
      expect(page).not_to have_content 'comment'
    end

    # コメントの削除 削除後メッセージ確認
    scenario 'User can destroy report(message)' do
      visit book_path(book)

      click_button 'このコメントを削除'
      expect(page).to have_content 'コメントが削除されました。'
    end

    # コメントが0件の場合の表示確認
    scenario 'No comments' do
      Comment.delete_all

      visit book_path(book)

      expect(page).to have_content 'まだコメントがありません。最初のコメントを残しましょう。'
    end
  end

  context 'when logged in as another user' do
    before do
      sign_in users[1]
    end

    # ログインユーザ以外が作成したコメントを参照できることを確認
    scenario 'All user can refer to comments' do
      visit book_path(book)

      expect(page).to have_content 'comment'
    end

    # コメントを作成したユーザのみがコメントを編集できる
    # 作成ユーザ以外の場合は、編集リンクが表示されないことを確認
    scenario 'Only the user create the comment can update' do
      visit book_path(book)

      expect(page).not_to have_content 'このコメントを編集'
    end

    # コメントを作成したユーザのみがコメントを削除できる
    # 作成ユーザ以外の場合は、削除ボタンが表示されないことを確認
    scenario 'Only the user create the comment can delete' do
      visit book_path(book)

      expect(page).not_to have_content 'このコメントを削除'
    end
  end
end

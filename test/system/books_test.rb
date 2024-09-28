# frozen_string_literal: true

require 'application_system_test_case'

class BooksTest < ApplicationSystemTestCase
  setup do
    @book = books(:one)
  end

  test 'visiting the index in Japanese' do
    visit books_url(locale: :ja)
    assert_selector 'h1', text: '本一覧'
  end

  test 'visiting the index in English' do
    visit books_url(locale: :en)
    assert_selector 'h1', text: 'Books'
  end

  test 'should create book in Japanese' do
    visit books_url(locale: :ja)
    click_on '新規追加'

    Capybara.default_max_wait_time = 5
    fill_in 'メモ', with: @book.memo
    fill_in 'タイトル', with: @book.title
    click_on '登録する'

    assert_text '本が正常に作成されました。'
    click_on '本一覧に戻る'
  end

  test 'should create book in English' do
    visit books_url(locale: :en)
    click_on 'New book'

    fill_in 'Memo', with: @book.memo
    fill_in 'Title', with: @book.title
    click_on 'Create Book'

    assert_text 'Book was successfully created.'
    click_on 'Back to books'
  end

  test 'should update Book in Japanese' do
    visit book_url(@book, locale: :ja)
    click_on 'この本を編集する', match: :first

    Capybara.default_max_wait_time = 5
    fill_in 'メモ', with: @book.memo
    fill_in 'タイトル', with: @book.title
    click_on '更新する'

    assert_text '本が正常に更新されました。'
    click_on '本一覧に戻る'
  end

  test 'should update Book in English' do
    visit book_url(@book, locale: :en)
    click_on 'Edit this book', match: :first

    fill_in 'Memo', with: @book.memo
    fill_in 'Title', with: @book.title
    click_on 'Update Book'

    assert_text 'Book was successfully updated'
    click_on 'Back to books'
  end

  test 'should destroy Book in Japanese' do
    visit book_url(@book, locale: :ja)
    click_on 'この本を削除する', match: :first

    assert_text '本が正常に削除されました。'
  end

  test 'should destroy Book in English' do
    visit book_url(@book, locale: :en)
    click_on 'Destroy this book', match: :first

    assert_text 'Book was successfully destroyed'
  end
end

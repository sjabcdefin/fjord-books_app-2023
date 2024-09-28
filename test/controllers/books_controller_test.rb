# frozen_string_literal: true

require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
  end

  test 'should get index in Japanese' do
    get books_url(locale: :ja)
    assert_response :success
  end

  test 'should get index in English' do
    get books_url(locale: :en)
    assert_response :success
  end

  test 'should get new in Japanese' do
    get new_book_url(locale: :ja)
    assert_response :success
  end

  test 'should get new in English' do
    get new_book_url(locale: :en)
    assert_response :success
  end

  test 'should create book in Japanese' do
    assert_difference('Book.count') do
      post books_url(locale: :ja), params: { book: { memo: @book.memo, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last, locale: :ja)
  end

  test 'should create book in English' do
    assert_difference('Book.count') do
      post books_url(locale: :en), params: { book: { memo: @book.memo, title: @book.title } }
    end

    assert_redirected_to book_url(Book.last, locale: :en)
  end

  test 'should show book in Japanese' do
    get book_url(@book, locale: :ja)
    assert_response :success
  end

  test 'should show book in English' do
    get book_url(@book, locale: :en)
    assert_response :success
  end

  test 'should get edit in Japanese' do
    get edit_book_url(@book, locale: :ja)
    assert_response :success
  end

  test 'should get edit in English' do
    get edit_book_url(@book, locale: :en)
    assert_response :success
  end

  test 'should update book in Japanese' do
    patch book_url(@book, locale: :ja), params: { book: { memo: @book.memo, title: @book.title } }
    assert_redirected_to book_url(@book, locale: :ja)
  end

  test 'should update book in English' do
    patch book_url(@book, locale: :en), params: { book: { memo: @book.memo, title: @book.title } }
    assert_redirected_to book_url(@book, locale: :en)
  end

  test 'should destroy book in Japanese' do
    assert_difference('Book.count', -1) do
      delete book_url(@book, locale: :ja)
    end

    assert_redirected_to books_url(locale: :ja)
  end

  test 'should destroy book in English' do
    assert_difference('Book.count', -1) do
      delete book_url(@book, locale: :en)
    end

    assert_redirected_to books_url(locale: :en)
  end
end

# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '名前入力あり、email入力なしの場合、名前を返す' do
    assert_equal 'Alice', users(:alice).name_or_email
  end

  test '名前入力なし、email入力アリの場合、emailを返す' do
    assert_equal 'bob@example.com', users(:bob).name_or_email
  end
end

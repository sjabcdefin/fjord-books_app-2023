# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should return name' do
    assert_equal 'one', users(:one).name_or_email
  end

  test 'should return email' do
    assert_equal 'two@example.com', users(:two).name_or_email
  end
end

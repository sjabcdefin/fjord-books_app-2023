# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @newyear_report = reports(:newyear)
    @valentine_report = reports(:valentine)
    @vacation_report = reports(:vacation)
  end

  # ログインユーザと日報作成ユーザが同一の場合、trueを返す
  test 'should return true when the log-in user is the report author' do
    assert_equal true, @newyear_report.editable?(users(:one))
  end

  # ログインユーザと日報作成ユーザが異なる場合、falseを返す
  test 'should return false when the log-in user is not the report author' do
    assert_equal false, @newyear_report.editable?(users(:two))
  end

  # タイムスタンプをDateオブジェクトに変換する
  test 'should return date object' do
    assert_equal Time.zone.today, @newyear_report.created_on
  end

  # 日報本文に言及がない場合、言及関係が保存されない
  test 'does not create mentions if no URLs in content' do
    @newyear_report.update(content: 'This is a simple report with no URLs')

    assert_empty @newyear_report.active_mentions
  end

  # 日報本文に有効なURLがある場合、それに基づいた言及関係が保存される
  test 'creates mentions for valid URLs in content' do
    @newyear_report.update(content: "http://localhost:3000/reports/#{@valentine_report.id}, http://localhost:3000/reports/#{@vacation_report.id}")

    assert_equal 2, @newyear_report.active_mentions.size
    assert_includes @newyear_report.mentioning_reports, @valentine_report
    assert_includes @newyear_report.mentioning_reports, @vacation_report
  end

  # 日報本文に同一のURLを複数言及した場合、レコードは1件しかできない
  test 'creates only one mention for the same URL in content' do
    @newyear_report.update(content: "http://localhost:3000/reports/#{@valentine_report.id}, http://localhost:3000/reports/#{@valentine_report.id}")

    assert_equal 1, @newyear_report.active_mentions.size
    assert_includes @newyear_report.mentioning_reports, @valentine_report
  end

  # 自分自身を言及するURLが含まれている場合、それは無視される
  test 'does not mention itself' do
    @newyear_report.update(content: "http://localhost:3000/reports/#{@newyear_report.id}")

    assert_empty @newyear_report.active_mentions
  end

  # 言及先が存在しないURLが含まれている場合、それは無視される
  test 'does not create mentions for invalid URLs' do
    @newyear_report.update(content: 'http://localhost:3000/reports/99')

    assert_empty @newyear_report.active_mentions
  end

  # 既存の言及関係が適切に削除・更新される
  test 'removes old mentions when updating content' do
    @newyear_report.update(content: "First mention: http://localhost:3000/reports/#{@valentine_report.id}")
    @newyear_report.update(content: "Updated mention: http://localhost:3000/reports/#{@vacation_report.id}")

    assert_equal 1, @newyear_report.active_mentions.size
    assert_includes @newyear_report.mentioning_reports, @vacation_report
  end
end

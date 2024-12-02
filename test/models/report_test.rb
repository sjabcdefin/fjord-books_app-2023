# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @newyear_report = reports(:newyear)
    @valentine_report = reports(:valentine)
    @vacation_report = reports(:vacation)
  end

  test 'ログインユーザと日報作成ユーザが同一の場合、trueを返す' do
    assert_equal true, @newyear_report.editable?(users(:alice))
  end

  test 'ログインユーザと日報作成ユーザが異なる場合、falseを返す' do
    assert_equal false, @newyear_report.editable?(users(:bob))
  end

  test 'タイムスタンプをDateオブジェクトに変換する' do
    assert_equal Time.zone.today, @newyear_report.created_on
  end

  test '日報本文に言及がない場合、言及関係が保存されない' do
    @newyear_report.update(content: 'This is a simple report with no URLs')

    assert_empty @newyear_report.active_mentions
  end

  test '日報本文に有効なURLがある場合、それに基づいた言及関係が保存される' do
    @newyear_report.update(content: "http://localhost:3000/reports/#{@valentine_report.id}, http://localhost:3000/reports/#{@vacation_report.id}")

    assert_equal 2, @newyear_report.active_mentions.size
    assert_includes @newyear_report.mentioning_reports, @valentine_report
    assert_includes @newyear_report.mentioning_reports, @vacation_report
  end

  test '日報本文に同一のURLを複数言及した場合、レコードは1件しかできない' do
    @newyear_report.update(content: "http://localhost:3000/reports/#{@valentine_report.id}, http://localhost:3000/reports/#{@valentine_report.id}")

    assert_equal 1, @newyear_report.active_mentions.size
    assert_includes @newyear_report.mentioning_reports, @valentine_report
  end

  test '自分自身を言及するURLが含まれている場合、それは無視される' do
    @newyear_report.update(content: "http://localhost:3000/reports/#{@newyear_report.id}")

    assert_empty @newyear_report.active_mentions
  end

  test '言及先が存在しないURLが含まれている場合、それは無視される' do
    @newyear_report.update(content: 'http://localhost:3000/reports/99')

    assert_empty @newyear_report.active_mentions
  end

  test '既存の言及関係が適切に削除・更新される' do
    @newyear_report.update(content: "First mention: http://localhost:3000/reports/#{@valentine_report.id}")
    @newyear_report.update(content: "Updated mention: http://localhost:3000/reports/#{@vacation_report.id}")

    assert_equal 1, @newyear_report.active_mentions.size
    assert_includes @newyear_report.mentioning_reports, @vacation_report
  end
end

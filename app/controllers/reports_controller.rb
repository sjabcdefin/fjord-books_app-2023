# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentioned_reports = @report.mentioned_reports
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    success = false
    @report = current_user.reports.new(report_params)

    ActiveRecord::Base.transaction do
      @report.save!
      extract_and_save_urls(@report)
      success = true
    end

    if success
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    success = false

    ActiveRecord::Base.transaction do
      @report.update!(report_params)
      @report.report_mentions.destroy_all
      extract_and_save_urls(@report)
      success = true
    end

    if success
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def extract_and_save_urls(report)
    urls = report.content.scan(%r{https?://[^\s]+})

    urls.each do |url|
      report_id = url.match(%r{reports/(\d+)})[1]
      mentioned_report = Report.find_by(id: report_id)
      report.report_mentions.create!(mentioned_report:) if report_id.to_i != report.id &&
                                                           mentioned_report &&
                                                           !ReportMention.exists?(mentioning_report: report, mentioned_report:)
    end
  end
end

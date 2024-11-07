# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :report_mentions, foreign_key: :mentioning_report_id, inverse_of: :mentioning_report, dependent: :destroy
  has_many :mentioning_reports, through: :report_mentions, source: :mentioned_report

  has_many :reverse_report_mentions, class_name: 'ReportMention', foreign_key: :mentioned_report_id, inverse_of: :mentioned_report, dependent: :destroy
  has_many :mentioned_reports, through: :reverse_report_mentions, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end

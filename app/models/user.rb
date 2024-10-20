# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar

  validate :verify_file_type

  private

  def verify_file_type
    if avatar.attached?
      allowed_file_types = %w[image/jpg image/jpeg image/gif image/png]
      errors.add(:avatar, I18n.t('errors.messages.wrong_extention')) unless avatar.content_type.in?(allowed_file_types)
    end
  end
end

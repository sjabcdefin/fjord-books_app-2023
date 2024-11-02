# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    comment { 'comment' }
    association :user
    association :commentable, factory: %i[book report]
  end
end

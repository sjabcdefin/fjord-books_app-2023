# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { 'title' }
    text { 'text' }
    association :user
  end
end

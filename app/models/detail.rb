class Detail < ApplicationRecord
  # belongs_to :record_tag
  belongs_to :user
  validates :title, :year, presence: true
end

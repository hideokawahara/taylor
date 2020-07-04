class RecordTag < ApplicationRecord
  has_many :details, dependent: :destroy
  validates :name, presence: true
  # belongs_to :user
end

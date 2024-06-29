class Repository < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :stars, presence: true
end

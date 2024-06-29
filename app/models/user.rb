class User < ApplicationRecord
  has_many :repositories, dependent: :destroy

  validates :login, presence: true, uniqueness: true
end

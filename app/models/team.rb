class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: { message: " %{value} already exists for team"}
  has_many :developers, dependent: :destroy
end

class Course < ApplicationRecord
  belongs_to :coach
  has_many :activities, dependent: :destroy

  validates :name, presence: true
end

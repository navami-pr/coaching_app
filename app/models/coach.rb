class Coach < ApplicationRecord
  has_one :course

  validates :name, presence: true

  def transfer_coach
    new_coach = Coach.where.missing(:course).first
    if new_coach
      course = self.course
      course.update(coach_id: new_coach.id)
      [true, course]
    end
  end
end

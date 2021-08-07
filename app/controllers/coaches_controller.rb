class CoachesController < JSONAPI::ResourceController
  protect_from_forgery with: :null_session
  # The below method look for the associated course bbefore deleting the record
  # record can be deleted only when the assocoated course tranfered to other coach
  def destroy
    coach = Coach.find_by(id: params[:id])
    if coach.course.present?
      course_transfered, course = coach.transfer_coach
      if course_transfered
        coach.delete
        render json: { status: :ok,
                       message: 'successfully deleted the coach and tranfered the course',
                       course: course }
      else
        render json: { status: :not_found,
                       message: 'The currect coach course is not tranferable' }
      end
    else
      coach.delete
      render json: { status: :ok, message: 'coach deleted successfully' }
    end
  end
end

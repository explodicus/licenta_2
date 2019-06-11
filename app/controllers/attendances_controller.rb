class AttendancesController < ApplicationController
  after_action :verify_authorized

  def search_attendance
    authorize Group.first
  end

  def found_attendance
    unless Group.exists?(params[:group_id])
      flash[:danger] = t('Group was deleted')
      redirect_to root_path
      return
    end
    @group = Group.find(params[:group_id])
    authorize @group
    if params[:date]
      @lesson_time = Time.new(params[:date]['{}(1i)'], params[:date]['{}(2i)'],
                              params[:date]['{}(3i)'], params[:time]['{}(4i)'],
                              params[:time]['{}(5i)'].to_i + 2)
    else
      @lesson_time = Time.now
    end
    @lesson = @group.find_lesson(@lesson_time)
    if @lesson
      attendances = @lesson.attendances(@lesson_time)
      @present_users = attendances.map(&:user)
    else
      flash[:danger] = t('No lesson was found')
      redirect_to search_attendance_path
    end
  end

  def create_attendances
    # Finding the right lesson and deleting existing attendances
    unless Group.exists?(params[:group_id])
      flash[:danger] = t('Group was deleted')
      redirect_to root_path
      return
    end
    @group = Group.find(params[:group_id])
    authorize @group
    lesson_time = Time.parse(params[:lesson_time])
    lesson = @group.find_lesson(lesson_time)
    if lesson
      lesson.attendances(lesson_time).each(&:destroy)
      # Adding the new attendances
      params[:students].each do |user|
        attendance = Attendance.new(group_id: params[:group_id], user_id: user,
                                    time: lesson_time)
        unless attendance.save
          flash[:danger] = t('Error finding the right lesson')
          redirect_to root_path
        end
      end
      attendance = Attendance.new(group_id: params[:group_id], user_id: current_user.id,
                                  time: lesson_time)
      unless attendance.save
        flash[:danger] = t('Error finding the right lesson')
        redirect_to root_path
      end
      flash[:success] = t('Attendances registered')
    else
      flash[:danger] = t('Error finding the right lesson')
    end
    redirect_to root_path
  end
end

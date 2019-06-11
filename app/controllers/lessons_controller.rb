class LessonsController < ApplicationController
  after_action :verify_authorized

  def create
    @lesson = Lesson.new(lesson_params)
    authorize @lesson
    @lesson.start_time = Time.new(2000, 1, 1, @lesson.start_time.hour, @lesson.start_time.min) + 1.minute
    @lesson.end_time = Time.new(2000, 1, 1, @lesson.end_time.hour, @lesson.end_time.min) - 1.minute

    if @lesson.start_time > @lesson.end_time
      flash[:danger] = 'End time must be after start time'
      redirect_to @lesson.group
      return
    end

    @lesson.group.users.each do |user|
      user.groups.each do |group|
        group.lessons.each do |lesson|
          if @lesson.week_day == lesson.week_day && (@lesson.start_time..@lesson.end_time).overlaps?(lesson.start_time..lesson.end_time)
            flash[:danger] = "Overlap found with #{user.full_name}'s timetable in group #{group.name}"
            redirect_to @lesson.group
            return
          end
        end
      end
    end
    if @lesson.save
      flash[:success] = 'New lesson scheduled'
    else
      flash[:danger] = "Couldn't schedule lesson"
    end
    redirect_to @lesson.group
  end

  def destroy
    @lesson = Lesson.find(params[:id])
    authorize @lesson
    @group = @lesson.group
    @lesson.destroy
    flash[:success] = 'Lesson deleted'
    redirect_to @group
  end

  private

  def lesson_params
    params.require(:lesson).permit(:group_id, :week_day, :start_time, :end_time)
  end
end

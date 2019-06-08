class SingleLessonsController < ApplicationController
  after_action :verify_authorized

  def create
    @single_lesson = SingleLesson.new(single_lesson_params)
    authorize @single_lesson
    @lesson.start_time += 1.minute
    @lesson.end_time -= 1.minute

    if @single_lesson.start_date_time > @single_lesson.start_date_time
      flash[:danger] = t('End time must be after start time')
      redirect_to @single_lesson.group
      return
    end

    @single_lesson.group.users.each do |user|
      user.groups.each do |group|
        group.single_lessons.each do |lesson|
          next unless (@single_lesson.start_date_time..@single_lesson.end_date_time).overlaps?(lesson.start_date_time..lesson.end_date_time)
          flash[:danger] = "Overlap found with #{user.full_name}'s timetable in group #{group.name}"
          redirect_to @single_lesson.group
          return
        end
      end
    end

    @single_lesson.group.users.each do |user|
      user.groups.each do |group|
        group.lessons.each do |lesson|
          wday = @single_lesson.wday
          if wday == 0
            wday = 7
          end
          next unless wday == lesson.week_day && (@single_lesson.old_start_time..@single_lesson.old_end_time).overlaps?(lesson.start_time..lesson.end_time)
          flash[:danger] = "Overlap found with #{user.full_name}'s timetable in group #{group.name}"
          redirect_to @lesson.group
          return
        end
      end
    end

    if @single_lesson.save
      flash[:success] = t('New lesson scheduled')
    else
      flash[:danger] = t("Couldn't schedule lesson")
    end
    redirect_to @single_lesson.group
  end

  def destroy
    @group = @lesson.group
    @lesson.destroy
    authorize @lesson
    flash[:success] = t('Lesson deleted')
    redirect_to @group
  end

  private

  def single_lesson_params
    params.require(:single_lesson).permit(:group_id, :start_date_time, :end_date_time)
  end

end

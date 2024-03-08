class QuestionDecorator < Draper::Decorator
  delegate_all

  def deadline_days
    return '締切期間を終了しました' if object.deadline < Time.current

    if object.deadline.to_date == Time.zone.today
      deadline_time = object.deadline.hour - Time.current.hour
      "締切期間まで後#{deadline_time}時間"
    else
      deadline_days = (object.deadline.to_date - Time.zone.today).to_i
      "締切期間まで後#{deadline_days}日"
    end
  end
end

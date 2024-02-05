class QuestionDecorator < Draper::Decorator
  delegate_all

  def deadline_days
    return '締切期間を終了しました' if object.deadline.to_date < Time.zone.today

    deadline_days = (object.deadline.to_date - Time.zone.today).to_i
    "締切期間まで後#{deadline_days}日"
  end
end

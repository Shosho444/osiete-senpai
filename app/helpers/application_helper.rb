module ApplicationHelper
  def flash_message(type)
    type == 'success' ? 'alert-success' : 'alert-error'
  end
end

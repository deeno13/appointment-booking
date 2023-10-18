module ApplicationHelper
  def inline_errors(model, field)
    errors_list = ''
    if model.errors[field].any?
      model.errors.full_messages_for(field).each do |error|
        errors_list += "<li class='text-red-500 mt-1'>#{error}</li>"
      end
    end
    return "<ul#{errors_list}</ul>".html_safe
  end
end

module ApplicationHelper
  include Pagy::Frontend

  def type_tag(model)
    case model
    when Course.name
      content_tag(:i, '', class: 'fa-solid fa-graduation-cap')
    when Lesson.name
      content_tag(:i, '', class: 'fa-solid fa-list-check')
    when Enrollment.name
      content_tag(:i, '', class: 'fa-solid fa-lock-open')
    when Comment.name
      content_tag(:i, '', class: 'fa-solid fa-message')
    end
  end

  def action_tag(key)
    case key
    when 'create'
      content_tag(:i, '', class: 'fa-solid fa-plus')
    when 'update'
      content_tag(:i, '', class: 'fa-solid fa-pen')
    when 'destroy'
      content_tag(:i, '', class: 'fa-solid fa-trash-can')
    end
  end
end

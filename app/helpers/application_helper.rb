module ApplicationHelper
  def full_title(title)
    default = "TransferUR"

    if title.nil?
      return default
    end

    "#{default} | #{title}"
  end

  def body_class(set_class)
    if set_class.nil?
      return "profile"
    end
    set_class
  end
end

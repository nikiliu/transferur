module ApplicationHelper
  def full_title(title)
    default = "TransferUR"

    if title.nil?
      return default
    end

    "#{default} | #{title}"
  end
end

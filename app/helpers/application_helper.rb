module ApplicationHelper
  def full_title(title)
    default = "TransferUR"

    if title.empty?
      return default
    end

    "#{default} | #{title}"
  end
end

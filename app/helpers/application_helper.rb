module ApplicationHelper
  # Returns the full title on a per-page basis.
  def full_title(page_title = '')
    base_title = 'ISCEO'
    if page_title.empty?
      base_title
    else
      page_title + ' | ' + base_title
    end
  end

  def flash_class_name(name)
    case name
    when "notice" then "success"
    when "alert"  then "danger"
    else name
    end
  end
end

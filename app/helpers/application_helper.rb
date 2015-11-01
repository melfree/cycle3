module ApplicationHelper
  def load_icon(txt=nil)
    "#{txt}<i class='fa fa-spinner fa-spin'></i>".html_safe
  end
end

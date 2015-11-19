module ApplicationHelper
  def load_icon(txt=nil)
    "#{txt} <i class='fa fa-spinner fa-spin'></i>".html_safe
  end
    
  def static_map_for(users, options = {})
    params = {
      :center => 'Carnegie+Mellon+University',
      :zoom => 16,
      :size => "700x400",
      :visual_refresh => true,
      }.merge(options)

    query_string =  params.map{|k,v| "#{k}=#{v}"}.join("&")
    query_string << markers_from(users).join('')
    image_tag "http://maps.googleapis.com/maps/api/staticmap?#{query_string}", :alt => "CMU"
  end
  
  private
  def markers_from(users)
    users.map do |o|
      label = if o.is_seller
        "color:blue|label:S"
      else
        "color:red|label:B"
      end
      "&markers=#{label}|#{o.latitude},#{o.longitude}"
    end
  end
end

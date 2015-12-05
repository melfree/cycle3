module ApplicationHelper
  def load_icon(txt=nil)
    "#{txt} <i class='fa fa-spinner fa-spin'></i>".html_safe
  end
    
  def static_map_for(users, options = {})
    width = options[:width] || 700
    height = options[:height] || 400
    zoom = options[:zoom] || 16
    params = {
      :center => 'Carnegie+Mellon+University',
      :zoom => zoom,
      :size => "#{width}x#{height}",
      :visual_refresh => true,
      }.merge(options)

    query_string =  params.map{|k,v| "#{k}=#{v}"}.join("&")
    query_string << markers_from(users).join('')
    "http://maps.googleapis.com/maps/api/staticmap?#{query_string}"
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

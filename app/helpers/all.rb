
%w{
  avatar_image_helper
  logo_image_helper
  parity_helper
  pie_chart_helper
  traffic_light_helper
  tip_helper
}.each { |sourcefile| require_relative './' + sourcefile }


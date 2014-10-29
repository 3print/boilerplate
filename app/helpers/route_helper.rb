module RouteHelper
  def route_exists_for?(*args)
    route_exist = true
    begin
      polymorphic_url(*args)
    rescue
      route_exist = false
    end
    route_exist
  end
end

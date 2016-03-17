widgets.define 'coordinates', (el) ->
  $el = $(el)
  $address = $el.find('[name*="address"]')
  $city = $el.find('[name*="city"]')
  $zip_code = $el.find('[name*="zip_code"]')
  $lat = $el.find('[name*="lat"]')
  $lng = $el.find('[name*="lng"]')

  full_address = -> "#{$address.val()}, #{$zip_code.val()} #{$city.val()}"

  error_message = ->
    $address.parents('.form-group').after("""
    <div class='alert alert-warning' style='margin-top: 10px'>#{'widgets.coordinates.error'.t()}</div>
    """)

  get_coords = ->
    $el.find('.alert-warning').remove()
    $.ajax({
      url: "http://maps.googleapis.com/maps/api/geocode/json"
      type: 'GET'
      dataType: 'json'
      data:
        address: full_address()
        sensor: false

      success: (res) ->
        if res.results.length
          $lat.val(res.results[0].geometry.location.lat)
          $lng.val(res.results[0].geometry.location.lng)
        else
          error_message()

      fail: (err) ->
        error_message()
    })

  $address.on 'change', get_coords
  $city.on 'change', get_coords
  $zip_code.on 'change', get_coords

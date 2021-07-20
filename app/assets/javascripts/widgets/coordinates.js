widgets.define('coordinates', function(el) {
  let $el = $(el);
  let $address = $el.find('[name*="address"]');
  let $city = $el.find('[name*="city"]');
  let $zip_code = $el.find('[name*="zip_code"]');
  let $lat = $el.find('[name*="lat"]');
  let $lng = $el.find('[name*="lng"]');

  let full_address = () => `${$address.val()}, ${$zip_code.val()} ${$city.val()}`;

  let error_message = () =>
    $address.parents('.form-group').after(`\
<div class='alert alert-warning' style='margin-top: 10px'>${'widgets.coordinates.error'.t()}</div>\
`)
  ;

  let get_coords = function() {
    $el.find('.alert-warning').remove();
    return $.ajax({
      url: "http://maps.googleapis.com/maps/api/geocode/json",
      type: 'GET',
      dataType: 'json',
      data: {
        address: full_address(),
        sensor: false
      },

      success(res) {
        if (res.results.length) {
          $lat.val(res.results[0].geometry.location.lat);
          return $lng.val(res.results[0].geometry.location.lng);
        } else {
          return error_message();
        }
      },

      fail(err) {
        return error_message();
      }
    });
  };

  $address.on('change', get_coords);
  $city.on('change', get_coords);
  return $zip_code.on('change', get_coords);
});

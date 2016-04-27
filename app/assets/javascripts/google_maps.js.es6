function parseMetaTag(name) {
  const content = $(`meta[name="${name}"]`).attr('content');

  return JSON.parse(content);
}

function calculateBounds(markers) {
  const bounds = new google.maps.LatLngBounds();

  markers.forEach(marker => {
    bounds.extend(marker.getPosition());
  });

  return bounds;
}

function initMap() {
  const center = parseMetaTag('google-map-center');
  const donations = parseMetaTag('google-map-markers');
  const mapOptions = {
    center: center,
    mapTypeId: google.maps.MapTypeId.MAP,
    zoom: 8,
  };
  const map = new google.maps.Map(document.getElementById('map'), mapOptions);

  const markers = donations.map(donation => {
    return new google.maps.Marker({
      map: map,
      position: donation,
    });
  });
  map.fitBounds(calculateBounds(markers));
}

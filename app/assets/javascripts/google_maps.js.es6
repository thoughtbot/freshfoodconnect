function parseMetaTag(name) {
  const content = $(`meta[name="${name}"]`).attr('content');

  return JSON.parse(content);
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

  donations.map(donation => {
    return new google.maps.Marker({
      map: map,
      position: donation,
    });
  });
}

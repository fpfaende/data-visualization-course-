import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

import java.util.List;

ArrayList<SubwayStation> stations;

Location shanghaiLocation = new Location(31.2f, 121.5f);

UnfoldingMap map;

void setup() {
  size(800, 600, P2D);
  smooth();

  
  map = new UnfoldingMap(this, new StamenMapProvider.TonerBackground());
  map.zoomToLevel(11);
  map.panTo(shanghaiLocation);
  map.setZoomRange(9, 17); // prevent zooming too far out
  map.setPanningRestriction(shanghaiLocation, 50);
  MapUtils.createDefaultEventDispatcher(this, map);
  
  stations = new ArrayList<SubwayStation>();

  Table table = loadTable("data.csv", "header");
  for (TableRow row : table.rows ()) {
    String cn = row.getString("Id");
    String en = row.getString("latin");
    float lat = row.getFloat("Latitude");
    float lon = row.getFloat("Longitude");
    int [] lines = int(split(row.getString("lines"), '-'));

    stations.add(new SubwayStation(cn, en, lat, lon, lines));
    // Do something with the data of each row
  }

  
}


void draw() {
  background(0);
  map.draw();
  fill(255,0,0,255);
  
  for (SubwayStation station : stations) {
    ScreenPosition position = map.getScreenPosition(station.location);
    ellipse(position.x, position.y, 5, 5);
    
  }
}

class SubwayStation {
  Location location;
  String chinese;
  String english;
  float latitude, longitude;
  int [] lines;

  SubwayStation (String cn, String en, float lat, float lon, int [] lines) {
    chinese = cn;
    english = en;
    latitude = lat;
    longitude = lon;
    this.lines = lines;
    location = new Location(latitude, longitude);
  }
}


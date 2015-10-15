/**
 * Skecth that show the GPS coordinates 
 * longitude and latitude 
 *
 * http://www.marlonj.com
 * http://www.maryjanesoft.com 
 *
 * @author Marlon J. Manrique  
 *
 * Changes : 
 *
 * 1.0 (December - 2010) Initial Release 
 * 
 * $Id$ 
 */ 

// Class that retrives the location
ALocation aLocation;

//  The messages to show in the screen 
String longitude = "Touch The Screen"; 
String latitude = "To load the Location Data"; 

/* Create the aLocation object */
void setup()
{
  aLocation = new ALocation(this);
}

/* Draw the messages */
void draw()
{
  background(200);
  text(longitude,100,100);
  text(latitude,100,120);
}

/* When the screen is touch the location is show */
void mousePressed()
{
  showLocation();
}

/* Request the location from the GPS 
   if null, no location is available 
   else show the longitude and latitude in the screen */
public void showLocation()
{
  // Get the location 
  double[] location = aLocation.getLocation();
  
  // Check if the location is available 
  // and update the messages 
  if(location != null)
  {
    longitude = "Longitude = " + location[0];
    latitude = "Latitude = " + location[1];
  }
  // No location available, show an error 
  else
  {
    longitude = "Error";
    latitude = "Location not Available";
  }
}

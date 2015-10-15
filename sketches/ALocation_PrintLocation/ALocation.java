import processing.core.PApplet;

import android.content.Context;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.Looper;

/**
 * Processing for Android class to get Location 
 *
 * @author Marlon J. Manrique 
 */ 
public class ALocation implements LocationListener
{
  /** The parent Sketch */
  PApplet pApplet; 
  
  /** The Location Manager of Android API */
  LocationManager locationManager;
  
  /** Location Provider. Can be gps, network */ 
  String provider = "gps"; // The gps works with the emulator 

  /** Create a new location manager with the current sketch */ 
  public ALocation(PApplet pApplet)
  {
    // Set the current sketch 
    this.pApplet = pApplet; 
    
    // Get a Location Manager for this application 
    locationManager = (LocationManager) 
      pApplet.getSystemService(Context.LOCATION_SERVICE);          
    
    // Star a listener to obtain the location 
    // required for the emulator to retrive the gps location
    startListener();
  }
  
  /** Start a location listener to obtain changes in the location */
  private void startListener() 
  {
    // Create a new Thread and start it 
    new Thread() 
    {
      /** Set the location listener */
      public void run() 
      {
        // Init a message looper, required for Android 
        Looper.prepare();
        // Request the location from the provider 
        // each 60 seconds with a minimum notification of
        // 20 meters
        locationManager.requestLocationUpdates(provider,
          60000,20,ALocation.this);
      }
    }.start();
  }

  /** Return the location [longitude,latitude], null if no location available */
  public double[] getLocation()
  {
    // Create the array to store latitude and longitude 
    double[] data = null;
    
    // Get the location using the manager 
    Location location = locationManager.getLastKnownLocation(provider);

    // If the location is not null 
    // Get the latitude and longitude     
    if(location != null)
    {
      data = new double[2];
      data[0] = location.getLongitude();
      data[1] = location.getLatitude();
    }
    
    // Return the data 
    return data;
  }

  /* Methods required for the Listener, not implemented yet */ 
  @Override
  public void onLocationChanged(Location loc)
  {
  }

  @Override
  public void onProviderDisabled(String provider)
  {
  }

  @Override
  public void onProviderEnabled(String provider)
  {
  }
  
  @Override
  public void onStatusChanged(String provider, int status, Bundle extras)
  {
  }
}

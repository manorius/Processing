// MORE INFO HERE http://forum.processing.org/one/topic/sound-libraries.html

import android.media.*;
import android.content.res.*;

void setup()
{
  size(10,10,P2D);
  try {
    MediaPlayer snd = new MediaPlayer();
    AssetManager assets = this.getAssets();
    AssetFileDescriptor fd = assets.openFd("Tchaikovsky.mp3");
    snd.setDataSource(fd.getFileDescriptor(), fd.getStartOffset(), fd.getLength());
    snd.prepare();
  } 
  catch (IllegalArgumentException e) {
    e.printStackTrace();
  } 
  catch (IllegalStateException e) {
    e.printStackTrace();
  } catch (IOException e) {
    e.printStackTrace();
  }
}

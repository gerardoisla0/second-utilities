package cl.ceisufro.native_video_view_example

import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity : FlutterActivity() {
  private val CHANNEL = "videoview0"

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    var channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    
    channel.setMethodCallHandler { call, result ->
        if (call.method == "s3_upload") {
            //Add you login here 
            Log.d("NVV#FlutterActivity", " native_video_view_example ::: FlutterActivity ")
            channel.invokeMethod("callBack", "data1")



        }
    }
  }
}

package ng.com.ebena.feed.app

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable edge-to-edge display (Android 15+ compatible)
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}

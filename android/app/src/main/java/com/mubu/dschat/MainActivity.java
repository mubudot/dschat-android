package com.mubu.dschat;

import android.os.Bundle;
import androidx.activity.EdgeToEdge;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Draw edge-to-edge on every Android version (Android 15+ enforces it anyway).
        // Capacitor SystemBars (insetsHandling=css) then either passes the real insets to the
        // WebView (env()/--safe-area-inset-*) or pads the WebView natively on old WebViews.
        EdgeToEdge.enable(this);
        super.onCreate(savedInstanceState);
    }
}

package com.mubu.dschat;

import android.os.Bundle;
import android.webkit.WebView;
import androidx.core.graphics.Insets;
import androidx.core.view.ViewCompat;
import androidx.core.view.WindowInsetsCompat;
import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Capacitor SystemBars already resizes the WebView for the keyboard (it pads the
        // decor view by the IME height). WebView >= 139 would additionally shrink its visual
        // viewport by the IME insets it still receives, so the page's visualViewport ends up
        // about one keyboard height too short and the chat input floats far above the
        // keyboard. The keyboard is handled natively, so hand the WebView zero IME insets.
        WebView webView = getBridge().getWebView();
        ViewCompat.setOnApplyWindowInsetsListener(webView, (v, insets) -> {
            WindowInsetsCompat withoutIme = new WindowInsetsCompat.Builder(insets)
                .setInsets(WindowInsetsCompat.Type.ime(), Insets.NONE)
                .setVisible(WindowInsetsCompat.Type.ime(), false)
                .build();
            return ViewCompat.onApplyWindowInsets(v, withoutIme);
        });
    }
}

package com.app.markboot;


import androidx.annotation.NonNull;


import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;

public class MainActivity extends FlutterFragmentActivity {

    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        flutterEngine.getPlugins().add(new FirebaseMessagingPlugin());

    }
}


package de.michaeltamm.meine_musik;

import android.os.Build;

import androidx.annotation.NonNull;
import com.ryanheise.audioservice.AudioServiceActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends AudioServiceActivity {
  private static final String METHOD_CHANNEL_NAME = "de.michaeltamm.meine_musik";

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    final BinaryMessenger binaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
    new MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME)
      .setMethodCallHandler(
        (methodCall, result) -> {
          if (methodCall.method.equals("getAppVersion")) {
            result.success(BuildConfig.VERSION_NAME);
          } else if (methodCall.method.equals("getApiLevel")) {
            result.success(Build.VERSION.SDK_INT);
          } else {
            result.notImplemented();
          }
        }
      );
    MeineMusikPigeonApi.MeineMusikNativeMethods.setUp(binaryMessenger, new MeineMusikNativeMethodsImpl(getContentResolver()));
  }
}

package de.michaeltamm.meine_musik;

import androidx.annotation.NonNull;
import com.ryanheise.audioservice.AudioServiceActivity;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;

public class MainActivity extends AudioServiceActivity {

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    final BinaryMessenger binaryMessenger = flutterEngine.getDartExecutor().getBinaryMessenger();
    MeineMusikPigeonApi.MeineMusikNativeMethods.setUp(binaryMessenger, new MeineMusikNativeMethodsImpl(getContentResolver()));
  }
}

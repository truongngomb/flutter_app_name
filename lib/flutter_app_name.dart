library flutter_app_name;

import "package:rename/rename.dart";

import "context.dart";
import "common.dart";
import "ios.dart" as ios;
import "android.dart" as android;

void run() {
  final context = Context(
    yamlKeyName: "flutter_app_name",
    pubspecPath: "pubspec.yaml",
    infoPlistPath: "ios/Runner/Info.plist",
    androidManifestPaths: [
      "android/app/src/main/AndroidManifest.xml",
      "android/app/src/debug/AndroidManifest.xml",
      "android/app/src/profile/AndroidManifest.xml",
    ],
  );

  ios.updateLauncherName(context);
  android.updateLauncherNames(context);
  final id = fetchId(context);
  if (id != null) {
    changeBundleId(id, <Platform>[]);
  }
}

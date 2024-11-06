import "package:xml/xml.dart";

import "context.dart";
import "common.dart" as common;

String? fetchCurrentBundleName(
    Context context, String androidManifestPath, String manifestFileData) {
  final parsed = XmlDocument.parse(
    manifestFileData,
  );

  final element = parsed.findAllElements("application");
  if (element.isEmpty) {
    return null;
  }

  final application = element.toList()[0];

  final List<String> label = application.attributes
      .where((attrib) => attrib.toString().contains("android:label"))
      .map((i) => i.toString())
      .toList();

  if (label.isEmpty) {
    throw Exception("Could not find android:label in ${androidManifestPath}");
  }

  return label[0] as String;
}

String fetchCurrentPackageName(
    Context context, String androidManifestPath, String manifestFileData) {
  final parsed = XmlDocument.parse(
    manifestFileData,
  );

  final application = parsed.findAllElements("manifest").toList()[0];

  final List<String> label = application.attributes
      .where((attrib) => attrib.toString().contains("package"))
      .map((i) => i.toString())
      .toList();

  if (label.isEmpty) {
    throw Exception("Could not find package in ${androidManifestPath}");
  }

  return label[0] as String;
}

String setNewBundleName(Context context, String manifestFileData,
    String currentBundleName, String desiredBundleName) {
  return manifestFileData.replaceAll(
      currentBundleName, 'android:label="${desiredBundleName}"');
}

String setNewPackageName(Context context, String manifestFileData,
    String currentPackageName, String desiredPackageName) {
  return manifestFileData.replaceAll(
      currentPackageName, 'package="${desiredPackageName}"');
}

String setNewScheme(Context context, String manifestFileData,
    String currentPackageName, String desiredPackageName) {
  return manifestFileData.replaceAll(
      currentPackageName, 'android:scheme="${desiredPackageName}"');
}

void updateLauncherNames(Context context) {
  for (var i = 0; i < context.androidManifestPaths.length; i++) {
    final androidManifestPath = context.androidManifestPaths[i];
    updateLauncherName(context, androidManifestPath);
  }
}

void updateLauncherName(Context context, String androidManifestPath) {
  final String manifestFileData = common.readFile(androidManifestPath);
  String updatedManifestData = "";

  final String desiredBundleName = common.fetchLauncherName(context);
  final String? currentBundleName =
      fetchCurrentBundleName(context, androidManifestPath, manifestFileData);
  if (currentBundleName != null) {
    updatedManifestData = setNewBundleName(
        context, manifestFileData, currentBundleName, desiredBundleName);
  }

  final String? desiredPackageName = common.fetchId(context);
  if (desiredPackageName != null) {
    final String currentPackageName =
        fetchCurrentPackageName(context, androidManifestPath, manifestFileData);
    updatedManifestData = setNewPackageName(
        context, manifestFileData, currentPackageName, desiredPackageName);
    updatedManifestData = setNewScheme(
        context, manifestFileData, currentPackageName, desiredPackageName);
  }

  common.overwriteFile(androidManifestPath, updatedManifestData);
}

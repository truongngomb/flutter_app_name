import "dart:io";
import "package:xml/xml.dart";

import "context.dart";
import "common.dart" as common;

String fetchCurrentBundleName(
    Context context, String androidManifestPath, String manifestFileData) {
  final parsed = XmlDocument.parse(
    manifestFileData,
  );

  final application = parsed.findAllElements("application").toList()[0];

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

void updateLauncherNames(Context context) {
  for (var i = 0; i < context.androidManifestPaths.length; i++) {
    final androidManifestPath = context.androidManifestPaths[i];
    updateLaunchetName(context, androidManifestPath);
  }
}

void updateLaunchetName(Context context, String androidManifestPath) {
  final String manifestFileData = common.readFile(androidManifestPath);

  final String desiredBundleName = common.fetchLauncherName(context);
  final String currentBundleName =
      fetchCurrentBundleName(context, androidManifestPath, manifestFileData);
  String updatedManifestData = setNewBundleName(
      context, manifestFileData, currentBundleName, desiredBundleName);

  final String? desiredPackageName = common.fetchId(context);
  if (desiredPackageName != null) {
    final String currentPackageName =
        fetchCurrentPackageName(context, androidManifestPath, manifestFileData);
    updatedManifestData = setNewPackageName(
        context, manifestFileData, currentPackageName, desiredPackageName);
  }

  common.overwriteFile(androidManifestPath, updatedManifestData);
}

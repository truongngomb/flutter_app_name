class Context {
  final String infoPlistPath;
  final List<String> androidManifestPaths;
  final String pubspecPath;
  final String yamlKeyName;

  Context({
    required this.yamlKeyName,
    required this.androidManifestPaths,
    required this.pubspecPath,
    required this.infoPlistPath,
  });
}

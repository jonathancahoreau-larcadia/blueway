class MapConfig {
  static const String accessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
  );

  static const String styleUrl = String.fromEnvironment('MAPTILER_STYLE_URL');
}

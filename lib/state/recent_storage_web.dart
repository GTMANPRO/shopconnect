// Web implementation using localStorage.
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

String? getString(String key) => html.window.localStorage[key];
void setString(String key, String value) {
  html.window.localStorage[key] = value;
}

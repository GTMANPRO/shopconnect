import 'package:url_launcher/url_launcher.dart';

class AffiliateService {
  static Future<void> openAffiliateLink(String url) async {
    final uri = Uri.parse(url);
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) {
      throw Exception('Could not launch $url');
    }
  }
}

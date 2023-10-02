// ignore_for_file: unused_element
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart';

final String _accessKey = dotenv.get('ACCESS_KEY', fallback: '');
final String _accessSecret = dotenv.get('ACCESS_SECRET', fallback: '');

Auth authGetter() {
  return Auth(
      accessKey: _accessKey,
      accessSecret: _accessSecret,
      expire: '2024-02-23T14:02:46Z',
      secureToken: '');
}

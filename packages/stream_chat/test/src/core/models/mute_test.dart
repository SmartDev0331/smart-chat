import 'package:stream_chat/src/core/models/channel_model.dart';
import 'package:stream_chat/src/core/models/mute.dart';
import 'package:stream_chat/src/core/models/user.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/mute', () {
    test('should parse json correctly', () {
      final mute = Mute.fromJson(jsonFixture('mute.json'));
      expect(mute.channel, isA<ChannelModel>());
      expect(mute.user, isA<User>());
      expect(mute.createdAt, DateTime.parse('2020-12-04T10:39:06.512021Z'));
    });
  });
}

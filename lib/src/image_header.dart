import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/back_button.dart';
import 'package:stream_chat_flutter/src/channel_info.dart';
import 'package:stream_chat_flutter/src/channel_name.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/stream_icons.dart';

import './channel_name.dart';
import 'channel_image.dart';
import 'image_actions_modal.dart';
import 'stream_channel.dart';

class ImageHeader extends StatelessWidget implements PreferredSizeWidget {
  /// True if this header shows the leading back button
  final bool showBackButton;

  /// Callback to call when pressing the back button.
  /// By default it calls [Navigator.pop]
  final VoidCallback onBackPressed;

  /// Callback to call when the header is tapped.
  final VoidCallback onTitleTap;

  /// Callback to call when the image is tapped.
  final VoidCallback onImageTap;

  final Message message;

  final String userName;
  final String sentAt;

  final List<String> urls;
  final currentIndex;

  /// Creates a channel header
  ImageHeader({
    Key key,
    this.message,
    this.urls,
    this.currentIndex,
    this.showBackButton = true,
    this.onBackPressed,
    this.onTitleTap,
    this.onImageTap,
    this.userName = '',
    this.sentAt = '',
  })  : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Theme.of(context).brightness,
      elevation: 1,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                StreamIcons.close,
                color: Colors.black,
                size: 24.0,
              ),
              onPressed: onBackPressed,
            )
          : SizedBox(),
      backgroundColor:
          StreamChatTheme.of(context).channelTheme.channelHeaderTheme.color,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            StreamIcons.menu_point_v,
            color: Colors.black,
            size: 24.0,
          ),
          onPressed: () {
            _showMessageActionModalBottomSheet(context);
          },
        ),
      ],
      centerTitle: true,
      title: InkWell(
        onTap: onTitleTap,
        child: Container(
          height: preferredSize.height,
          width: preferredSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                userName,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              Text(
                sentAt,
                style: StreamChatTheme.of(context).channelPreviewTheme.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;

  void _showMessageActionModalBottomSheet(BuildContext context) {
    final channel = StreamChannel.of(context).channel;

    showDialog(
        context: context,
        builder: (context) {
          return StreamChannel(
            channel: channel,
            child: ImageActionsModal(
              userName: userName,
              sentAt: sentAt,
              message: message,
              urls: urls,
              currentIndex: currentIndex,
            ),
          );
        });
  }
}

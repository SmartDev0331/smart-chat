import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

class InfoTile extends StatelessWidget {
  final String message;
  final Widget child;
  final bool showMessage;
  final Alignment tileAnchor;
  final Alignment childAnchor;

  InfoTile({
    this.message,
    this.child,
    this.showMessage,
    this.tileAnchor,
    this.childAnchor,
  });

  @override
  Widget build(BuildContext context) {
    return PortalEntry(
      visible: showMessage,
      portalAnchor: tileAnchor ?? Alignment.topCenter,
      childAnchor: childAnchor ?? Alignment.bottomCenter,
      portal: Container(
        height: 25.0,
        color: StreamChatTheme.of(context).colorTheme.grey.withOpacity(0.9),
        child: Center(
          child: Text(
            message,
            style: StreamChatTheme.of(context).textTheme.body.copyWith(
                  color: Colors.white,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
      child: child,
    );
  }
}

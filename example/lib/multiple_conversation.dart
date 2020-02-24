import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = Client('qk4nn7rpcn75');

  await client.setUser(
    User(id: "wild-breeze-7"),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo',
  );

  final channelClient = client.channel('messaging', id: 'godevs');

  channelClient.watch();

  runApp(
    StreamChat(
      client: client,
      child: MaterialApp(
        home: StreamChat(
          client: client,
          child: ChannelListPage(),
        ),
      ),
    ),
  );
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelListView(
        filter: {
          'members': {
            '\$in': [StreamChat.of(context).user.id],
          }
        },
        sort: [SortOption("last_message_at")],
        pagination: PaginationParams(
          limit: 20,
        ),
        onChannelTap: (channelClient) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return StreamChannel(
              child: ChannelPage(),
              channelClient: channelClient,
            );
          }));
        },
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/message_actions_modal.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
        MaterialPageRoute(builder: (context) => const SizedBox()));
    registerFallbackValue(Message());
  });

  testWidgets(
    'it should show the all actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('MessageWidget')), findsOneWidget);
      expect(find.text('Thread Reply'), findsOneWidget);
      expect(find.text('Reply'), findsOneWidget);
      expect(find.text('Edit Message'), findsOneWidget);
      expect(find.text('Delete Message'), findsOneWidget);
      expect(find.text('Copy Message'), findsOneWidget);
    },
  );

  testWidgets(
    'it should show some actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: MessageActionsModal(
                showEditMessage: false,
                showCopyMessage: false,
                showDeleteMessage: false,
                showReplyMessage: false,
                showThreadReplyMessage: false,
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('MessageWidget')), findsOneWidget);
      expect(find.text('Reply'), findsNothing);
      expect(find.text('Thread reply'), findsNothing);
      expect(find.text('Edit message'), findsNothing);
      expect(find.text('Delete message'), findsNothing);
      expect(find.text('Copy message'), findsNothing);
    },
  );

  testWidgets(
    'it should show custom actions',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
                customActions: [
                  MessageAction(
                    leading: const Icon(Icons.check),
                    title: const Text('title'),
                    onTap: (m) {
                      tapped = true;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('title'), findsOneWidget);

      await tester.tap(find.text('title'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on reply should call the callback',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: MessageActionsModal(
                onReplyTap: (m) {
                  tapped = true;
                },
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reply'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on thread reply should call the callback',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: themeData,
          home: StreamChat(
            streamChatThemeData: streamTheme,
            client: client,
            child: SizedBox(
              child: MessageActionsModal(
                onThreadReplyTap: (m) {
                  tapped = true;
                },
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Thread Reply'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on edit should show the edit bottom sheet',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Message'));

      await tester.pumpAndSettle();

      expect(find.byType(MessageInput), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on edit should show use the custom builder',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                editMessageInputBuilder: (context, m) => const Text('test'),
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Edit Message'));

      await tester.pumpAndSettle();

      expect(find.text('test'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on copy should use the callback',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                onCopyTap: (m) => tapped = true,
                message: Message(
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Copy Message'));

      expect(tapped, true);
    },
  );

  testWidgets(
    'tapping on resend should call send message',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.sendMessage(any()))
          .thenAnswer((_) async => SendMessageResponse());

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  status: MessageSendingStatus.failed,
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resend'));

      verify(() => channel.sendMessage(any())).called(1);
    },
  );

  testWidgets(
    'tapping on resend should call update message if editing the message',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.updateMessage(any()))
          .thenAnswer((_) async => UpdateMessageResponse());

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  status: MessageSendingStatus.failed_update,
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resend Edited Message'));

      verify(() => channel.updateMessage(any())).called(1);
    },
  );

  testWidgets(
    'tapping on flag message should show the dialog',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flag Message'));
      await tester.pumpAndSettle();

      expect(find.text('Flag Message'), findsNWidgets(2));

      await tester.tap(find.text('FLAG'));
      await tester.pumpAndSettle();

      verify(() => client.flagMessage('testid')).called(1);
    },
  );

  testWidgets(
    'if flagging a message throws an error the error dialog should appear',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.flagMessage(any()))
          .thenThrow(StreamChatNetworkError(ChatErrorCode.internalSystemError));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flag Message'));
      await tester.pumpAndSettle();

      expect(find.text('Flag Message'), findsNWidgets(2));

      await tester.tap(find.text('FLAG'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
    },
  );

  testWidgets(
    'if flagging an already flagged message no error should appear',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.flagMessage(any()))
          .thenThrow(StreamChatNetworkError(ChatErrorCode.inputError));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Flag Message'));
      await tester.pumpAndSettle();

      expect(find.text('Flag Message'), findsNWidgets(2));

      await tester.tap(find.text('FLAG'));
      await tester.pumpAndSettle();

      expect(find.text('Message flagged'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping on delete message should call client.delete',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Message'));
      await tester.pumpAndSettle();

      expect(find.text('Delete message'), findsOneWidget);

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      verify(() => channel.deleteMessage(any())).called(1);
    },
  );

  testWidgets(
    'tapping on delete message should call client.delete',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.deleteMessage(any()))
          .thenThrow(StreamChatNetworkError(ChatErrorCode.internalSystemError));

      final themeData = ThemeData();
      final streamTheme = StreamChatThemeData.fromTheme(themeData);

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChat(
            client: client,
            streamChatThemeData: streamTheme,
            child: child,
          ),
          theme: themeData,
          home: StreamChannel(
            showLoading: false,
            channel: channel,
            child: SizedBox(
              child: MessageActionsModal(
                message: Message(
                  id: 'testid',
                  text: 'test',
                  user: User(
                    id: 'user-id',
                  ),
                ),
                messageTheme: streamTheme.ownMessageTheme,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete Message'));
      await tester.pumpAndSettle();

      expect(find.text('Delete message'), findsOneWidget);

      await tester.tap(find.text('DELETE'));
      await tester.pumpAndSettle();

      expect(find.text('Something went wrong'), findsOneWidget);
    },
  );
}

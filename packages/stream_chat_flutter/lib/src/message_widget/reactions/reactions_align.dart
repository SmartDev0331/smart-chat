import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Document here!!
double calculateReactionsHorizontalAlignmentValue(
  User? user,
  Message message,
  BoxConstraints constraints,
  double maxSize,
  double? fontSize,
  int reactionsCount,
) {
  var result = 0.0;

  final shiftFactor = reactionsCount < 5 ? (5 - reactionsCount) * 0.1 : 0.0;
  final maxWidth = constraints.maxWidth;
  final maxHeight = constraints.maxHeight;

  final roughSentenceSize = message.roughMessageSize(fontSize);

  final divFactor = message.attachments.isNotEmpty
      ? 1
      : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / maxSize));

  print('INFO - max width: $maxWidth. '
      'maxHeight: $maxHeight '
      'shiftFactor: $shiftFactor '
      'divFactor: $divFactor');

  if (user?.id == message.user?.id) {
    if (divFactor >= 1.0) {
      /*
         This is an empiric value. This number tries to approximate all the
         offset necessary for the position of reaction look the best way
         possible.
         */
      const constant = 1300;

      result = shiftFactor - maxWidth / constant;
    } else {
      // Small messages, it is simpler to align then.
      result = 1.2 - divFactor;
    }
  } else {
    if (divFactor >= 1.0) {
      result = shiftFactor + 0.2;
    } else {
      result = -(1.2 - divFactor);
    }
  }

  print('INFO - result: $result');

  // Ensure reactions don't get pushed past the edge of the screen.
  //
  // Hacky!!! Needs improvement!!!
  if (result > 1.0) {
    return 1;
  } else if (result < -1.0) {
    return -1;
  } else {
    return result;
  }
}

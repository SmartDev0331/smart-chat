import 'package:flutter/material.dart';

/// Controller for the [StreamTextField] widget.
class MessageTextFieldController extends TextEditingController {
  /// Returns a new MessageTextFieldController
  MessageTextFieldController({
    String? text,
    this.textPatternStyle,
  }) : super(text: text);

  /// Returns a new MessageTextFieldController with the given text [value].
  MessageTextFieldController.fromValue(
    TextEditingValue? value, {
    this.textPatternStyle,
  }) : super.fromValue(value);

  /// A map of style to apply to the text matching the RegExp patterns.
  final Map<RegExp, TextStyle>? textPatternStyle;

  /// Builds a [TextSpan] from the current text,
  /// highlighting the matches for [textPatternStyle].
  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final pattern = textPatternStyle;
    if (pattern == null) {
      return super.buildTextSpan(
        context: context,
        style: style,
        withComposing: withComposing,
      );
    }

    return TextSpan(text: text, style: style).splitMapJoin(
      RegExp(pattern.keys.map((it) => it.pattern).join('|')),
      onMatch: (match) {
        final text = match[0]!;
        final key = pattern.keys.firstWhere((it) => it.hasMatch(text));
        return TextSpan(
          text: text,
          style: pattern[key],
        );
      },
    );
  }
}

extension _TextSpanX on TextSpan {
  TextSpan splitMapJoin(
    Pattern pattern, {
    TextSpan Function(Match)? onMatch,
    TextSpan Function(TextSpan)? onNonMatch,
  }) {
    final children = <TextSpan>[];

    toPlainText().splitMapJoin(
      pattern,
      onMatch: (match) {
        final span = TextSpan(text: match.group(0), style: style);
        final updated = onMatch?.call(match);
        children.add(updated ?? span);
        return span.toPlainText();
      },
      onNonMatch: (text) {
        final span = TextSpan(text: text, style: style);
        final updatedSpan = onNonMatch?.call(span);
        children.add(updatedSpan ?? span);
        return span.toPlainText();
      },
    );

    return TextSpan(style: style, children: children);
  }
}

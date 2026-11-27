import 'package:flutter/material.dart';

enum PillTagTone { present, half, off }

/// One floating pill on an onboarding slide.
///
/// Position is the pill's centre inside a 390 × 350 design frame, so the
/// whole cluster scales with the screen.
class OnboardPillData {
  final String label;

  /// Leading emoji, or null when [avatarLetter] is used.
  final String? emoji;
  final String? avatarLetter;
  final Color? avatarColor;

  /// Small status tag after the label ("Present", "½ day", "Off").
  final String? tag;
  final PillTagTone tagTone;

  final Offset center;
  final double angleDeg;

  const OnboardPillData({
    required this.label,
    required this.center,
    required this.angleDeg,
    this.emoji,
    this.avatarLetter,
    this.avatarColor,
    this.tag,
    this.tagTone = PillTagTone.present,
  });
}

class OnboardSlide {
  final List<OnboardPillData> pills;
  final String title;
  final String body;

  const OnboardSlide({
    required this.pills,
    required this.title,
    required this.body,
  });

  static const Size frame = Size(390, 350);

  // Pill slots shared by all slides: centre in the frame and tilt.
  static const _slots = <(Offset, double)>[
    (Offset(108, 36), -5),
    (Offset(295, 32), 4),
    (Offset(98, 108), 3),
    (Offset(286, 106), -2.5),
    (Offset(104, 174), -3),
    (Offset(292, 172), 4),
    (Offset(104, 246), 4),
    (Offset(286, 244), -3),
    (Offset(207, 310), 2),
  ];

  static OnboardPillData _emoji(int slot, String emoji, String label) =>
      OnboardPillData(
        emoji: emoji,
        label: label,
        center: _slots[slot].$1,
        angleDeg: _slots[slot].$2,
      );

  static OnboardPillData _person(
    int slot,
    String name,
    Color color,
    String tag, [
    PillTagTone tone = PillTagTone.present,
  ]) => OnboardPillData(
    avatarLetter: name[0],
    avatarColor: color,
    label: name,
    tag: tag,
    tagTone: tone,
    center: _slots[slot].$1,
    angleDeg: _slots[slot].$2,
  );

  static final List<OnboardSlide> all = [
    OnboardSlide(
      title: 'Every well, every\nsite, in one place',
      body:
          'Create a site for each job, assign your crew, and see what’s to '
          'do, ongoing or done.',
      pills: [
        _emoji(0, '🚚', 'Rig transport'),
        _emoji(1, '📍', 'Meppadi'),
        _emoji(2, '⛏️', 'Borewell'),
        _emoji(3, '🧹', 'Well cleaning'),
        _emoji(4, '🔧', 'Pump fitting'),
        _emoji(5, '📍', 'Kalpetta'),
        _emoji(6, '💧', 'Open well'),
        _emoji(7, '📏', 'Deepening'),
        _emoji(8, '🪨', 'Ring well'),
      ],
    ),
    OnboardSlide(
      title: 'Mark today’s\ncrew in a few taps',
      body:
          'Present, half day or off — grouped by site, so you always know '
          'who worked where.',
      pills: [
        _person(0, 'Sukumar', const Color(0xFFA9C8B7), 'Present'),
        _person(1, 'Shaji', const Color(0xFFE4C4B6), 'Off', PillTagTone.off),
        _person(2, 'Biju', const Color(0xFFE8C6AE), '½ day', PillTagTone.half),
        _person(3, 'Manoj', const Color(0xFFC9D6C2), 'Present'),
        _person(4, 'Rajan', const Color(0xFFD3C59C), 'Present'),
        _person(5, 'Suresh', const Color(0xFFC6D4CB), 'Off', PillTagTone.off),
        _emoji(6, '📍', '4 at Meppadi'),
        _person(7, 'Vinod', const Color(0xFFBCC8D8), 'Present'),
        _person(8, 'Anil', const Color(0xFFDDB592), 'Present'),
      ],
    ),
    OnboardSlide(
      title: 'Wages and profit,\nworked out for you',
      body:
          'Days × rate minus advances, every Saturday. Plus what each well '
          'actually earned.',
      pills: [
        _emoji(0, '📈', 'Profit ₹31,200'),
        _emoji(1, '📆', 'Pay Saturday'),
        _emoji(2, '📲', 'Paid via UPI'),
        _emoji(3, '💰', 'Client ₹40,000'),
        _emoji(4, '✅', 'Balance ₹3,200'),
        _emoji(5, '📅', '6 days × ₹700'),
        _emoji(6, '⛽', 'Diesel ₹6,500'),
        _emoji(7, '💸', 'Advance ₹1,000'),
        _emoji(8, '🧾', 'Pipes ₹10,000'),
      ],
    ),
  ];
}

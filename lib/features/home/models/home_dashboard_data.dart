import 'package:flutter/material.dart';

/// Weekly wage summary shown in the hero card.
class WageSummary {
  final int earned;
  final int advances;
  final int paidCount;
  final int totalCount;
  final DateTime weekStart;
  final DateTime weekEnd;
  final String settleBy;

  const WageSummary({
    required this.earned,
    required this.advances,
    required this.paidCount,
    required this.totalCount,
    required this.weekStart,
    required this.weekEnd,
    required this.settleBy,
  });

  int get due => earned - advances;
}

enum CrewStatus { present, pending }

class CrewMember {
  final String name;
  final Color avatarColor;
  final CrewStatus status;

  const CrewMember({
    required this.name,
    required this.avatarColor,
    required this.status,
  });
}

class SiteSummary {
  final String name;
  final int amount;
  final int workersToday;
  final bool highlighted;

  const SiteSummary({
    required this.name,
    required this.amount,
    required this.workersToday,
    this.highlighted = false,
  });
}

class HomeDashboardData {
  final String adminName;
  final WageSummary wages;
  final int crewPresent;
  final int crewTotal;
  final List<CrewMember> crew;
  final List<SiteSummary> sites;

  const HomeDashboardData({
    required this.adminName,
    required this.wages,
    required this.crewPresent,
    required this.crewTotal,
    required this.crew,
    required this.sites,
  });

  // TODO: replace with data from Firestore once the wage/site collections exist.
  static final HomeDashboardData demo = HomeDashboardData(
    adminName: 'Joseph',
    wages: WageSummary(
      earned: 27975,
      advances: 3500,
      paidCount: 1,
      totalCount: 7,
      weekStart: DateTime(2026, 11, 16),
      weekEnd: DateTime(2026, 11, 21),
      settleBy: 'Today',
    ),
    crewPresent: 6,
    crewTotal: 8,
    crew: const [
      CrewMember(
        name: 'Anil',
        avatarColor: Color(0xFFDBAE8A),
        status: CrewStatus.present,
      ),
      CrewMember(
        name: 'Sukumar',
        avatarColor: Color(0xFFA9C8B5),
        status: CrewStatus.present,
      ),
      CrewMember(
        name: 'Biju',
        avatarColor: Color(0xFFE9C7B0),
        status: CrewStatus.present,
      ),
      CrewMember(
        name: 'Vinod',
        avatarColor: Color(0xFFB9CAD9),
        status: CrewStatus.present,
      ),
      CrewMember(
        name: 'Rajan',
        avatarColor: Color(0xFFCDBE93),
        status: CrewStatus.pending,
      ),
      CrewMember(
        name: 'Suresh',
        avatarColor: Color(0xFFC9D6A8),
        status: CrewStatus.present,
      ),
    ],
    sites: const [
      SiteSummary(
        name: 'Meppadi',
        amount: 31200,
        workersToday: 4,
        highlighted: true,
      ),
      SiteSummary(name: 'Kalpetta', amount: 12800, workersToday: 2),
    ],
  );
}

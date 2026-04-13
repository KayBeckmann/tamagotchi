import 'package:flutter/material.dart';

class Friend {
  final String id;
  final String username;
  final String creatureName;
  final int creatureLevel;
  final String creatureTypeId;
  final bool isOnline;
  final DateTime lastActive;

  Friend({
    required this.id,
    required this.username,
    required this.creatureName,
    required this.creatureLevel,
    required this.creatureTypeId,
    required this.isOnline,
    required this.lastActive,
  });
}

enum TradeStatus {
  open,
  pending,
  completed,
  cancelled,
}

class TradeOffer {
  final String id;
  final String fromUserId;
  final String fromUsername;
  final String offeredItemId;
  final String offeredItemName;
  final int offeredQuantity;
  final String wantedItemId;
  final String wantedItemName;
  final int wantedQuantity;
  final TradeStatus status;
  final DateTime createdAt;

  TradeOffer({
    required this.id,
    required this.fromUserId,
    required this.fromUsername,
    required this.offeredItemId,
    required this.offeredItemName,
    required this.offeredQuantity,
    required this.wantedItemId,
    required this.wantedItemName,
    required this.wantedQuantity,
    required this.status,
    required this.createdAt,
  });
}

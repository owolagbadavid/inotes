import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inotes/services/cloud/cloud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.text,
    required this.ownerUserId,
  });

  CloudNote.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        text = snapshot.get(textFieldName),
        ownerUserId = snapshot.get(userIdFieldName) as String;
}

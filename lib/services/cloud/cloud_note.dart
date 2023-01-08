// where we will have note representation within firestore

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hand_in_need/services/cloud/cloud_storage_constants.dart';
import 'package:flutter/material.dart';

@immutable
class CloudNote {
  // define three properties
  // text field for note
  // unique id for firestore
  // the user id itself
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudNote({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });
  // create construct from snapshot allow firestore retrieve properties
  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}

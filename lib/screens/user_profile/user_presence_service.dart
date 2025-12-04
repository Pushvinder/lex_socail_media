import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:the_friendz_zone/config/app_config.dart';
import 'package:the_friendz_zone/utils/firebase_utils.dart';

class UserPresenceService {
  static final UserPresenceService _instance = UserPresenceService._internal();
  factory UserPresenceService() => _instance;
  UserPresenceService._internal();

  final FirebaseDatabase _realtimeDb = FirebaseDatabase.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseReference? _userStatusRef;
  DatabaseReference? _connectedRef;

  String get currentUserId => StorageHelper().getUserId.toString();

  /// Initialize presence tracking when user logs in
  Future<void> initializePresence() async {
    if (currentUserId.isEmpty) return;

    try {
      // Reference to user's presence in Realtime Database
      _userStatusRef = _realtimeDb.ref('status/$currentUserId');
      _connectedRef = _realtimeDb.ref('.info/connected');

      // Listen to connection state
      _connectedRef!.onValue.listen((event) {
        final connected = event.snapshot.value as bool? ?? false;

        if (connected) {
          // When connected, set user as online
          _setUserOnline();

          // When disconnected, set user as offline (this runs on server)
          _userStatusRef!.onDisconnect().set({
            'online': false,
            'lastSeen': ServerValue.timestamp,
          });
        }
      });

      // Also update Firestore
      await _updateFirestorePresence(true);
    } catch (e) {
      print('Error initializing presence: $e');
    }
  }

  /// Set user as online
  Future<void> _setUserOnline() async {
    try {
      await _userStatusRef?.set({
        'online': true,
        'lastSeen': ServerValue.timestamp,
      });

      await _updateFirestorePresence(true);
    } catch (e) {
      print('Error setting user online: $e');
    }
  }

  /// Set user as offline (call when logging out)
  Future<void> setUserOffline() async {
    try {
      await _userStatusRef?.set({
        'online': false,
        'lastSeen': ServerValue.timestamp,
      });

      await _updateFirestorePresence(false);
    } catch (e) {
      print('Error setting user offline: $e');
    }
  }

  /// Update Firestore with presence data
  Future<void> _updateFirestorePresence(bool isOnline) async {
    try {
      await _firestore.collection(FirebaseUtils.users).doc(currentUserId).set({
        'online': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating Firestore presence: $e');
    }
  }

  /// Listen to another user's online status
  Stream<bool> getUserOnlineStatus(String userId) {
    return _realtimeDb
        .ref('status/$userId/online')
        .onValue
        .map((event) => event.snapshot.value as bool? ?? false);
  }

  /// Get user's last seen timestamp
  Stream<DateTime?> getUserLastSeen(String userId) {
    return _realtimeDb.ref('status/$userId/lastSeen').onValue.map((event) {
      final timestamp = event.snapshot.value as int?;
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
      return null;
    });
  }

  /// Dispose presence tracking
  void dispose() {
    setUserOffline();
  }
}

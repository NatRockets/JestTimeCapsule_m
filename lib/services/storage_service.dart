import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message.dart';

class StorageService {
  static const String _capsulesKey = 'time_capsules';

  Future<List<TimeCapsule>> getCapsules() async {
    final prefs = await SharedPreferences.getInstance();
    final String? capsulesJson = prefs.getString(_capsulesKey);

    if (capsulesJson == null) {
      return [];
    }

    final List<dynamic> decoded = json.decode(capsulesJson);
    return decoded.map((item) => TimeCapsule.fromJson(item)).toList();
  }

  Future<void> saveCapsules(List<TimeCapsule> capsules) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      capsules.map((capsule) => capsule.toJson()).toList(),
    );
    await prefs.setString(_capsulesKey, encoded);
  }

  Future<void> addCapsule(TimeCapsule capsule) async {
    final capsules = await getCapsules();
    capsules.add(capsule);
    await saveCapsules(capsules);
  }

  Future<void> updateCapsule(TimeCapsule updatedCapsule) async {
    final capsules = await getCapsules();
    final index = capsules.indexWhere((c) => c.id == updatedCapsule.id);
    if (index != -1) {
      capsules[index] = updatedCapsule;
      await saveCapsules(capsules);
    }
  }

  Future<void> deleteCapsule(String id) async {
    final capsules = await getCapsules();
    capsules.removeWhere((c) => c.id == id);
    await saveCapsules(capsules);
  }
}

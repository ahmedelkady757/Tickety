import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RememberedAccount {
  final String email;
  const RememberedAccount(this.email);
}

class RememberMeService {
  static const _kEnabled = 'remember_me_enabled';
  static const _kAccounts = 'remembered_accounts';

  final SharedPreferences prefs;
  final FlutterSecureStorage secureStorage;

  RememberMeService({required this.prefs, required this.secureStorage});

  bool get enabled => prefs.getBool(_kEnabled) ?? false;

  Future<void> setEnabled(bool value) async {
    await prefs.setBool(_kEnabled, value);
  }

  List<RememberedAccount> getAccounts() {
    final list = prefs.getStringList(_kAccounts) ?? const <String>[];
    return list.map(RememberedAccount.new).toList();
  }

  Future<void> saveAccount({required String email, required String password}) async {
    final normalized = email.trim().toLowerCase();
    final existing = prefs.getStringList(_kAccounts) ?? <String>[];
    if (!existing.contains(normalized)) {
      await prefs.setStringList(_kAccounts, [normalized, ...existing]);
    }
    await secureStorage.write(key: _pwKey(normalized), value: password);
  }

  Future<String?> getPassword(String email) {
    final normalized = email.trim().toLowerCase();
    return secureStorage.read(key: _pwKey(normalized));
  }

  Future<void> removeAccount(String email) async {
    final normalized = email.trim().toLowerCase();
    final existing = prefs.getStringList(_kAccounts) ?? <String>[];
    existing.removeWhere((e) => e == normalized);
    await prefs.setStringList(_kAccounts, existing);
    await secureStorage.delete(key: _pwKey(normalized));
  }

  String _pwKey(String email) => 'remembered_pw:$email';
}


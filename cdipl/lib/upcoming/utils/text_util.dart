import 'package:contacts_service/contacts_service.dart';

extension ContactInitials on Contact {
  String initials() {
    if (displayName != null && displayName!.isNotEmpty) {
      List<String> names = displayName!.split(' ');
      String firstInitial = names.isNotEmpty ? names[0][0] : '';
      String secondInitial = names.length > 1 ? names[1][0] : '';
      return (firstInitial + secondInitial).toUpperCase();
    }
    return '?';
  }
}

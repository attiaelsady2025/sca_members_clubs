import 'package:flutter/material.dart';

enum UserRole {
  member,
  admin,
  security,
  unauthorized
}

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  UserRole _currentRole = UserRole.member;

  void setRole(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        _currentRole = UserRole.admin;
        break;
      case 'security':
        _currentRole = UserRole.security;
        break;
      case 'member':
        _currentRole = UserRole.member;
        break;
      default:
        _currentRole = UserRole.unauthorized;
    }
  }

  UserRole get role => _currentRole;

  bool canAccessAdmin() => _currentRole == UserRole.admin;
  bool canAccessSecurity() => _currentRole == UserRole.admin || _currentRole == UserRole.security;
  bool isMember() => _currentRole == UserRole.member || _currentRole == UserRole.admin;
  
  // Widget helper for conditional display
  Widget protectedWidget({
    required Widget child,
    required List<UserRole> allowedRoles,
    Widget fallback = const SizedBox.shrink(),
  }) {
    if (allowedRoles.contains(_currentRole)) {
      return child;
    }
    return fallback;
  }
}

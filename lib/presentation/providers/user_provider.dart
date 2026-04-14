import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

class UserState {
  final User? user;
  final bool isLoading;
  final String? error;

  const UserState({this.user, this.isLoading = false, this.error});

  UserState copyWith({User? user, bool? isLoading, String? error}) {
    return UserState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(const UserState());

  void login(String phone) {
    state = state.copyWith(isLoading: true);
    state = state.copyWith(
      user: User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: 'User',
        phone: phone,
        countryCode: '+57',
        role: UserRole.both,
        createdAt: DateTime.now(),
      ),
      isLoading: false,
    );
  }

  void createAccount({
    required String name,
    required String phone,
    required String countryCode,
  }) {
    state = state.copyWith(isLoading: true);
    state = state.copyWith(
      user: User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
        countryCode: countryCode,
        role: UserRole.both,
        createdAt: DateTime.now(),
      ),
      isLoading: false,
    );
  }

  void logout() {
    state = const UserState();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(userProvider).user;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(userProvider).user != null;
});

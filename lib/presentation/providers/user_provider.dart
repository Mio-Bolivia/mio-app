import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/auth/secure_token_storage.dart';
import '../../data/repositories/user_repository.dart';
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
  final UserRepository _userRepository;

  UserNotifier(this._userRepository) : super(const UserState());

  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userRepository.login(
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> createAccount({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userRepository.createAccount(
        email: email,
        password: password,
      );
      state = state.copyWith(user: user, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> updateProfile({
    String? name,
    String? phone,
    String? bankAccount,
    String? shippingAddress,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await _userRepository.updateProfile(
        name: name,
        phone: phone,
        bankAccount: bankAccount,
        shippingAddress: shippingAddress,
      );
      state = state.copyWith(user: user, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    await SecureTokenStorage.instance.clearAccessToken();
    state = const UserState();
  }

  Future<void> becomeSeller() async {
    state = state.copyWith(isLoading: true);
    try {
      await _userRepository.becomeSeller();
      final currentUser = state.user;
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser.copyWith(isSeller: true),
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(isLoading: false, error: null);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<String?> uploadIdentityDocument(String imagePath) async {
    state = state.copyWith(isLoading: true);
    try {
      final documentId = await _userRepository.uploadIdentityDocument(
        imagePath,
      );
      final currentUser = state.user;
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser.copyWith(identityDocumentId: documentId),
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(isLoading: false, error: null);
      }
      return documentId;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return null;
    }
  }

  Future<bool> saveBankAccount(String accountNumber) async {
    state = state.copyWith(isLoading: true);
    try {
      await _userRepository.saveBankAccount(accountNumber);
      final currentUser = state.user;
      if (currentUser != null) {
        state = state.copyWith(
          user: currentUser.copyWith(bankAccount: accountNumber),
          isLoading: false,
          error: null,
        );
      } else {
        state = state.copyWith(isLoading: false, error: null);
      }
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(userProvider).user;
});

final isLoggedInProvider = Provider<bool>((ref) {
  return ref.watch(userProvider).user != null;
});

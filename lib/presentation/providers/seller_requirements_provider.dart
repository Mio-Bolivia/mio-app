import 'package:flutter_riverpod/flutter_riverpod.dart';

class SellerRequirementsState {
  final bool identityVerified;
  final bool bankAccountVerified;

  const SellerRequirementsState({
    this.identityVerified = false,
    this.bankAccountVerified = false,
  });

  bool get allCompleted => identityVerified && bankAccountVerified;

  SellerRequirementsState copyWith({
    bool? identityVerified,
    bool? bankAccountVerified,
  }) {
    return SellerRequirementsState(
      identityVerified: identityVerified ?? this.identityVerified,
      bankAccountVerified: bankAccountVerified ?? this.bankAccountVerified,
    );
  }
}

class SellerRequirementsNotifier
    extends StateNotifier<SellerRequirementsState> {
  SellerRequirementsNotifier() : super(const SellerRequirementsState());

  void setIdentityVerified(bool value) {
    state = state.copyWith(identityVerified: value);
  }

  void setBankAccountVerified(bool value) {
    state = state.copyWith(bankAccountVerified: value);
  }

  void toggleIdentity() {
    state = state.copyWith(identityVerified: !state.identityVerified);
  }

  void toggleBankAccount() {
    state = state.copyWith(bankAccountVerified: !state.bankAccountVerified);
  }
}

final sellerRequirementsProvider =
    StateNotifierProvider<SellerRequirementsNotifier, SellerRequirementsState>((
      ref,
    ) {
      return SellerRequirementsNotifier();
    });

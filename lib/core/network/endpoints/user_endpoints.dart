import '../api_endpoints.dart';

class UserEndpoints extends ApiEndpoints {
  static const myProfile = '/user/profile';
  static const updateProfile = '/user/profile/update';
  static const avatar = '/user/avatar';
  static const changeAvatar = '/user/avatar/change';
  static const myAddresses = '/user/addresses';
  static const addAddress = '/user/addresses/add';
  static const updateAddress = '/user/addresses/{id}/update';
  static const deleteAddress = '/user/addresses/{id}/delete';
  static const paymentMethods = '/user/payments';
  static const addPaymentMethod = '/user/payments/add';
  static const notifications = '/user/notifications';
  static const settings = '/user/settings';
  static const bankAccount = '/user/bank-account';
  static const identityDocument = '/user/identity-document';
  static const becomeSeller = '/user/become-seller';
}

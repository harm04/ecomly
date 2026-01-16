import 'package:ecomly/models/user_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class UserProvider extends StateNotifier<UserModel?> {
  UserProvider()
    : super(
        UserModel(
          id: '',
          fullName: '',
          email: '',
          password: '',
          city: '',
          state: '',
          locality: '',
          postalCode: '',
          phone: '',
          token: '',
          isAdmin: false,
          isVendor: false,
        ),
      );
  UserModel? get user => state;
  void setUser(String userJson) {
    state = UserModel.fromJson(userJson);
  }

  void signOut() {
    state = null;
  }

//   void recreateUserState({
//     required String locality,
//     required String city,
//     required String state,
//     required String postalCode,
//     required String phone,
//   }) {
//     if (this.state != null) {
//       this.state = UserModel(
//         id: this.state!.id,
//         fullName: this.state!.fullName,
//         email: this.state!.email,
//         password: this.state!.password,
//         city: city,
//         state: state,
//         locality: locality,
//         postalCode: postalCode,
//         phone: phone,
//         token: this.state!.token,
//         isAdmin: this.state!.isAdmin,
//         isVendor: this.state!.isVendor,
//       );
//     }
//   }
}

final userProvider = StateNotifierProvider<UserProvider, UserModel?>(
  (ref) => UserProvider(),
);

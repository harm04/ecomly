import 'package:ecomly/vendor/models/vendor_model.dart';
import 'package:flutter_riverpod/legacy.dart';

class VendorProvider extends StateNotifier<VendorModel?> {
  VendorProvider()
    : super(
        VendorModel(
          id: '',
          vendorFullName: '',
          vendorUserId: '',
          vendorEmail: '',
          city: '',
          state: '',
          locality: '',
          postalCode: '',
          phone: '',
          shopName: '',
     
        ),
      );
  VendorModel? get vendor => state;
  void setVendor(String vendorJson) {
    state = VendorModel.fromJson(vendorJson);
  }

  void signOut() {
    state = null;
  }
}

final vendorProvider = StateNotifierProvider<VendorProvider, VendorModel?>(
  (ref) => VendorProvider(),
);

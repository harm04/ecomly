import 'package:dotted_border/dotted_border.dart';
import 'package:ecomly/common_controllers/banner_controller.dart';
import 'package:ecomly/models/upload_banner_model.dart';
import 'package:ecomly/common/constants.dart';
import 'package:ecomly/common/pallete.dart';
import 'package:ecomly/common/pick_image.dart';
import 'package:ecomly/services/manage_http_response.dart';
import 'package:flutter/material.dart';

class AdminUploadBannerScreen extends StatefulWidget {
  static const String routeName = '/upload-banner';
  const AdminUploadBannerScreen({super.key});

  @override
  State<AdminUploadBannerScreen> createState() =>
      _AdminUploadBannerScreenState();
}

class _AdminUploadBannerScreenState extends State<AdminUploadBannerScreen> {
  bool isLoading = false;
  BannerController _bannerController = BannerController();
  dynamic bannerImage;
  late Future<List<BannerModel>> banners;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerImage = res.files.first.bytes;
      });
    }
  }

  void uploadCategoryImages() async {
    setState(() {
      isLoading = true;
    });
    await _bannerController.uploadBannerImage(
      bannerImage: bannerImage,
      context: context,
    );
    setState(() {
      isLoading = false;
      bannerImage = null;
      // Refresh the banners list after upload
      banners = _bannerController.fetchBanners();
    });
  }

  @override
  void initState() {
    super.initState();
    banners = _bannerController.fetchBanners();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        //banner image upload
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: DottedBorder(
                            options: RoundedRectDottedBorderOptions(
                              radius: const Radius.circular(10),
                              color: Pallete.greyColor,
                              strokeCap: StrokeCap.round,
                              dashPattern: const [10, 4],
                            ),
                            child: Container(
                              height: 170,
                              width: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: bannerImage != null
                                  ? Image.memory(
                                      bannerImage!,
                                      fit: BoxFit.cover,
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          Constants.photo,
                                          height: 30,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Upload Banner Image',
                                          style: TextStyle(
                                            color: Pallete.greyColor,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,

                          child: GestureDetector(
                            onTap: () {
                              if (bannerImage != null) {
                                uploadCategoryImages();
                              } else {
                                showsnackbar(
                                  context,
                                  'Please provide all required fields.',
                                );
                              }
                            },
                            child: Container(
                              height: 45,
                              width: double.infinity,

                              decoration: BoxDecoration(
                                color: Color.fromRGBO(142, 108, 239, 1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  'Upload Banner',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Divider(),
                    SizedBox(height: 20),

                    // Banners section
                    FutureBuilder<List<BannerModel>>(
                      future: banners,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Text(
                                'Error: ${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(50.0),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.image_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No Banners Found',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          // Calculate height for GridView
                          int itemCount = snapshot.data!.length;
                          int crossAxisCount = 3;
                          int rowCount = (itemCount / crossAxisCount).ceil();
                          double itemHeight =
                              (MediaQuery.of(context).size.width - 56) /
                              crossAxisCount *
                              (9 / 16); // 16:9 aspect ratio
                          double gridHeight =
                              (rowCount * itemHeight) +
                              ((rowCount - 1) * 10); // Add spacing

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Uploaded Banners (${snapshot.data!.length})',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              SizedBox(
                                height: gridHeight,
                                child: GridView.builder(
                                  physics:
                                      NeverScrollableScrollPhysics(), // Disable grid scrolling
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10,
                                        childAspectRatio:
                                            16 / 9, // Banner ratio
                                      ),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final banner = snapshot.data![index];
                                    return Card(
                                      elevation: 4,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Stack(
                                          children: [
                                            Image.network(
                                              banner.image,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: double.infinity,
                                              loadingBuilder:
                                                  (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Container(
                                                      color: Colors.grey[200],
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      ),
                                                    );
                                                  },
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      color: Colors.grey[300],
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                          Text(
                                                            'Load failed',
                                                            style: TextStyle(
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                            ),
                                            // Delete button
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Add delete functionality
                                                  // _bannerController.deleteBanner(banner.id);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.red
                                                        .withOpacity(0.8),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

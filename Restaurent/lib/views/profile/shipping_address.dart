import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:restaurent/common/app_style.dart';
import 'package:restaurent/common/back_ground_container.dart';
import 'package:restaurent/common/custom_button.dart';
import 'package:restaurent/common/reusable_text.dart';
import 'package:restaurent/constants/constants.dart';
import 'package:restaurent/controller/user_location_controller.dart';
import 'package:http/http.dart' as http;
import 'package:restaurent/models/address_model.dart';
import 'package:restaurent/views/auth/widget/email_textfield.dart';
import 'package:restaurent/views/profile/addresses_page.dart';

class ShippingAddress extends StatefulWidget {
  const ShippingAddress({super.key});

  @override
  State<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends State<ShippingAddress> {
  late final PageController _pageController = PageController(initialPage: 0);
  LatLng? _selectedPosition;
  GoogleMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  final TextEditingController _instructions = TextEditingController();

  List<dynamic> _placeList = [];
  List<dynamic> _selectedPlace = [];

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&key=$googleApiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      }
    } else {
      setState(() {
        _placeList = [];
      });
    }
  }

  void _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final location = json.decode(response.body);
      final lat = location['result']['geometry']['location']['lat'] as double;
      final lng = location['result']['geometry']['location']['lng'] as double;

      final address = location['result']['formatted_address'];

      String postalCode = "";

      final addressComponents = location['result']['address_components'];
      for (var component in addressComponents) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      setState(() {
        _selectedPosition = LatLng(lat, lng);
        _searchController.text = address;
        _postalCode.text = postalCode;
        moveToSelectedPosition();
        _placeList = [];
      });
    }
  }

  void moveToSelectedPosition() {
    if (_selectedPosition != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: _selectedPosition!, zoom: 15)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(UserLocationController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Shipping Address'),
        leading: Obx(
              () =>
              Padding(
                padding: EdgeInsets.only(right: 0.w),
                child: locationController.tabIndex == 0
                    ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    AntDesign.closecircleo,
                    color: kRed,
                  ),
                )
                    : IconButton(
                    onPressed: () {
                      locationController.setTabIndex = 0;
                      _pageController.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    },
                    icon: const Icon(
                      AntDesign.leftcircleo,
                      color: kDark,
                    )),
              ),
        ),
        actions: [
          Obx(() =>
          locationController.tabIndex == 1
              ? const SizedBox.shrink()
              : Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: IconButton(
                onPressed: () {
                  locationController.setTabIndex = 1;
                  _pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn);
                },
                icon: const Icon(
                  AntDesign.rightcircleo,
                  color: kDark,
                )),
          ))
        ],
      ),
      body: SizedBox(
        height: MediaQuery
            .of(context)
            .size
            .height,
        width: MediaQuery
            .of(context)
            .size
            .width,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: false,
          onPageChanged: (index) {
            _pageController.jumpToPage(index);
          },
          children: [
            Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target:
                    _selectedPosition ?? const LatLng(37.4219983, -122.084),
                    zoom: 15,
                  ),
                  markers: _selectedPosition == null
                      ? Set.of([
                    Marker(
                      markerId: const MarkerId('Your Location'),
                      position: LatLng(37.4219983, -122.084),
                      draggable: true,
                      onDragEnd: (LatLng position) {
                        locationController.getUserAddress(position);
                        setState(() {
                          _selectedPosition = position;
                        });
                      },
                    )
                  ])
                      : Set.of([
                    Marker(
                        markerId: const MarkerId('Your Location'),
                        position: _selectedPosition!,
                        draggable: true,
                        onDragEnd: (LatLng position) {
                          locationController.getUserAddress(position);
                          setState(() {
                            _selectedPosition = position;
                          });
                        })
                  ]),
                ),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      color: kOffWhite,
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: const InputDecoration(
                          hintText: 'Search location',
                        ),
                      ),
                    ),
                    _placeList.isEmpty
                        ? const SizedBox.shrink()
                        : Expanded(
                        child: ListView(
                            children:
                            List.generate(_placeList.length, (index) {
                              return Container(
                                color: Colors.white,
                                child: ListTile(
                                  visualDensity: VisualDensity.compact,
                                  title: Text(
                                    _placeList[index]['description'],
                                  ),
                                  onTap: () {
                                    _getPlaceDetails(
                                        _placeList[index]['place_id']);
                                    _selectedPlace.add(_placeList[index]);
                                  },
                                ),
                              );
                            })))
                  ],
                ),
              ],
            ),
            BackGroundContainer(
              color: kOffWhite,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  EmailTextField(
                    controller: _searchController,
                    hintText: "Address",
                    prefixIcon: Icon(Ionicons.location_sharp),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  EmailTextField(
                    controller: _postalCode,
                    hintText: "Postal Code",
                    prefixIcon: Icon(Ionicons.location_sharp),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  EmailTextField(
                    controller: _instructions,
                    hintText: "Delivery Instructions",
                    prefixIcon: Icon(Ionicons.add_circle),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(text: "Set address as default",
                            style: appStyle(12, kDark, FontWeight.w600)),

                        Obx(() =>
                            CupertinoSwitch(
                                thumbColor: kSecondary,
                                trackColor: kPrimary,
                                value: locationController.isDefault
                                , onChanged: (value) {
                              locationController.setIsDefault = value;
                            }))

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  CustomButton(
                      onTap: () {
                        final address = AddressModel(
                          addressLine1: _searchController.text,
                          postalCode: _postalCode.text,
                          addressModelDefault: locationController.isDefault, // Change as per your requirement
                          deliveryInstructions: _instructions.text,
                          latitude: _selectedPosition?.latitude ?? 0.0,
                          longitude: _selectedPosition?.longitude ?? 0.0,
                        );

                        // Convert address to JSON string
                        final addressJson = addressModelToJson(address);

                        // Print JSON string (You can use it as per your requirement)
                        print(addressJson);

                        // Navigate to AddressesPage or perform other actions
                        locationController.addAddress(addressJson);
                      },
                    text: 'Continue',
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                    onTap: () {
                      Get.back();
                    },
                    text: 'Cancel',
                    btnColor: kPrimary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
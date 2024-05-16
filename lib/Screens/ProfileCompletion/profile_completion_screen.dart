import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:legalassistance/Packages/packages.dart';

class ProfileCompletionScreen extends StatefulWidget {
  String userID;

  ProfileCompletionScreen({
    super.key,
    required this.userID,
  });
  @override
  _ProfileCompletionScreenState createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  TextEditingController cityController = TextEditingController();
  TextEditingController cnicNumberController = TextEditingController();
  TextEditingController lawyerIdController = TextEditingController();
  TextEditingController lawyerCategoryController = TextEditingController();
  TextEditingController experienceController = TextEditingController();

  TextEditingController bioController = TextEditingController();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> licenseImages = [];

  // data required for lawyer + layman
  // step 1
  String city = '';
  String? profilePic;

  // step 2
  String cnicNumber = '';
  String? cnicPicture;
  // step 3
  String lawyerId = '';
  String? lawyerIdPicture;
  final ImagePicker picker = ImagePicker();
  bool uploading = false;

  String userRole = '';

  bool? profileCompleted;
  bool profilePicFromFirebase = false;
  bool cnicPicFromFirebase = false;
  bool lawyerPicFromFirebase = false;
  int level = 0;
  int originalLevel = 0;

  bool three_seconds = true;
  fetchUserData() async {
    var currentUser = FirebaseAuth.instance.currentUser!;
    var firestore = FirebaseFirestore.instance;
    DocumentSnapshot userSnapshot =
        await firestore.collection('users').doc(currentUser.uid).get();
    setState(() {
      userRole = userSnapshot['role'];

      profileCompleted = userSnapshot['profileCompleted'];
      level = userSnapshot['level'];
      originalLevel = userSnapshot['level'];
      if (userRole == 'layman' && profileCompleted!) {
        cityController.text = userSnapshot['city'];
        profilePic = userSnapshot['picture'];
        lawyerCategoryController.text = categories[0];
        profilePicFromFirebase = true;
      } else if (level == 1) {
        city = userSnapshot['city'];

        cityController.text = userSnapshot['city'];
        profilePic = userSnapshot['picture'];
        profilePicFromFirebase = true;
        lawyerCategoryController.text = categories[0];
      } else if (level == 2 && profileCompleted == false) {
        city = userSnapshot['city'];

        cityController.text = userSnapshot['city'];
        profilePic = userSnapshot['picture'];
        cnicNumberController.text = userSnapshot['cnicNumber'];
        cnicPicture = userSnapshot['cnicPicture'];
        bioController.text = userSnapshot['bio'];
        lawyerCategoryController.text = categories[0];
        cnicPicFromFirebase = true;
        profilePicFromFirebase = true;
      } else if (level == 2 && profileCompleted == true) {
        city = userSnapshot['city'];
        cityController.text = userSnapshot['city'];
        profilePic = userSnapshot['picture'];
        cnicNumberController.text = userSnapshot['cnicNumber'];
        cnicPicture = userSnapshot['cnicPicture'];
        lawyerIdController.text = userSnapshot['lawyerId'];
        lawyerIdPicture = userSnapshot['lawyerIdPicture'];
        lawyerCategoryController.text = userSnapshot['category'];
        bioController.text = userSnapshot['bio'];
        experienceController.text = userSnapshot['experience'];
        profilePicFromFirebase = true;
        cnicPicFromFirebase = true;
        lawyerPicFromFirebase = true;
      } else {
        lawyerCategoryController.text = categories[0];
      }
    });

    print(
        '${userSnapshot['firstname']},${userSnapshot['lastname']},${userSnapshot['role']},${userSnapshot['phoneNumber']},${userSnapshot['profileCompleted']},${userSnapshot['level']},${userSnapshot['city']}, profile pic :${userSnapshot['picture']}');
    print(
        'level is $level profilePicFromFirebase: $profilePicFromFirebase cnicPicFromFirebase $cnicPicFromFirebase lawyerPicFromFirebase $lawyerPicFromFirebase');
  }

  List<String> categories = [
    'Property Transfer',
    'Income Tax',
    'Criminals',
    'International Lawyer',
    'Business Lawyer',
    'Family Lawyer',
    'Immigration Lawyer',
    'Employment Lawyer',
  ];

  @override
  void initState() {
    fetchUserData();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        three_seconds = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: showAppBar(
            context, LocalesData.updateProfileScreenAppBar.getString(context)),
        body: StreamBuilder(
            stream: streamFunction.getUserDataStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final userData = snapshot.data;
                if (userData!['block']) {
                  return Scaffold(
                    body: Center(
                      child:
                          Text(LocalesData.blockStatement.getString(context)),
                    ),
                  );
                } else {
                  return three_seconds
                      ? Center(
                          child: CircularProgressIndicator(
                            color: appBarColor,
                          ),
                        )
                      : Stack(
                          children: [
                            Stepper(
                              currentStep: level,
                              onStepContinue: () {
                                // Handle logic when the user clicks the continue button
                                if (level == 0) {
                                  // Validate and save level 1 data
                                  if (cityController.text.isNotEmpty &&
                                      profilePic!.isNotEmpty) {
                                    // Save data and move to the next step
                                    uploadStep1();
                                  } else {
                                    message(
                                        context,
                                        LocalesData.profileScreenWarning1
                                            .getString(context));
                                  }
                                } else if (level == 1) {
                                  if (cnicNumberController.text.isNotEmpty &&
                                      cnicPicture != null &&
                                      bioController.text.isNotEmpty) {
                                    uploadStep2();
                                  } else if (cnicNumberController.text.length >
                                      13) {
                                    message(
                                        context,
                                        LocalesData.profileScreenWarning2
                                            .getString(context));
                                  } else if (bioController.text.isEmpty) {
                                    message(
                                        context,
                                        LocalesData.profileScreenWarning3
                                            .getString(context));
                                  } else {
                                    message(
                                        context,
                                        LocalesData.profileScreenWarning4
                                            .getString(context));
                                  }
                                } else if (level == 2) {
                                  if (lawyerIdController.text.isNotEmpty &&
                                      lawyerCategoryController
                                          .text.isNotEmpty &&
                                      lawyerIdPicture != null &&
                                      experienceController.text.isNotEmpty) {
                                    uploadStep3();
                                  } else {
                                    message(
                                        context,
                                        LocalesData.profileScreenWarning5
                                            .getString(context));
                                  }
                                }

                                setState(() {});
                              },
                              steps: [
                                Step(
                                  title: Text(
                                      LocalesData.level1.getString(context)),
                                  content: Column(
                                    children: [
                                      textField(
                                          cityController,
                                          TextInputType.emailAddress,
                                          LocalesData.cityHintText
                                              .getString(context)),
                                      profilePic != null
                                          ? Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: appBarColor!)),
                                              height: 200,
                                              width: double.infinity,
                                              child: Stack(
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  profilePicFromFirebase
                                                      ? Image.network(
                                                          profilePic!)
                                                      : Image.file(
                                                          File(profilePic!)),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        profilePic = null;
                                                        profilePicFromFirebase =
                                                            false;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : picturePicker(
                                              LocalesData.profilePicture
                                                  .getString(context),
                                              'profilePic')
                                    ],
                                  ),
                                ),
                                Step(
                                  title: Text(
                                    LocalesData.level2.getString(context),
                                  ),
                                  content: Column(
                                    children: [
                                      originalLevel >= 1
                                          ? Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        '${LocalesData.cityHintText.getString(context)} : ${cityController.text}'),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          level -= 1;
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 100,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration: BoxDecoration(
                                                            color: appBarColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 4.0,
                                                                  horizontal:
                                                                      5),
                                                          child: Text(
                                                            LocalesData
                                                                .editLevel1
                                                                .getString(
                                                                    context),
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                profilePic != null
                                                    ? Image.network(
                                                        profilePic!,
                                                        height: 200,
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            )
                                          : const SizedBox(),
                                      textField(
                                          cnicNumberController,
                                          TextInputType.number,
                                          LocalesData.cnicNumberHint
                                              .getString(context)),
                                      cnicPicture != null
                                          ? Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: appBarColor!)),
                                              height: 200,
                                              width: double.infinity,
                                              child: Stack(
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  cnicPicFromFirebase
                                                      ? Image.network(
                                                          cnicPicture!)
                                                      : Image.file(
                                                          File(cnicPicture!),
                                                        ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        cnicPicture = null;
                                                        cnicPicFromFirebase =
                                                            false;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : picturePicker(
                                              LocalesData.cnicPicture
                                                  .getString(context),
                                              'cnicPicture'),
                                      bioTextField(
                                          bioController,
                                          LocalesData.bioHint
                                              .getString(context)),
                                    ],
                                  ),
                                ),
                                Step(
                                  title: Text(
                                      LocalesData.level3.getString(context)),
                                  content: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${LocalesData.cityHintText.getString(context)} : ${cityController.text}'),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    level = 0;
                                                  });
                                                },
                                                child: Container(
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: appBarColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.0,
                                                            horizontal: 5),
                                                    child: Text(
                                                      LocalesData.editLevel1
                                                          .getString(context),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          profilePic != null
                                              ? Image.network(profilePic!,
                                                  height: 100)
                                              : SizedBox(),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${LocalesData.cnicNumberHint.getString(context)} : \n${cnicNumberController.text}'),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    level = 1;
                                                  });
                                                },
                                                child: Container(
                                                  width: 100,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: appBarColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4.0,
                                                            horizontal: 5),
                                                    child: Text(
                                                      LocalesData.editLevel2
                                                          .getString(context),
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                              '${LocalesData.bioHint.getString(context)}: \n${bioController.text}'),
                                          cnicPicture != null
                                              ? Image.network(
                                                  cnicPicture!,
                                                  height: 100,
                                                )
                                              : SizedBox(),
                                        ],
                                      ),
                                      textField(
                                          lawyerIdController,
                                          TextInputType.emailAddress,
                                          LocalesData.lawyerIdNumberHintText
                                              .getString(context)),
                                      dropdownField(
                                          lawyerCategoryController,
                                          LocalesData.selectCategory
                                              .getString(context),
                                          categories),
                                      lawyerIdPicture != null
                                          ? Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: appBarColor!)),
                                              height: 200,
                                              width: double.infinity,
                                              child: Stack(
                                                alignment: Alignment.topLeft,
                                                children: [
                                                  lawyerPicFromFirebase
                                                      ? Image.network(
                                                          lawyerIdPicture!)
                                                      : Image.file(
                                                          File(
                                                              lawyerIdPicture!),
                                                        ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        lawyerIdPicture = null;
                                                      });
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        color: Colors.black,
                                                      ),
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : picturePicker(
                                              LocalesData
                                                  .lawyerIdPictureHintText
                                                  .getString(context),
                                              'lawyerIdPicture'),
                                      textField(
                                          experienceController,
                                          TextInputType.number,
                                          LocalesData.lawyerExperienceHintText
                                              .getString(context))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (uploading)
                              Center(
                                child: CircularProgressIndicator(
                                  color: appBarColor,
                                ),
                              )
                            else
                              const SizedBox()
                          ],
                        );
                }
              }
            }));
  }

  textField(TextEditingController controller, TextInputType? keyboardType,
      String? hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF64379F)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
        ),
      ),
    );
  }

  bioTextField(TextEditingController controller, String? hintText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        maxLength: 100,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF64379F)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
        ),
      ),
    );
  }

  Widget dropdownField(
      TextEditingController controller, String hintText, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: DropdownButtonFormField<String>(
        value: controller.text,
        onChanged: (newValue) {
          setState(() {
            controller.text = newValue!;
            debugPrint(controller.text);
          });
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF64379F)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFF27104E),
            ),
          ),
        ),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  picturePicker(String title, String? variable) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: appBarColor!)),
      width: double.infinity,
      child: Column(
        children: [
          Text(
            title,
            style: textFieldStyle,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    print(variable);
                    variable == 'cnicPicture'
                        ? _pickCnicImage(ImageSource.gallery)
                        : variable == 'profilePic'
                            ? _pickProfileImage(ImageSource.gallery)
                            : _pickLawyerIdImage(ImageSource.gallery);
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 5),
                      child: Text(
                        LocalesData.gallery.getString(context),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print(variable);
                    variable == 'cnicPicture'
                        ? _pickCnicImage(ImageSource.camera)
                        : variable == 'profilePic'
                            ? _pickProfileImage(ImageSource.camera)
                            : _pickLawyerIdImage(ImageSource.camera);
                  },
                  child: Container(
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: appBarColor,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 5),
                      child: Text(
                        LocalesData.camera.getString(context),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _pickProfileImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        profilePic = image.path;
      });
      print(profilePic);
    }
  }

  Future<void> _pickLawyerIdImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        lawyerIdPicture = image.path;
      });
      print(lawyerIdPicture);
    }
  }

  Future<void> _pickCnicImage(ImageSource source) async {
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        cnicPicture = image.path;
      });
      print(cnicPicture);
    }
  }

  uploadStep1() async {
    setState(() {
      uploading = true;
    });
    try {
      String imagePath =
          'profile_images/${widget.userID}/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = _storage.ref().child(imagePath);

      if (!profilePicFromFirebase) {
        await storageReference.putFile(File(profilePic!));

        String downloadURL = await storageReference.getDownloadURL();
        userRole == 'layman'
            ? await _firestore.collection('users').doc(widget.userID).update({
                'city': cityController.text,
                'picture': downloadURL,
                'level': 0,
                'profileCompleted': true,
              })
            : await _firestore.collection('users').doc(widget.userID).update({
                'city': cityController.text,
                'picture': downloadURL,
                'level': originalLevel > level ? originalLevel : 1
              });
      } else {
        userRole == 'layman'
            ? await _firestore.collection('users').doc(widget.userID).update({
                'city': cityController.text,
                'picture': profilePic,
                'level': 0,
                'profileCompleted': true,
              })
            : await _firestore.collection('users').doc(widget.userID).update({
                'city': cityController.text,
                'picture': profilePic,
                'level': originalLevel > level ? originalLevel : 1,
              });
      }

      setState(() {
        uploading = false;
      });
      fetchUserData();
      userRole == 'layman'
          ? message(
              context, LocalesData.profileScreenMessage1.getString(context))
          : message(
              context, LocalesData.profileScreenMessage2.getString(context));
      userRole == 'lawyer' ? level += 1 : null;
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        uploading = false;
      });
    }
  }

  uploadStep2() async {
    setState(() {
      uploading = true;
    });
    try {
      String imagePath =
          'cnicPictures/${widget.userID}/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = _storage.ref().child(imagePath);

      if (!cnicPicFromFirebase) {
        await storageReference.putFile(File(cnicPicture!));
        String downloadURL = await storageReference.getDownloadURL();
        await _firestore.collection('users').doc(widget.userID).update({
          'cnicNumber': cnicNumberController.text,
          'cnicPicture': downloadURL,
          'level': originalLevel > level ? originalLevel : 2,
          'bio': bioController.text
        });
      } else {
        await _firestore.collection('users').doc(widget.userID).update({
          'cnicNumber': cnicNumberController.text,
          'cnicPicture': cnicPicture,
          'level': originalLevel > level ? originalLevel : 2,
          'bio': bioController.text
        });
      }
      setState(() {
        uploading = false;
      });
      fetchUserData();
      message(context, LocalesData.profileScreenMessage2.getString(context));
      level += 1;
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        uploading = false;
      });
    }
  }

  uploadStep3() async {
    setState(() {
      uploading = true;
    });
    try {
      String imagePath =
          'lawyerIdPictures/${widget.userID}/${DateTime.now().millisecondsSinceEpoch}.png';
      Reference storageReference = _storage.ref().child(imagePath);

      if (!lawyerPicFromFirebase) {
        await storageReference.putFile(File(lawyerIdPicture!));
        String downloadURL = await storageReference.getDownloadURL();

        await _firestore.collection('users').doc(widget.userID).update({
          'category': lawyerCategoryController.text,
          'lawyerId': lawyerIdController.text,
          'lawyerIdPicture': downloadURL,
          'experience': '${experienceController.text} year',
          'profileCompleted': true,
        });
      } else {
        await storageReference.putString(lawyerIdPicture!);

        await _firestore.collection('users').doc(widget.userID).update({
          'category': lawyerCategoryController.text,
          'lawyerId': lawyerIdController.text,
          'lawyerIdPicture': lawyerIdPicture,
          'experience': '${experienceController.text} year',
          'profileCompleted': true,
        });
      }
      setState(() {
        uploading = false;
      });
      fetchUserData();
      message(context, LocalesData.profileScreenMessage3.getString(context));
      Navigator.pop(context);
    } catch (e) {
      debugPrint(e.toString());
      setState(() {
        uploading = false;
      });
    }
  }
}

import 'package:Investigator/core/resources/app_colors.dart';
import 'package:Investigator/presentation/all_cameras/screens/text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:Investigator/core/utils/responsive.dart';
import 'package:Investigator/core/widgets/badge_builder.dart';
import 'package:Investigator/core/widgets/sizedbox.dart';
import 'package:Investigator/presentation/all_cameras/bloc/camera_bloc.dart';
import 'package:Investigator/presentation/standard_layout/screens/standard_layout.dart';
import 'package:routemaster/routemaster.dart';

class AllCamerasScreen extends StatelessWidget {
  const AllCamerasScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> _contactList = [
      {
        'name': 'John Doe',
        'profession': 'UI Designer',
      },
      {
        'name': 'Samantha William',
        'profession': 'UI Designer',
      },
      {
        'name': 'Tony Soap',
        'profession': 'Web Developer',
      },
      {
        'name': 'Karen Hope',
        'profession': 'Android Developer',
      },
      {
        'name': 'Tatang Wijaya',
        'profession': 'QA Engineer',
      },
      {
        'name': 'Johnny Ahmad',
        'profession': 'Product Owner',
      },
      {
        'name': 'Jordan Nico',
        'profession': 'Product Manager',
      },
      {
        'name': 'Budi Prabowo',
        'profession': 'ios Developer',
      },
      {
        'name': 'Nadila Adja',
        'profession': 'Graphic Designer',
      },
      {
        'name': 'Azizi Azazel',
        'profession': 'UX Engineer',
      },
      {
        'name': 'Angelina Crispy',
        'profession': 'Software Engineering',
      },
      {
        'name': 'Ipi Antoinette',
        'profession': 'VP Product',
      },
    ];

    return
    
    
     StandardLayoutScreen(
      body: BlocProvider(
        create: (context) => CameraBloc()
          ..add(const CameraMainDataEvent())
          ..add(const CameraInitializeDate()),
        child: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            return
            
            
             Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              
               SingleChildScrollView(
                child: Column(
                  children: [
                    FxBox.h24,
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("All Employees".tr(),
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),

                          //Add Employee Button
                          MaterialButton(
                            height: 50,
                            minWidth: 210,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            color: Color.fromARGB(255, 143, 188, 211),
                            onPressed: () {
                              // Show dialog to fill in employee data
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Add Employee"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Name'),
                                        ),
                                        FxBox.h24,
                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Phone Number'),
                                        ),
                                        FxBox.h24,

                                        TextFormField(
                                          decoration: InputDecoration(
                                              labelText: 'Email'),
                                        ),
                                        // Add more fields as needed
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          // Add logic to save employee data
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text(
                              "Add Employee",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    FxBox.h24,
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _contactList.length,
                        gridDelegate: Responsive.isMobile(context)
                            ? const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                crossAxisSpacing: 45,
                                mainAxisSpacing: 45,
                                mainAxisExtent: 350,
                              )
                            : Responsive.isTablet(context)
                                ? const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 45,
                                    mainAxisSpacing: 45,
                                    mainAxisExtent: 350,
                                  )
                                : MediaQuery.of(context).size.width < 1500
                                    ? SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        crossAxisSpacing: 45,
                                        mainAxisSpacing: 45,
                                        mainAxisExtent: 350,
                                      )
                                    : SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                            MediaQuery.of(context).size.width *
                                                0.24,
                                        crossAxisSpacing: 45,
                                        mainAxisSpacing: 45,
                                        mainAxisExtent: 350,
                                      ),
                        itemBuilder: (context, index) {
                          return _contactUi(
                              name: _contactList[index]['name'],
                              profession: _contactList[index]['profession']);
                        },
                      ),
                    ),

                    // Wrap(
                    //     children: _responsiveCardList(
                    //         context: context, cameras: dummyEmployees)),
                  ],
                ),
              ),
          
          
          
          
          
            );
          },
        ),
      ),
    );
 
 
 
 
  }

  Widget _contactUi({
    required String name,
    required String profession,
  }) {
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
      decoration: BoxDecoration(
          color:
              // context.isDarkMode ?
              Color.fromARGB(255, 143, 188, 211),
          // : ColorConst.white,
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(
                    'assets/images/logo.png',
                    // Images.profileImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_horiz, color: Colors.black),
                onSelected: (String choice) {
                  if (choice == 'Edit') {
                    // Handle edit action
                  } else if (choice == 'Delete') {
                    // Handle delete action
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'Edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'Delete',
                    child: Text('Delete'),
                  ),
                ],
              )
            ],
          ),
          FxBox.h24,
          ConstText.lightText(
            text: name,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
          FxBox.h8,
          ConstText.lightText(
            text: profession,
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          FxBox.h24,
          _iconWithText(
              icon: Icon(Icons.badge_outlined), text: 'Peterdraw Studio'),
          FxBox.h28,
          _iconWithText(icon: Icon(Icons.contact_phone), text: '+123 456 789'),
          FxBox.h28,
          _iconWithText(icon: Icon(Icons.email), text: 'email@mail.com'),
          // FxBox.h24,
        ],
      ),
    );
  }

  Widget _iconWithText({
    required Icon icon,
    required String text,
  }) {
    return Row(
      children: [
        icon,
        FxBox.w16,
        ConstText.lightText(
          text: text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ],
    );
  }



}

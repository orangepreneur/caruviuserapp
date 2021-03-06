import 'dart:convert';
import 'dart:developer';
import 'package:caruviuserapp/components/toasts/errorToast.dart';
import 'package:caruviuserapp/components/toasts/processing.dart';
import 'package:caruviuserapp/components/toasts/successToast.dart';
import 'package:caruviuserapp/model/CityModel.dart';
import 'package:caruviuserapp/services/auth.service.dart';
import 'package:caruviuserapp/services/city.service.dart';
import 'package:caruviuserapp/views/login.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  PageController _controller = PageController();
  late FToast fToast;
  String firstName = "",
      lastName = '',
      phoneNumber = "",
      email = "",
      businessName = "",
      businessAddress = "",
      password = "",
      verifyPassword = "";
  late CityModel city;
  List<CityModel> availableCities = [];
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _businessNameController = TextEditingController();
  TextEditingController _businessAddressController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _verifyPasswordController = TextEditingController();

  getCities() async {
    var response = await CityService().getAllCities();
    if (response.statusCode == 200) {
      var parsedData = jsonDecode(response.body).cast();
      parsedData
          .forEach((item) => availableCities.add(CityModel.fromJson(item)));
      city = availableCities[0];

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: Text(
          "Create Account",
          style: GoogleFonts.lato(
              fontWeight: FontWeight.w700, fontSize: 14.0, color: Colors.white),
        ),
        backgroundColor: Colors.teal[600],
        toolbarHeight: 50.0,
        elevation: 0.0,
      ),
      backgroundColor: Colors.white,
      body: PageView.builder(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, position) {
          switch (position) {
            case 0:
              return initialInformationWidget();
            case 1:
              return additionalInformationWidget();
            case 2:
              return setPasswordWidget();
            default:
              return initialInformationWidget();
          }
        },
        itemCount: 3, // Can be null
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    getCities();
  }

  Widget initialInformationWidget() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "1. Basic Information",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Please provide some basic information about yourself",
            style: TextStyle(color: Colors.black26, fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value) {
              this.firstName = value;
            },
            controller: _firstNameController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal[50]!,
                        style: BorderStyle.solid,
                        width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 1.0)),
                helperText: "Eg: Arjun",
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: "First Name"),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value) {
              this.lastName = value;
            },
            controller: _lastNameController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal[50]!,
                        style: BorderStyle.solid,
                        width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 1.0)),
                helperText: "Eg: Bhatt",
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: "Last Name"),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            keyboardType: TextInputType.phone,
            controller: _phoneNumberController,
            onChanged: (value) {
              this.phoneNumber = value;
            },
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal[50]!,
                        style: BorderStyle.solid,
                        width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 1.0)),
                helperText:
                    "Phone Number will be used to login to Caruvi services",
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: "Phone Number",
                prefixText: "+91-"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.teal[900],
                ),
                onPressed: () {
                  if (firstName.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter First Name",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (lastName.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter Last Name",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (phoneNumber.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter Phone Number",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (phoneNumber.length < 10) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter 10-digit Phone Number",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  goNextPage();
                },
                child: Text("Next")),
          ),
        ),
      ]),
    );
  }

  Widget additionalInformationWidget() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "2. Additional Information",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Please enter your residential address",
            style: TextStyle(color: Colors.black26, fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(bottom: 10.0),
          child: TextField(
            maxLines: 8,
            onChanged: (value) {
              this.businessAddress = value;
            },
            minLines: 1,
            controller: _businessAddressController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal[50]!,
                        style: BorderStyle.solid,
                        width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 1.0)),
                helperText: "Eg: Main market, Kotdwar",
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: "Address"),
          ),
        ),
        Container(
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(
                    color: Colors.teal[50]!,
                    style: BorderStyle.solid,
                    width: 1.0)),
            child: SizedBox(
              width: double.infinity,
              child: DropdownButton<CityModel>(
                value: city,
                isExpanded: true,
                elevation: 4,
                underline: Container(),
                onChanged: (CityModel? newValue) {
                  setState(() {
                    if (newValue != null) {
                      this.city = newValue;
                    }
                  });
                },
                hint: Text("Select City"),
                items: availableCities
                    .map<DropdownMenuItem<CityModel>>((CityModel city) {
                  return DropdownMenuItem<CityModel>(
                    value: city,
                    child: Text(city.name + " (" + city.state + ")"),
                  );
                }).toList(),
              ),
            )),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value) {
              this.businessName = value;
            },
            controller: _businessNameController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal[50]!,
                        style: BorderStyle.solid,
                        width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 1.0)),
                helperText: "Eg: Caruvi Agro",
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: "Business Name (Optional)"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.teal[900],
                ),
                onPressed: () {
                  if (firstName.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter First Name",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (lastName.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter Last Name",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (phoneNumber.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter Phone Number",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (phoneNumber.length < 10) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please enter 10-digit Phone Number",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  goNextPage();
                },
                child: Text("Next")),
          ),
        ),
        TextButton(
            onPressed: () {
              goPrevPage();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit Basic Information",
                  style: TextStyle(color: Colors.teal[900]),
                )
              ],
            )),
      ]),
    );
  }

  Widget setPasswordWidget() {
    return SingleChildScrollView(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 20.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "3. Set Password",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            "Please set password for your account",
            style: TextStyle(color: Colors.black26, fontSize: 12.0),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            onChanged: (value) {
              this.password = value;
            },
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal[50]!,
                        style: BorderStyle.solid,
                        width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 1.0)),
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: "Enter Password"),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(bottom: 10.0),
          child: TextField(
            onChanged: (value) {
              this.verifyPassword = value;
            },
            obscureText: true,
            controller: _verifyPasswordController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.teal[50]!,
                        style: BorderStyle.solid,
                        width: 1.0)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 1.0)),
                helperStyle: TextStyle(fontSize: 10.0),
                labelText: "Confirm Password"),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: Colors.teal[900],
                ),
                onPressed: () async {
                  if (password.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Please set a password",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (verifyPassword.isEmpty) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "please confirm the password",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  if (password != verifyPassword) {
                    fToast.showToast(
                      child: ErrorToast(
                        message: "Password didn't match. Please check",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 3),
                    );
                    return;
                  }
                  fToast.showToast(
                    child: ProcessingToast(
                      message: "Creating Account. Please wait",
                    ),
                    gravity: ToastGravity.CENTER,
                    toastDuration: Duration(seconds: 3),
                  );
                  var userCreation = await createUser(
                    firstName: firstName,
                    lastName: lastName,
                    phoneNumber: phoneNumber,
                    businessName: businessName,
                    businessAddress: businessAddress,
                    password: password,
                    city: city.id,
                  );
                  if (userCreation == true) {
                    fToast.showToast(
                      child: SuccessToast(
                        message: "Account Created",
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 5),
                    );
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  }
                  if (userCreation is Response) {
                    var response =
                        jsonDecode(userCreation.body).cast<String, dynamic>();
                    fToast.showToast(
                      child: ErrorToast(
                        message: response['message'],
                      ),
                      gravity: ToastGravity.CENTER,
                      toastDuration: Duration(seconds: 5),
                    );
                  }
                },
                child: Text("Create Account")),
          ),
        ),
        TextButton(
            onPressed: () {
              goPrevPage();
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Edit Business Details",
                  style: TextStyle(color: Colors.teal[900]),
                )
              ],
            )),
      ]),
    );
  }

  goNextPage() {
    _controller.nextPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }

  goPrevPage() {
    _controller.previousPage(
        duration: Duration(milliseconds: 300), curve: Curves.linear);
  }
}

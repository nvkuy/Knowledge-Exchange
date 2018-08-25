import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'colors.dart';

final formKey = new GlobalKey<FormState>();
enum FormType {
  login,
  register,
  verify,
  profile,
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  FirebaseUser user;
  FormType formState = FormType.login;
  String mEmailLogin, mPasswordLogin, mConfirmPass, mEmailRegister, mPasswordRegister;
  bool isChecked = false;
  final int _min_length_password = 6;
  final String
    _saveAccText = 'Lưu tài khoản',
    _checkBoxKey = 'isChecked',
    _mEmailKey = 'email_key',
    _mPassKey = 'password_key',
    _register_success = 'Tạo tài khoản thành công',
    _register_error = 'Lỗi tạo tài khoản',
    _login_success = 'Đăng nhập thành công',
    _login_error = 'Lỗi đăng nhập',
    _submit_button = 'Hoàn thành',
    _next_button = 'Tiếp tục',
    _home_page_path = 'home_page',
    _verify_err = 'Lỗi xác thực',
    _verify_success = 'Xác thực thành công',
    _invalid_confirm_pass = 'Xác nhận mật khẩu không khớp với mật khẩu ban đầu',
    _resend_verify_email = 'Chưa nhận được link? Gửi lại link xác thực',
    _back_to_login = 'Đăng nhập bằng tài khoản khác',
    _goto_register = 'Đã có tài khoản? Đăng nhập',
    _register_button = 'Tạo tài khoản',
    _confirm_pass_label = 'Xác nhận mật khẩu',
    _verify_email_form = 'Kiểm tra email để xác thực. Link xác thực email đã được gửi tới địa chỉ email: ',
    _goto_login = 'Chưa có tài khoản? Tạo mới',
    _login_button = 'Đăng nhập',
    _short_length_password = 'Mật khẩu phải có độ dài trên 6 kí tự',
    _null_password = 'Mật khẩu không thể bỏ trống',
    _password_label = 'Mật khẩu',
    _email_label = 'Email',
    _invalid_email_pattern = 'Email không đúng định dạng',
    _null_email = 'Email không thể bỏ trống',
    _logo_path = 'assets/images/logo.png',
    _email_pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  bool validateAndSave() {
    final mFormState = formKey.currentState;
    mFormState.save();
    return mFormState.validate();
  }

  Future<void> showSavedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mEmailLogin = prefs.getString(_mEmailKey);
    mPasswordLogin = prefs.getString(_mPassKey);
    isChecked = prefs.getBool(_checkBoxKey) != null ? prefs.getBool(_checkBoxKey) : false;
          
    print(mEmailLogin + ' ' + mPasswordLogin + ' ' + isChecked.toString());
  } 

  Future<bool> saveOrDelSavedUser(bool isChecked) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString(_mEmailKey, mEmailLogin);
      prefs.setString(_mPassKey, mPasswordLogin);
      prefs.setBool(_checkBoxKey, isChecked);
    } else {
      prefs.remove(_mEmailKey);
      prefs.remove(_mPassKey);
      prefs.remove(_checkBoxKey);
    }
    return prefs.commit();
  }

  // Future<FormType> setDefaultFormType() async {
  //   Future<FirebaseUser> user = FirebaseAuth.instance.currentUser();
  //   user.then((FirebaseUser user) {
  //     if (user.isEmailVerified) {
  //       if (user.displayName != null) {
  //         gotoHomePage();
  //         return FormType.login;
  //       }
  //       return FormType.profile;
  //     }
  //     return FormType.verify;
  //   }, onError: (e) {
  //     return FormType.login;
  //   });
  //   return FormType.login;
  // }

  void validateAndLogin() async {
    if (validateAndSave()) {
      try {
        user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: mEmailLogin, password: mPasswordLogin)
            .whenComplete(() => print('sign in completed!'));
        await saveOrDelSavedUser(isChecked);
        showSnackbar(_login_success);
        if (user.isEmailVerified) {
          if (user.displayName != null) {
            gotoHomePage();
          } else {
            gotoProfile();
          }
        } else {
          gotoVerify(user);
        }
      } catch (e) {
        //lỗi đăng nhập
        print(e);
        showSnackbar(_login_error);
      }
    }
  }

  void showSnackbar(String text) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: Text(text, textAlign: TextAlign.center, textScaleFactor: 1.2),
          ));
  }

  void validateAndRegister() async {
    if (validateAndSave()) {
      try {
        user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mEmailRegister, password: mPasswordRegister)
            .whenComplete(() => print('sign up completed!'));
        showSnackbar(_register_success);
        gotoVerify(user);
      } catch (e) {
        //lỗi tạo tài khoản
        print(e);
        showSnackbar(_register_error);
      }
    }
  }

  void gotoHomePage() {
    formState = FormType.login;
    Navigation.navigateTo(context, _home_page_path);
  }

  void sendVerify(FirebaseUser user) {
    user.sendEmailVerification().whenComplete(() => print('send email verification completed!'));
  }

  void gotoVerify(FirebaseUser user) {
    // resetForm();
    sendVerify(user);
    setState(() {
          formState = FormType.verify;
        });
  }

  void resetForm() {
    setState(() {
      mEmailLogin = null;
      mPasswordLogin = null;
      mEmailRegister = null;
      mPasswordRegister = null;
      mConfirmPass = null;
      isChecked = false;
    });
    formKey.currentState.reset();
  }

  Future<void> validEmailOrNext(FirebaseUser user) async {
    await user
      .reload()
      .catchError((e) {
        print(e);
        showSnackbar(_verify_err);
      })
      .whenComplete(() async {
        user = await FirebaseAuth.instance.currentUser();
        if (user.isEmailVerified) {
          showSnackbar(_verify_success);
          gotoProfile();
        } else {
          showSnackbar(_verify_err);
        }
    });
  }

  void gotoProfile() {
    resetForm();
    setState(() {
          formState = FormType.profile;
        });
  }

  Future gotoLogin() async {
    resetForm();
    setState(() {
          formState = FormType.login;
        });
    await showSavedUser();
    await FirebaseAuth.instance.signOut();
  }

  void gotoRegister() {
    resetForm();
    setState(() {
          formState = FormType.register;
        });
  }

  bool isEmail(String email) {
    RegExp regExp = new RegExp(_email_pattern);
    return regExp.hasMatch(email);
  }

  String buttonText() {
    switch (formState) {
      case FormType.login:
        return _login_button;
        break;
      case FormType.register:
        return _register_button;
        break;
      case FormType.verify:
        return _back_to_login;
        break;
      default:
        return null;
    }
  }

  String navigateButtonText() {
    switch (formState) {
      case FormType.login:
        return _goto_login;
        break;
      case FormType.register:
        return _goto_register;
        break;
      case FormType.verify:
        return _resend_verify_email;
        break;
      case FormType.profile:
        return _back_to_login;
        break;
    }
    return null;
  }

  List<Widget> buildEmailVerifyForm() {
    if (formState == FormType.verify) {
      return [
        new Text(_verify_email_form + user.email, style: TextStyle(fontSize: 27.5), textAlign: TextAlign.center,),
        SizedBox(height: 100.0),
      ];
    }
    return [SizedBox(height: 0.1)];
  }

  List<Widget> buildLogoAndEmailForm() {
    if (formState == FormType.login || formState == FormType.register) {
      return [
        // logo
        new Image.asset(_logo_path),
        // email form
        SizedBox(height: 100.0),
        new TextFormField(
          initialValue: formState == FormType.register ? null : mEmailLogin,
          onSaved: ((value) {
            if (formState == FormType.login) {
              mEmailLogin = value.trim();
            } else {
              mEmailRegister = value.trim();
            }
          }),
          validator: (value) {
            if (value.isEmpty) {
              return _null_email;
            } else if (!isEmail(value)) {
              return _invalid_email_pattern;
            }
            return null;
          },
          keyboardType: TextInputType.emailAddress,
          decoration: new InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            labelText: _email_label,
            contentPadding: EdgeInsets.all(15.0),
          ),
        ),
      ];
    }
    return [SizedBox(height: 0.1)];
  }

  List<Widget> buildPasswordForm() {
    if (formState == FormType.login || formState == FormType.register) {
      return [
        SizedBox(
              height: 15.0,
            ),
        new TextFormField(
          initialValue: formState == FormType.register ? null : mPasswordLogin,
          onSaved: ((value) {
            if (formState == FormType.login) {
              mPasswordLogin = value.trim();
            } else {
              mPasswordRegister = value.trim();
            }
          }),
          validator: (value) {
            if (value.isEmpty) {
              return _null_password;
            } else if (value.length < _min_length_password) {
              return _short_length_password;
            }
            return null;
          },
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            labelText: _password_label,
            contentPadding: EdgeInsets.all(15.0),
          ),
        ),
      ];
    }
    return [SizedBox(height: 0.1)];
  }

  List<Widget> buildSaveAccountCheckBox() {
    if (formState == FormType.login) {
      return [
        SizedBox(
              height: 8.0,
            ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Text(_saveAccText, textAlign: TextAlign.right,),
            new Checkbox(value: isChecked, activeColor: mPrimaryColor, tristate: false, onChanged: ((bool value) {
              setState(() {
                isChecked = value;
              });
            }),),
            new SizedBox(width: 20.0,),
          ],
        )
      ];
    }
    return [SizedBox(height: 0.1)];
  }

  List<Widget> buildConfirmPasswordForm() {
    if (formState == FormType.register) {
      return [
        SizedBox(
              height: 15.0,
            ),
        new TextFormField(
          onSaved: (value) => mConfirmPass = value.trim(),
          validator: (value) {
            if (value.isEmpty) {
              return _null_password;
            } else if (value.length < _min_length_password) {
              return _short_length_password;
            } else if (value != mPasswordRegister) {
              return _invalid_confirm_pass;
            }
            return null;
          },
          obscureText: true,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13.0),
            ),
            labelText: _confirm_pass_label,
            contentPadding: EdgeInsets.all(15.0),
          ),
        ),
      ];
    }
    return [SizedBox(height: 0.1)];
  }

  List<Widget> buildSignInOrUpOrVerifyButton() {
    if (formState != FormType.profile) {
      return [
        SizedBox(
                height: formState == FormType.login ? 8.0 : 25.0,
              ),
        new RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          child: Text(buttonText(), style: TextStyle(fontSize: 16.0,),),
          textColor: mSecondaryLightColor,
          color: mPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            switch (formState) {
              case FormType.login:
                validateAndLogin();
                break;
              case FormType.register:
                validateAndRegister();
                break;
              case FormType.verify:
                gotoLogin();
                break;
            }
          },
        ),
      ];
    }
    return [SizedBox(height: 0.1,)];
  }

  List<Widget> buildNextOrSubmitButton() {
    if (formState == FormType.verify || formState == FormType.profile) {
      return [
        SizedBox(height: 10.0,),
        new RaisedButton(
          padding: EdgeInsets.symmetric(vertical: 14.0),
          child: Text(formState == FormType.verify ? _next_button : _submit_button),
          textColor: formState == FormType.verify ? mPrimaryColor : mSecondaryLightColor,
          color: formState == FormType.verify ? mSecondaryColor : mPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
          onPressed: () {
            switch (formState) {
              case FormType.verify:
                validEmailOrNext(user);
                break;
              case FormType.profile:
                gotoHomePage();
                break;
            }
          },
        ),
      ];
    }
    return [SizedBox(height: 0.1,)];
  }

  List<Widget> buildChargeFormButton() {
    return [
      SizedBox(height: 10.0,),
      new FlatButton(
      child: Text(
        navigateButtonText(),
        textAlign: TextAlign.center,
      ),
      onPressed: () {
          switch (formState) {
            case FormType.login:
              gotoRegister();
              break;
            case FormType.register:
              gotoLogin();
              break;
            case FormType.verify:
              sendVerify(user);
              break;
            case FormType.profile:
              gotoLogin();
              break;
          }
        },
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: new Form(
        key: formKey,
        child: new ListView(
          padding:
              EdgeInsets.only(top: 100.0, left: 20.0, right: 20.0, bottom: 30.0),
          children: 
            buildEmailVerifyForm() + 
            buildLogoAndEmailForm() + 
            buildPasswordForm() + 
            buildSaveAccountCheckBox() +
            buildConfirmPasswordForm() + 
            buildSignInOrUpOrVerifyButton() + 
            buildNextOrSubmitButton() +
            buildChargeFormButton()
        ),
    ));
  }
}

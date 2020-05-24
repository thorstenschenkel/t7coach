import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:t7coach/screens/authenticate/register_form.dart';
import 'package:t7coach/screens/authenticate/sign_in_form.dart';
import 'package:t7coach/shared/widgets/coach_bar.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  bool _isLoading = false;

  ScrollController _scrollController = ScrollController();

  void toogleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  void scrollToTop() {
    _scrollController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeInSine);
  }

  void loading(bool isLoading) {
    setState(() {
      _isLoading = isLoading;
    });
  }

  Widget getForm() {
    if (showSignIn) {
      return SignInForm(
          toogleView: toogleView, scrollToTop: scrollToTop, loading: loading);
    } else {
      return RegisterForm(
          toogleView: toogleView, scrollToTop: scrollToTop, loading: loading);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget form = getForm();

    return Scaffold(
        body: LoadingOverlay(
      isLoading: _isLoading,
      opacity: 0.1,
      progressIndicator: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(Theme.of(context).colorScheme.secondary),
      ),
      color: Theme.of(context).colorScheme.secondary,
      child: Stack(children: <Widget>[
        CoachBar(210.0, bgImage: true),
        SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
                padding: EdgeInsets.only(top: 125),
                child: Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.all(8.0),
                    child: form)))
      ]),
    ));
  }
}

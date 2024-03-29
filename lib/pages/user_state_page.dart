// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Project imports:
import 'package:nf_kicks/pages/check_email_page.dart';
import 'package:nf_kicks/pages/loading_page.dart';
import 'package:nf_kicks/services/authentication/authentication_api.dart';
import 'package:nf_kicks/services/database/database.dart';
import 'package:nf_kicks/services/database/database_api.dart';
import 'package:nf_kicks/widgets/constants.dart';
import 'package:nf_kicks/widgets/show_alert_dialog.dart';
import 'landing_page.dart';
import 'login_registration/login_registration_page.dart';

class UserStatePage extends StatelessWidget {
  final bool connectionStatus;
  final bool jailbreakOrRootStatus;

  const UserStatePage({
    @required this.connectionStatus,
    @required this.jailbreakOrRootStatus,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationApi>(context, listen: false);

    return StreamBuilder<User>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return LoginAndRegistrationPage();
        }
        if (snapshot.connectionState == ConnectionState.active) {
          final User user = snapshot.data;
          if (user == null) {
            return LoginAndRegistrationPage();
          } else if (user.emailVerified == false) {
            try {
              user.sendEmailVerification();
              return CheckEmail();
            } on FirebaseAuthException catch (e) {
              showAlertDialog(context,
                  title: 'An error has occurred',
                  description: e.message,
                  actionBtn: 'OK');
            }
          }

          return Provider<DatabaseApi>(
            create: (_) => Database(uid: user.uid),
            child: LandingPage(
              authenticationApi: auth,
              uid: user.uid,
              connectionStatus: connectionStatus,
              jailbreakOrRootStatus: jailbreakOrRootStatus,
            ),
          );
        }
        return Loading(
          loadingWidget: kLoadingLogo,
        );
      },
    );
  }
}

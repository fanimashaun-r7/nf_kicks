// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:nf_kicks/widgets/vertical_text_logo.dart';

const kPrimaryColor = Colors.deepOrangeAccent;
const kSecondaryColor = Colors.white;
const kNfkicksBlack = Colors.black;
const kNfkicksRed = Colors.red;

final kLoadingLogo = verticalTextWithLogo();

final kLogoError = verticalTextWithLogo(
  text:
      "Check wifi connection, something went wrong (please ensure you do not have a rooted device)...",
);

final kLogoCheckEmail = verticalTextWithLogo(
  text: "Check your email and login to continue!",
);

const kLoadingNoLogo = Center(
  child: CircularProgressIndicator(
    backgroundColor: kSecondaryColor,
    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
  ),
);

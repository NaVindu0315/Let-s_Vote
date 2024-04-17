import 'package:flutter/material.dart';
import 'package:lets_vote/Colors/colors.dart';

const kSendButtonTextStyle = TextStyle(
  color: AppColors.backgroundcolor,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);

const ktextfielddecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const Color kWhatsAppGreen = Colors.purple;

const Color kReceiverChatBubbleColor = Color(0xFFCE93D8);
const Color kSenderChatBubbleColor = kWhatsAppGreen;

const kbottomcontainerheight = 80.0;
const kcardcolor = Color(0xFF101E33);
const kbottomcontainercolor = Color(0xFFEB1555);
const kinnactivecolor = Color(0xFF111328);
const kactivecolor = Color(0xFFEB1555);
const kbackgroundicon = Color(0xFF4C4F5E);

const knumbertext = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.w900,
);

const klabeltext = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.bold,
  color: Color(0xFF8D8E98),
);

const klargeButon = TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
);

const ktitletextstyle = TextStyle(
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
);

const kresultext = TextStyle(
  color: Color(0xFF24D876),
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
);

const kbmitext = TextStyle(
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
);

const kbodytext = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
);

import 'package:flutter/material.dart';

class ConfirmButtonStyle {
  static final ButtonStyle elevated = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 84, 142, 174),
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    side: const BorderSide(color: Color.fromARGB(255, 8, 85, 129)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  );
}

class CancelButtonStyle {
  static final ButtonStyle elevated = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 129, 8, 10),
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    side: const BorderSide(color: Color.fromARGB(1, 191, 79, 79)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  );
}

class RestButtonStyle {
  static final ButtonStyle elevated = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 85, 85, 85),
    foregroundColor: const Color.fromARGB(255, 255, 255, 255),
    side: const BorderSide(color: Color.fromARGB(1, 191, 79, 79)),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
  );
}

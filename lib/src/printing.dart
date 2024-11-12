// ignore_for_file: avoid_print

void infoPrint(String message) {
  colorPrint(message, fgColor: XtermColorType.skyBlue1);
}

void warningPrint(String message) {
  colorPrint(message, fgColor: XtermColorType.yellow);
}

void successPrint(String message) {
  colorPrint(message, fgColor: XtermColorType.lime);
}

void errorPrint(String message) {
  colorPrint(message, fgColor: XtermColorType.red);
}

void colorPrint(String message,
    {XtermColorType? fgColor, XtermColorType? bgColor}) {
  const ansiEsc = "\x1B[";

  var fgColorCode = fgColor != null ? '${ansiEsc}38;5;${fgColor.code}m' : '';
  var bgColorCode = bgColor != null ? '${ansiEsc}48;5;${bgColor.code}m' : '';

  try {
    print("$fgColorCode$bgColorCode$message${ansiEsc}0m");
  } catch (e) {
    print(message);
  }
}

//* https://www.ditig.com/publications/256-colors-cheat-sheet
//* XtermColorType
enum XtermColorType {
  black(0),
  maroon(1),
  green(2),
  olive(3),
  navy(4),
  purple(5),
  teal(6),
  sliver(7),
  grey(8),
  red(9),
  lime(10),
  yellow(11),
  blue(12),
  fuchsia(13),
  agua(14),
  white(15),

  skyBlue1(117),
  ;

  const XtermColorType(this.code);
  final int code;
}

import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {@required this.onPressed,
      @required this.text,
      this.type,
      this.isLoading});

  final GestureTapCallback onPressed;
  final String text;
  final String type;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
          fixedSize:
              MaterialStateProperty.all(const Size.fromWidth(double.infinity)),
          backgroundColor: type == 'secondary'
              ? MaterialStateProperty.all(Theme.of(context)
                  .primaryColor
                  .withOpacity(onPressed == null ? 0.5 : 1))
              : type == 'orange'
                  ? MaterialStateProperty.all(Colors.orange[900]
                      .withOpacity(onPressed == null ? 0.5 : 1))
                  : type == 'danger'
                      ? MaterialStateProperty.all(
                          Colors.red.withOpacity(onPressed == null ? 0.5 : 1))
                      : type == 'black'
                          ? MaterialStateProperty.all(Colors.black
                              .withOpacity(onPressed == null ? 0.5 : 1))
                          : type == 'dim'
                              ? MaterialStateProperty.all(
                                  const Color.fromRGBO(71, 50, 175, 0.1))
                              : type == 'white'
                                  ? MaterialStateProperty.all(Colors.white)
                                  : MaterialStateProperty.all(
                                      Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
              // side: BorderSide(color: Colors.red),
            ),
          ),
        ),
        // disabledColor: Colors.deepPurple[200],
        // color: type != 'secondary' ? Color.fromRGBO(33, 158, 73, 1) : Colors.green,
        // minWidth: double.infinity,
        child: isLoading == true
            ? Container(
                margin: const EdgeInsets.all(10.0),
                width: 12,
                height: 12,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white,
                  ),
                ),
              )
            : SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style: type == 'white'
                        ? const TextStyle(color: Colors.black, fontSize: 14)
                        : type == 'dim'
                            ? TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14)
                            : const TextStyle(
                                color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
        onPressed: onPressed,
      ),
    );
  }
}

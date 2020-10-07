import 'package:flutter/material.dart';
import 'package:gps_tracking_system/color.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          height: 800,
          child:CustomPaint(
            painter: BackgroundSignUp(),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Column(
                    children: <Widget>[
                      _getHeader(),
                      _getTextFields(),
                      _getSignUp(context),
                      _getBottomRow(context),
                    ],
                  ),
                ),
                _getBackBtn(context)
              ],
            ),
          )
        )
      ),
    );
  }
}

_getBackBtn(context) {
  return Positioned(
    top: 35,
    left: 25,

    child: IconButton(
      icon : Icon(Icons.arrow_back_ios),
      color:primaryLightColor,
      onPressed: (){
        Navigator.of(context).pushReplacementNamed("/login");
      },
    ),
  );
}

_getBottomRow(context) {
  return Expanded(
    flex: 1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      ],
    ),
  );
}

_getSignUp(context) {
  return Expanded(
    flex: 1,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          'Sign up',
          style: TextStyle(
              color:primaryLightColor,
              fontSize: 25,
              fontWeight: FontWeight.w500
          ),
        ),
        CircleAvatar(
          backgroundColor: Colors.grey.shade800,
          radius: 40,
          child: IconButton(
            icon: Icon(Icons.arrow_forward),
            color:primaryLightColor,
            onPressed: (){
              //Navigator.of(context).pushReplacementNamed("/");
            },
          ),
        )
      ],
    ),
  );
}

_getTextFields() {

  return Expanded(
    flex: 8,
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:primaryLightColor)),
                labelText: 'First Name', labelStyle: TextStyle(color:primaryLightColor)),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:primaryLightColor)),
                labelText: 'Last Name', labelStyle: TextStyle(color:primaryLightColor)),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:primaryLightColor)),
              labelText: 'E-mail', labelStyle: TextStyle(color:primaryLightColor),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:primaryLightColor)),
              labelText: 'Telephone', labelStyle: TextStyle(color:primaryLightColor),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:primaryLightColor)),
              labelText: 'Password', labelStyle: TextStyle(color:primaryLightColor),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TextFormField(
            decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:primaryLightColor)),
              labelText: 'Password Confirm', labelStyle: TextStyle(color:primaryLightColor),
            ),
          ),
          SizedBox(
            height: 25,
          ),
        ],
      ),
    ),
  );
}

_getHeader() {
  return Expanded(
    flex: 3,
    child: Container(
      alignment: Alignment.bottomLeft,
      child: Text(
        'Create\nAccount',
        style: TextStyle(color:primaryLightColor, fontSize: 40),
      ),
    ),
  );
}

class BackgroundSignUp extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var sw = size.width;
    var sh = size.height;
    var paint = Paint();

    Path mainBackground = Path();
    mainBackground.addRect(Rect.fromLTRB(0, 0, sw, sh));
    paint.color = primaryLightColor;
    canvas.drawPath(mainBackground, paint);

    Path blueWave = Path();
    blueWave.lineTo(sw, 0);
    blueWave.lineTo(sw, sh * 0.65);
    blueWave.cubicTo(sw * 0.8, sh * 0.8, sw * 0.55, sh * 0.8, sw * 0.45, sh);
    blueWave.lineTo(0, sh);
    blueWave.close();
    paint.color = primaryColor;
    canvas.drawPath(blueWave, paint);

    Path greyWave = Path();
    greyWave.lineTo(sw, 0);
    greyWave.lineTo(sw, sh * 0.3);
    greyWave.cubicTo(sw * 0.65, sh * 0.45, sw * 0.25, sh * 0.35, 0, sh * 0.5);
    greyWave.close();
    paint.color = Colors.blueGrey[900];
    canvas.drawPath(greyWave, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}



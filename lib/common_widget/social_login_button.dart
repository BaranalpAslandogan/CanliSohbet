import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {

  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final double genislik;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLoginButton(
      {Key key,
        @required this.buttonText,
        this.buttonColor:Colors.teal,
        this.textColor:Colors.black54,
        this.radius:15,
        this.yukseklik:45,
        this.buttonIcon,
        this.genislik,
        @required this.onPressed
      }
      ) :
        assert(buttonText!=null,onPressed!=null),
        super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: genislik,
        height: yukseklik,
        child: RaisedButton(
          color: buttonColor,
          onPressed: onPressed,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              buttonIcon != null ? buttonIcon : Container(),
              Text(buttonText,style:TextStyle(color: textColor),),
              Opacity != null ? Opacity(child: buttonIcon,opacity: 0,) : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

//Eski Yöntem

/*
buttonIcon != null ? buttonIcon : Container(),
Text(buttonText,style:TextStyle(color: textColor),),
Opacity != null ? Opacity(child: buttonIcon,opacity: 0,) : Container(),
 */

//Spreads, Collection if, Collection for
/*
if(buttonIcon != null) ...[
buttonIcon,
Text(buttonText,style:TextStyle(color: textColor),),
Opacity(child: buttonIcon,opacity: 0,)
],
if(buttonIcon==null) ...[
Container(),
Text(buttonText,style:TextStyle(color: textColor),),
Container(),
]
*/
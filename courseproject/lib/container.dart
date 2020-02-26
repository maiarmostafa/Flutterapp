import 'package:flutter/material.dart';

const KTextstyle = TextStyle(color: Colors.white, fontSize: 20,);

class Flatbuttonss extends StatelessWidget {
  const Flatbuttonss({this.label, this.style, this.onpressed});
  final String label;
  final FontWeight style;
  final Function onpressed;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Color(0xFF2372A3),
      onPressed: onpressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 15, fontWeight: style),
      ),
    );
  }
}

class Circeleavatarimage extends StatelessWidget {
  const Circeleavatarimage({this.radius});
  final double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: AssetImage('images/clipeducation.png'),
      backgroundColor: Colors.transparent,
    );
  }
}

class Rowbuttons extends StatelessWidget {
  const Rowbuttons({this.colorr, this.textt, this.onpressed});
  final Color colorr;
  final Widget textt;
  final Function onpressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9.0)),
              color: colorr,
              onPressed: onpressed,
              child: textt,
            ),
          ),
        )
      ],
    );
  }
}


class Textfieldrepeted extends StatelessWidget {
  const Textfieldrepeted({this.onchanged, this.inputDecoration});
  final Function onchanged;
  final String inputDecoration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: TextFormField(
        onChanged: onchanged,
        validator:(value){
          if(value.isEmpty)
          {
            return 'Please enter data';
          }
        },
        decoration: InputDecoration(hintText: inputDecoration,filled: true),
      ),
    );
  }
}

class Titlerepeted extends StatelessWidget {
  const Titlerepeted({this.onpressed, this.icondata, this.textdata});
  final Function onpressed;
  final IconData icondata;
  final String textdata;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        textdata,
        style: TextStyle(fontSize: 20, color: Color(0xFF5F92A5),fontFamily: 'Source Sans Pro'),
      ),
      trailing: IconButton(
        onPressed: onpressed,
        icon: Icon(icondata),
        color: Color(0xFF5F92A5),
      ),
    );
  }
}

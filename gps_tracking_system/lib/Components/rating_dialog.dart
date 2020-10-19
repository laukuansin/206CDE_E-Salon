import 'package:flutter/material.dart';

class Rating{
  String feedback;
  int ratingStar;

  Rating(this.feedback, this.ratingStar);

}


class RatingDialog extends StatefulWidget {
  final String title;
  final String description;
  final String submitButton;
  final String alternativeButton;
  final String positiveComment;
  final String negativeComment;
  final Widget icon;
  final Color accentColor;
  final ValueSetter<Rating> onSubmitPressed;
  final VoidCallback onAlternativePressed;

  RatingDialog(
      {@required this.icon,
        @required this.title,
        @required this.description,
        @required this.onSubmitPressed,
        @required this.submitButton,
        this.accentColor = Colors.blue,
        this.alternativeButton = "",
        this.positiveComment = "",
        this.negativeComment = "",
        this.onAlternativePressed});

  @override
  _RatingDialogState createState() => new _RatingDialogState();
}



class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;
  String _feedback="";
  List<Widget> _buildStarRatingButtons() {
    List<Widget> buttons = [];

    for (int rateValue = 1; rateValue <= 5; rateValue++) {
      final starRatingButton = IconButton(
          icon: Icon(_rating >= rateValue ? Icons.star : Icons.star_border,
              color: widget.accentColor, size: 35),
          onPressed: () {
            setState(() {
              _rating = rateValue;
            });
          });
      buttons.add(starRatingButton);
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    final String commentText =
    _rating >= 4 ? widget.positiveComment : widget.negativeComment;
    // final Color commentColor = _rating >= 4 ? Colors.green[600] : Colors.red;

    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.icon,
          const SizedBox(height: 15),
          Text(widget.title,
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            widget.description,
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStarRatingButtons(),
          ),
          Visibility(
            visible: _rating > 0,
            child: Column(
              children: <Widget>[
                const Divider(),
                TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,//Normal textInputField will be displayed
                  maxLines: 5,
                  decoration: new InputDecoration(
                      hintText: "Enter your feedback here"
                  ),
                  onChanged: (String text){
                    _feedback=text;
                  },
                ),
                FlatButton(
                  child: Text(
                    widget.submitButton,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.accentColor,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    Rating rating=Rating(_feedback, _rating);
                    widget.onSubmitPressed(rating);
                  },
                ),
                Visibility(
                  visible: commentText.isNotEmpty,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Text(
                        commentText,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible:
                  _rating <= 3 && widget.alternativeButton.isNotEmpty,
                  child: FlatButton(
                    child: Text(
                      widget.alternativeButton,
                      style: TextStyle(
                          color: widget.accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onAlternativePressed();
                    },
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}

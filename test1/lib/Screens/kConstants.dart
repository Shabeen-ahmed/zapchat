import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class kButton extends StatelessWidget {
  kButton({required this.onpress,required this.buttonLabel});

  Function() onpress;
  String buttonLabel;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child:Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20)
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
            child: Text(
              '$buttonLabel',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70,),
            ),
          ),
        ),
      ),
      onTap: onpress,
    );
  }
}

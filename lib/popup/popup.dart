
 








import 'dart:io';

import 'package:flutter/material.dart';

Future<void> dialogBuilder(BuildContext context,
    String titel,
    String Content,
    String positivebuttontext,
    bool isnegative,
    negativebuttontext
      ) {







   //String titel = "Basic dialog title hii";

   //String Content ="Everything is OK";
   //String positivebuttontext ="Login";
  
   //String negativebuttontext ="Close";
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(titel),
          content:  Text(Content),
          
          actions: <Widget>[


            

           
                  if (isnegative)


                  TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child:  Text(negativebuttontext),
              onPressed: () {
                Navigator.of(context).pop(false);
                 
              },
            ),



                 


                  
                  
                   
             
            
            
            
            
            
             TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child:  Text(positivebuttontext),
              onPressed: () {
              //  exit(0); 

                //SystemChannels.platform.invokeMethod('SystemNavigator.pop');
               Navigator.of(context).pop(true);
              },
            ),
            
            
            
            
            
            
          ],
        );
      },
    );
  }




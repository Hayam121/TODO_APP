// ignore: file_names
import 'package:flutter/material.dart';
import '../layouts/home_layout.dart';
class Taskitem extends StatefulWidget {
      final Map model;
       const Taskitem (this. model, {super.key} );

  @override
  State<Taskitem> createState() => _TaskitemState();
}

class _TaskitemState extends State<Taskitem> {
        bool valu=false;

  @override
  Widget build(BuildContext context) {
    
    return  Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 40,
            child: Text("3.43"),
          ),
           const SizedBox(width: 20,),
           const Expanded(
             child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:MainAxisAlignment.start,
               children: [
                //${widget.model}['title']
                 Text("Task Title",style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold),),
                  Text("23-4-5",style: TextStyle(color: Colors.grey),),
                
               ],
             ),
           ),
     Checkbox(
            value: valu, 
            onChanged: (value){
               setState(() {
                 valu=value!;

             });
             //updateData();
            }
            ),
      IconButton(
       onPressed: (){
       //updateData();
      
         
      }, 
      icon: const Icon(Icons.archive_outlined,
      color: Colors.redAccent,
      )
      ),
        ],
      
      ),
    );
  }
}
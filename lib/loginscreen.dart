import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' hide LinearGradient;
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usercontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();

  Artboard? _riveArtboard;
  StateMachineController? _rivecontroller;
  SMIInput<bool>?_checking;
  SMIInput<double>?numlock1;
  SMIInput<bool>?_handup;
  SMIInput<bool>?_sucess;
  SMIInput<bool>?_fail;
@override
// Note all the  controller are predifine controller form the rive animation
  void initState() {
    // TODO: implement initState
    super.initState();
    // Here we are loading the rive animation
    rootBundle.load("assets/animation.riv").then((data)async{
      final file= RiveFile.import(data);
      // here we are creating the artboard to access the properties of rive animation
      final artboaed=file.mainArtboard;
      // here we are create the controller to control our animation
      var controller=StateMachineController.fromArtboard(artboaed, 'Login Machine');
      if(controller!=null){
        artboaed.addController(controller);
        // here we are  creating the intance of the controls that we are going to use
        _checking=controller.findInput('isChecking');
        _handup=controller.findInput('isHandsUp');
        numlock1=controller.findInput('numLook');
        _sucess=controller.findInput('trigSuccess');
        _fail=controller.findInput('trigFail');
        setState(() {
          // here we are setting our local artboard
          _riveArtboard=artboaed;
        });



        
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        padding:const  EdgeInsets.all(20),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration:const BoxDecoration(
          color:  Color(0xffd6e2ea),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           const  SizedBox(height: 50,),
            _riveArtboard==null?Container(): SizedBox(
                height: 230,
// to use this we need to install the rive dependency a
                child: Rive(artboard: _riveArtboard!,alignment: Alignment.center,)),
            Container(
              padding:const EdgeInsets.all(20),
              height: 300,
              width: double.infinity,
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20),
               color: Colors.deepPurple.withOpacity(0.5)
             ),
              child: Column(
                
                children: [

                  const    Text("Hi There!",style: TextStyle(fontSize: 16,color: Color(0xff544359),fontWeight: FontWeight.bold),),
                  const     SizedBox(height: 10,),
                  const    Text("Let's Get Started",style: TextStyle(fontSize: 20,color: Color(0xff544359),fontWeight: FontWeight.bold),),
                  const  SizedBox(height: 10,),
                  Container(
                    padding:const  EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: TextFormField(
                      controller: usercontroller,
                      onChanged: (value){
                        // here we are checking if the handup condition is true if true then we set it to false

                        if(_handup!=null){
                          _handup?.change(false);
                        }
                        if(_checking==null)return;
                        _checking?.change(true);
                        numlock1?.change(value.length*5);
                      },


                      decoration:const InputDecoration(
                        border: InputBorder.none
                      ),
                    ),
                  ),
                  const  SizedBox(height: 20,),
                  Container(
                    padding:const  EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)
                    ),
                    child: TextFormField(controller: passwordcontroller,
                    onChanged: (value){

                      // here also
                      if(_checking!=null){
                        _checking?.change(false);
                      }
                      if(_handup==null)return;
                      _handup?.change(true);
                       },

                      obscureText: true,
                      decoration:const InputDecoration(
                          border: InputBorder.none
                      ),
                    ),
                  ),
                  const  SizedBox(height: 20,),
                  GestureDetector(
                    onTap: (){
                      _handup?.change(false);
                      if(passwordcontroller.text=="123456"){
                        _sucess?.change(true);
                      }else{
                        _fail?.change(true);}
                      },
                    child: Container(
                      width: double.infinity,
                      padding:const  EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(

                              colors: [Colors.pinkAccent,
                                Colors.pinkAccent.shade100

                              ]
                          ),

                          borderRadius: BorderRadius.circular(50)
                      ),
                      alignment: Alignment.center,
                      child:const  Text("LOGIN",style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                    ),
                  ),
                ],
              ),

            )
          ],
        ),
      )
    );
  }
}

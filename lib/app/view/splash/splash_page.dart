import 'package:flutter/material.dart';
import 'package:proyecto_final_domestika/app/view/components/h1.dart';
import 'package:proyecto_final_domestika/app/view/components/shape.dart';
import 'package:url_launcher/url_launcher.dart';

import '../task_list/task_list.dart';

final Uri _url = Uri.parse('https://docs.flutter.dev/tos');

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: const [
              Shape(),
            ],
          ),
          const SizedBox(height: 79,),
          Image.asset(
            'assets/images/onboarding-image.png',
            width: 180,
            height: 168,
          ),
          const SizedBox(height: 99,),
          const H1('Lista de tareas',),
          const SizedBox(height: 21,),
          GestureDetector(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return TaskListPage();
              }));
            },
            child: const Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 32),
              child: Text(
                'La mejor forma para que no se te olvide nada es anotarlo. Guardar tus tareas y ve completando poco a poco para aumentar tu productividad',
                textAlign: TextAlign.center,
              ),
            )
          ),
          Center(
            child: Padding(
              padding: const EdgeInsetsGeometry.symmetric(vertical: 8),
              child: TextButton(
                  onPressed: _launchUrl,
                  child: Text('Mostrar términos y condiciones de Flutter.'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if(!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
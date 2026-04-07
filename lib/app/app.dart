import 'package:flutter/material.dart';
import 'package:proyecto_final_domestika/app/view/splash/splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF40B7AD);
    const textColor = Color(0xFF4A4A4A);
    const backgroundColor = Color(0xFFF5F5F5);
    return SpecialColor(
      color: Colors.redAccent,
      child: MaterialApp(
        title: 'Proyecto Domestika',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: primary),
          scaffoldBackgroundColor: backgroundColor,
          textTheme: Theme.of(context).textTheme.apply(
            fontFamily: 'Poppins',
            bodyColor: textColor,
            displayColor: textColor,
          ),
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 54),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(10),
              ),
              textStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        home: SplashPage(),
      ),
    );
  }
}

class SpecialColor extends InheritedWidget{
  const SpecialColor({
    super.key,
    required this.color,
    required super.child,
  });

  final Color color;

  static SpecialColor of(BuildContext context){
    final result = context.dependOnInheritedWidgetOfExactType<SpecialColor>();
    if(result == null) throw Exception('SpecialColor not found');
    return result;
  }

  @override
  bool updateShouldNotify(SpecialColor oldWidget) {
    return oldWidget.color != color;
  }
}
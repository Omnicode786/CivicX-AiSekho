import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/civix_widgets.dart';

class SplashScreen extends StatefulWidget { const SplashScreen({super.key}); @override State<SplashScreen> createState()=>_SplashScreenState(); }
class _SplashScreenState extends State<SplashScreen>{ @override void initState(){super.initState(); Future.delayed(const Duration(seconds:2),()=>mounted?context.go('/onboarding'):null);} @override Widget build(BuildContext context)=>GradientShell(child:Scaffold(body:Center(child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[Icon(Icons.radar,size:96,color:CivixColors.cyan).animate(onPlay:(c)=>c.repeat()).rotate(duration:3.seconds),const SizedBox(height:24),Text('CIVIX AI',style:Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight:FontWeight.w900,letterSpacing:2,color:CivixColors.cyan)),const SizedBox(height:8),const Text('Smart City Crisis Intelligence'),const SizedBox(height:36),const Text('Initializing AI Emergency Grid...',style:TextStyle(color:CivixColors.muted))]))));}

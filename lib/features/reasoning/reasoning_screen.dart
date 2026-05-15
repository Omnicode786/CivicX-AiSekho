import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/civix_widgets.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/services/firestore_service.dart';

class ReasoningScreen extends StatelessWidget{final String crisisId;const ReasoningScreen({super.key,required this.crisisId});@override Widget build(BuildContext context)=>GradientShell(child:Scaffold(appBar:AppBar(title:const Text('AI Reasoning'),backgroundColor:Colors.transparent),body:StreamBuilder<List<AgentResult>>(stream:context.read<FirestoreService>().agents(crisisId),builder:(c,s){final agents=s.data??[];return ListView(padding:const EdgeInsets.all(16),children:[...agents.map((a)=>Padding(padding:const EdgeInsets.only(bottom:12),child:GlassCard(child:ExpansionTile(iconColor:CivixColors.cyan,collapsedIconColor:CivixColors.cyan,title:Text('[${a.agentName}]',style:const TextStyle(fontWeight:FontWeight.w900)),subtitle:Text(a.summary),children:a.reasoningPoints.map((p)=>ListTile(leading:const Icon(Icons.check_circle,color:CivixColors.green),title:Text(p))).toList()))),const SizedBox(height:10),NeonButton(label:'View Emergency Simulation',icon:Icons.play_circle,onTap:()=>context.push('/simulation/$crisisId'))];}))));}

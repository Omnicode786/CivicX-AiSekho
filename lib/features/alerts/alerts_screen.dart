import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/civix_widgets.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/models.dart';
import '../../data/services/firestore_service.dart';

class AlertsScreen extends StatelessWidget{const AlertsScreen({super.key});@override Widget build(BuildContext context)=>GradientShell(child:SafeArea(child:StreamBuilder<List<AlertMessage>>(stream:context.read<FirestoreService>().alerts(),builder:(c,s){final alerts=s.data??[];return ListView(padding:const EdgeInsets.all(16),children:[Text('Realtime Alert Center',style:Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight:FontWeight.w900)),const SizedBox(height:14),Wrap(spacing:8,runSpacing:8,children:['Critical','High','Flood','Fire','Traffic','Medical'].map((e)=>StatusPill(e,CivixColors.cyan)).toList()),const SizedBox(height:16),...alerts.map((a)=>Padding(padding:const EdgeInsets.only(bottom:12),child:GlassCard(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[Row(children:[Expanded(child:Text(a.title,style:const TextStyle(fontWeight:FontWeight.w900))),StatusPill(a.language,CivixColors.purple)]),const SizedBox(height:6),Text(a.message),const SizedBox(height:10),Row(children:[StatusPill(a.severity,CivixColors.orange),const SizedBox(width:8),Text(a.location,style:const TextStyle(color:CivixColors.muted,fontSize:12))])])))]);}))));}

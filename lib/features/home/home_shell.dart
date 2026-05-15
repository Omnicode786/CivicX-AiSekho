import 'package:flutter/material.dart';
import '../home/home_dashboard.dart';
import '../map/live_map_screen.dart';
import '../report/report_screen.dart';
import '../agents/agents_screen.dart';
import '../alerts/alerts_screen.dart';
import '../../core/theme/app_theme.dart';

class HomeShell extends StatefulWidget{const HomeShell({super.key});@override State<HomeShell> createState()=>_HomeShellState();}
class _HomeShellState extends State<HomeShell>{int idx=0; final screens=const [HomeDashboard(),LiveMapScreen(),ReportScreen(),AgentsScreen(),AlertsScreen()];@override Widget build(BuildContext context)=>Scaffold(body:screens[idx],bottomNavigationBar:NavigationBar(backgroundColor:CivixColors.panel,indicatorColor:CivixColors.cyan.withOpacity(.2),selectedIndex:idx,onDestinationSelected:(v)=>setState(()=>idx=v),destinations:const [NavigationDestination(icon:Icon(Icons.dashboard),label:'Home'),NavigationDestination(icon:Icon(Icons.map),label:'Map'),NavigationDestination(icon:Icon(Icons.add_alert),label:'Report'),NavigationDestination(icon:Icon(Icons.hub),label:'Agents'),NavigationDestination(icon:Icon(Icons.notifications),label:'Alerts')]));}

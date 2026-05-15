import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/models.dart';

class FirestoreService {
  final FirebaseFirestore db;
  FirestoreService(this.db);
  Stream<List<CrisisReport>> crises()=>db.collection('crisis_reports').orderBy('reportedAt',descending:true).snapshots().map((s)=>s.docs.map(CrisisReport.fromDoc).toList());
  Stream<List<AlertMessage>> alerts()=>db.collection('alerts').orderBy('createdAt',descending:true).snapshots().map((s)=>s.docs.map(AlertMessage.fromDoc).toList());
  Stream<List<AgentResult>> agents(String crisisId)=>db.collection('crisis_reports').doc(crisisId).collection('agent_results').orderBy('timestamp').snapshots().map((s)=>s.docs.map(AgentResult.fromDoc).toList());
  Stream<List<EmergencyUnit>> units()=>db.collection('emergency_units').snapshots().map((s)=>s.docs.map(EmergencyUnit.fromDoc).toList());
  Stream<SimulationResult?> simulation(String crisisId)=>db.collection('simulation_results').doc(crisisId).snapshots().map((d)=>d.exists?SimulationResult.fromDoc(d):null);

  Future<String> submitReport(String description, String type, String locationName) async {
    final id = const Uuid().v4();
    final lower = description.toLowerCase();
    final flood = lower.contains('flood') || lower.contains('pani') || lower.contains('barish') || lower.contains('block');
    final fire = lower.contains('fire') || lower.contains('aag') || lower.contains('smoke');
    final detected = type == 'Auto Detect' ? (fire ? 'Fire Emergency' : flood ? 'Urban Flood Emergency' : 'Urban Crisis') : type;
    final severity = fire ? 'CRITICAL' : flood ? 'HIGH' : 'MEDIUM';
    final confidence = fire ? 94.0 : flood ? 92.0 : 81.0;
    final crisis = CrisisReport(id:id,title:detected,description:description,type:detected,locationName:locationName,latitude:24.9202,longitude:67.0886,severity:severity,confidence:confidence,status:'AI Analyzing',reportedAt:DateTime.now(),reportedBy:'Citizen App',affectedRadiusKm:flood?3.2:1.1,peopleAtRisk:flood?18500:4200,blockedRoads:flood?7:2);
    final batch = db.batch();
    final ref = db.collection('crisis_reports').doc(id);
    batch.set(ref, crisis.toMap());
    final agents = _agentSeed(id, detected, severity, confidence, flood);
    for (final a in agents) { batch.set(ref.collection('agent_results').doc(), a); }
    batch.set(db.collection('simulation_results').doc(id), {'beforeCongestion':87,'afterCongestion':51,'beforeEta':22,'afterEta':9,'peopleAtRisk':crisis.peopleAtRisk,'peopleAlerted':12400,'congestionReduction':41.0,'etaImprovement':28.0,'rescueCoverageImprovement':35.0});
    for (final al in _alerts(id, severity)) { batch.set(db.collection('alerts').doc(), al); }
    await batch.commit();
    return id;
  }

  List<Map<String,dynamic>> _agentSeed(String id,String detected,String severity,double confidence,bool flood)=>[
    {'agentName':'Signal Agent','status':'Completed','confidence':98,'summary':'Collected live citizen complaint, nearby reports, rainfall, and traffic slowdown signals.','reasoningPoints':['Citizen report received','37 nearby complaints found','Rainfall intensity high','Traffic slowdown detected near NIPA'], 'timestamp':Timestamp.fromDate(DateTime.now())},
    {'agentName':'Detection Agent','status':'Completed','confidence':confidence,'summary':'Detected $detected with ${confidence.toInt()}% confidence.','reasoningPoints':['Keywords matched crisis pattern','Multiple local signals support same event','Location confidence is high'], 'timestamp':Timestamp.fromDate(DateTime.now().add(const Duration(seconds:1)))},
    {'agentName':'Severity Agent','status':'Completed','confidence':89,'summary':'Classified risk as $severity with high population and road impact.','reasoningPoints':['Affected radius estimated at 3.2 km','Arterial roads impacted','Nearby schools and hospitals detected'], 'timestamp':Timestamp.fromDate(DateTime.now().add(const Duration(seconds:2)))},
    {'agentName':'Planning Agent','status':'Completed','confidence':91,'summary':'Generated traffic rerouting, rescue dispatch, KMC drainage, and public alert plan.','reasoningPoints':['Reroute from University Road','Dispatch Rescue 1122 and ambulances','Notify Traffic Police East','Prepare evacuation support'], 'timestamp':Timestamp.fromDate(DateTime.now().add(const Duration(seconds:3)))},
    {'agentName':'Dispatch Agent','status':'Completed','confidence':86,'summary':'Simulated ambulance, rescue, police and drainage unit deployment.','reasoningPoints':['Optimized route from nearest response unit','ETA improved from 22 to 9 minutes','Road closure markers created'], 'timestamp':Timestamp.fromDate(DateTime.now().add(const Duration(seconds:4)))},
    {'agentName':'Alert Agent','status':'Completed','confidence':95,'summary':'Generated English, Urdu and Roman Urdu public alerts.','reasoningPoints':['Citizens within 3.2 km selected','High severity warning format used','Alerts prepared for multilingual delivery'], 'timestamp':Timestamp.fromDate(DateTime.now().add(const Duration(seconds:5)))}
  ];
  List<Map<String,dynamic>> _alerts(String crisisId,String severity)=>[
    {'crisisId':crisisId,'language':'English','title':'Flood Emergency - Gulshan-e-Iqbal','message':'Flood emergency reported in Gulshan-e-Iqbal, Karachi. Avoid University Road, NIPA, and nearby low-lying roads. Rescue teams are on the way.','severity':severity,'location':'Gulshan-e-Iqbal, Karachi','status':'Sent','createdAt':Timestamp.now()},
    {'crisisId':crisisId,'language':'Urdu','title':'گلشن اقبال میں سیلابی صورتحال','message':'گلشن اقبال کراچی میں سیلابی صورتحال رپورٹ ہوئی ہے۔ یونیورسٹی روڈ، نیپا اور قریبی نشیبی راستوں سے گریز کریں۔','severity':severity,'location':'Gulshan-e-Iqbal, Karachi','status':'Sent','createdAt':Timestamp.now()},
    {'crisisId':crisisId,'language':'Roman Urdu','title':'Gulshan Flood Alert','message':'Gulshan-e-Iqbal Karachi mein flooding report hui hai. University Road aur NIPA se parhez karein. Rescue teams raaste mein hain.','severity':severity,'location':'Gulshan-e-Iqbal, Karachi','status':'Sent','createdAt':Timestamp.now()}
  ];
}

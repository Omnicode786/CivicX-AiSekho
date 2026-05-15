import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GradientShell extends StatelessWidget {
  final Widget child;
  const GradientShell({super.key, required this.child});
  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      gradient: RadialGradient(center: Alignment.topRight, radius: 1.15, colors: [Color(0x4420D4FF), CivixColors.bg]),
    ),
    child: child,
  );
}

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color glow;
  const GlassCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.glow = CivixColors.cyan});
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(24),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.075),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: glow.withOpacity(.28)),
          boxShadow: [BoxShadow(color: glow.withOpacity(.08), blurRadius: 22, spreadRadius: 1)],
        ),
        child: child,
      ),
    ),
  );
}

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  const NeonButton({super.key, required this.label, required this.onTap, this.icon});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon ?? Icons.bolt),
      label: Padding(padding: const EdgeInsets.symmetric(vertical: 14), child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
      style: ElevatedButton.styleFrom(
        backgroundColor: CivixColors.cyan,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  );
}

class StatusPill extends StatelessWidget {
  final String text;
  final Color color;
  const StatusPill(this.text, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(color: color.withOpacity(.16), borderRadius: BorderRadius.circular(99), border: Border.all(color: color.withOpacity(.5))),
    child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
  );
}

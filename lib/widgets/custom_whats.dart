import 'package:commerce/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomWhats extends StatelessWidget {
  final String helpNumber = "+201019148497"; // رقم الواتساب

  const CustomWhats({super.key});

  Future<void> _openWhatsApp() async {
    final Uri whatsappUri = Uri.parse(
      "https://wa.me/${helpNumber.replaceAll("+", "")}?text=Hello, I need some help",
    );

    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      throw "WhatsApp could not be opened: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomListTile(
      icon: FontAwesomeIcons.whatsapp,
      iconColor: Colors.green,
      title: "Contact via WhatsApp",
      onTap: _openWhatsApp, // 👈 استدعاء الدالة هنا
    );
  }
}

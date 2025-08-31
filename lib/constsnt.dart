import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';


   String secretKey = dotenv.env['STRIPE_SECRET_KEY'] ?? '';
   String publishKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';



const kPrimaryColor = Color(0xfff2f2f2);
const kMostUseColor = Color(0xfffd6f3e);


import 'package:feed_estimator/src/core/constants/common.dart';
import 'package:flutter/material.dart';
import 'package:feed_estimator/src/utils/widgets/responsive_scaffold.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('About'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App info card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Image(
                        image: AssetImage('assets/images/logo.png'),
                        width: 60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Feed Estimator',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '© ${DateTime.now().year} All Rights Reserved',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Designed by section
            const Text(
              'Designed By:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/ebena.png'),
                      width: 140,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Ebena Agro Ltd',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+2348067150455',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'http://ebena.com.ng',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Credit section
            const Text(
              'Credits:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'The proximate analysis, data and information used for developing this application are sourced majorly from the following sources: 1. INRA-CIRAD-AFZ Feed tables, 2018 (www.feedtables.com); 2. Nutrient Requirements of Swine 11th Rev. Ed., 2012, National Research Council; 3. AmiPig - ileal standardised digestibility of amino acids in feedstuffs for pigs, 2000; 4. Swine Nutrition Guide, 2000; 5. Evapig; 6. NIAS; 7. CVB Feed Table 2016 (www.cvbdiervoeding.nl); and FNB.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Disclaimer section
            const Text(
              'Disclaimer:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 1,
              color: AppConstants.appCarrotColor.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text(
                  'Feed Estimator is designed, developed and built by twitter.com/ebena107 for Ebena Agro Ltd, Ejigbo, Osun State Nigeria. It is released under MIT licence by Ebena Agro Ltd. By downloading and using this app, you accept that Ebena Agro Ltd and its designers shall not be held liable for any direct or indirect damages arising from the use of Feed Estimator and/or the data generated. It is explicitly stated that any financial or commercial loss or action directed against Feed Estimator by a third party constitutes indirect damage and is not eligible for compensation by Ebena Agro Ltd.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

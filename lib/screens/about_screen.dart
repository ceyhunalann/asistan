import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hakkımızda"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Kar-Zarar Hesaplama Uygulaması Hakkında\n\n"
                  "Bu uygulama, işletmenizin finansal performansını kolayca takip edebilmeniz "
                  "ve kar-zarar hesaplamalarını pratik bir şekilde yapabilmeniz için geliştirilmiştir. "
                  "Kullanıcı dostu arayüzü, güvenilir hesaplama algoritmaları ve gerçek zamanlı döviz kuru desteği "
                  "(TCMB verilerine dayalı) ile satışlarınızı en iyi şekilde analiz etmenize yardımcı olur.\n\n"
                  "Özellikler:\n"
                  "- Ürün bazında detaylı kar-zarar hesaplamaları.\n"
                  "- Günlük satış raporları ile performans takibi.\n"
                  "- Gerçek zamanlı döviz kuru bilgisi.\n"
                  "- Kolay kullanım ve hızlı navigasyon.\n\n"
                  "Geliştirici: Alan Tech\n"
                  "Sürüm: 1.3.1\n\n"
                  "Sorumluluk Reddi:\n"
                  "Bu uygulama, sağlanan hesaplama sonuçlarına dayanarak alınan kararlar için hiçbir şekilde garanti vermez. "
                  "Kullanıcılar, sonuçları kendi sorumluluklarında değerlendirmelidir. Uygulama, herhangi bir finansal kayıp veya zararın "
                  "sorumluluğunu kabul etmez.\n\n"
                  "İletişim:\n"
                  "ceyhunalan@icloud.com",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // En alt kısımda küçük logo
            Image.asset(
              'assets/logo.png',
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}

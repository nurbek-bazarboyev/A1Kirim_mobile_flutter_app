import 'item.dart';
class Market {
  final int? rekvizitId;
  final int? klientAndPostavchikId;
  final String? orgName;
  final String? address;
  final String? telefonMain;
  final int? bankId;
  final int? inn;
  final bool? isGazna;
  final String? direktor;
  final double? jamiSumma;
  final double? olganSumma;
  final double? berganSumma;
  final double? olishimKerakBulganSumma;
  final double? barishimKerakBulganSumma;
  final int? mfo;
  final int? hisobRaqamId;
  final int? qarzdorId;
  final int? tumanId;
  final int? aptekaId;
  final double? qarzdorningQarzQiymati;
  final double? qarzdorningQanchaBergani;
  final double? totalBalance;

  Market({
    this.rekvizitId,
    this.klientAndPostavchikId,
    this.orgName,
    this.address,
    this.telefonMain,
    this.bankId,
    this.inn,
    this.isGazna,
    this.direktor,
    this.jamiSumma,
    this.olganSumma,
    this.berganSumma,
    this.olishimKerakBulganSumma,
    this.barishimKerakBulganSumma,
    this.mfo,
    this.hisobRaqamId,
    this.qarzdorId,
    this.tumanId,
    this.aptekaId,
    this.qarzdorningQarzQiymati,
    this.qarzdorningQanchaBergani,
    this.totalBalance,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      rekvizitId: json['rekvizitId'],
      klientAndPostavchikId: json['klientAndPostavchikId'],
      orgName: json['orgName'],
      address: json['address'],
      telefonMain: json['telefonMain'],
      bankId: json['bankId'],
      inn: json['inn'],
      isGazna: json['isGazna'],
      direktor: json['direktor'],
      jamiSumma: (json['jamiSumma'] as num).toDouble(),
      olganSumma: (json['olganSumma'] as num).toDouble(),
      berganSumma: (json['berganSumma'] as num).toDouble(),
      olishimKerakBulganSumma: (json['olishimKerakBulganSumma'] as num).toDouble(),
      barishimKerakBulganSumma: (json['barishimKerakBulganSumma'] as num).toDouble(),
      mfo: json['mfo'],
      hisobRaqamId: json['HisobRaqamId'],
      qarzdorId: json['QarzdorId'],
      tumanId: json['tumanId'],
      aptekaId: json['aptekaId'],
      qarzdorningQarzQiymati: (json['qarzdorningQarzQiymati'] as num).toDouble(),
      qarzdorningQanchaBergani: (json['qarzdorningQanchaBergani'] as num).toDouble(),
      totalBalance: (json['totalBalance'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rekvizitId': rekvizitId,
      'klientAndPostavchikId': klientAndPostavchikId,
      'orgName': orgName,
      'address': address,
      'telefonMain': telefonMain,
      'bankId': bankId,
      'inn': inn,
      'isGazna': isGazna,
      'direktor': direktor,
      'jamiSumma': jamiSumma,
      'olganSumma': olganSumma,
      'berganSumma': berganSumma,
      'olishimKerakBulganSumma': olishimKerakBulganSumma,
      'barishimKerakBulganSumma': barishimKerakBulganSumma,
      'mfo': mfo,
      'HisobRaqamId': hisobRaqamId,
      'QarzdorId': qarzdorId,
      'tumanId': tumanId,
      'aptekaId': aptekaId,
      'qarzdorningQarzQiymati': qarzdorningQarzQiymati,
      'qarzdorningQanchaBergani': qarzdorningQanchaBergani,
      'totalBalance': totalBalance,
    };
  }
}

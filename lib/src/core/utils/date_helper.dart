class DateHelper{
  static compareDates({required String beginDate, required String endDate}){
    DateTime begin = DateTime.parse(beginDate);
    DateTime end = DateTime.parse(endDate);
    if(begin.isAfter(end)){
      return 0;
    }else{
      return 1;
    }
  }
  static String formatDate(String date) {
    List<String> parts = date.split('-');
    String year = parts[0].substring(2); // Extract last two digits of the year
    String month = getMonthName(parts[1]);
    String day = parts[2];
    return '«$day» $month 20$year yil';
  }
  static String getMonthName(String month) {
    const months = {
      '01': 'yanvar', '02': 'fevral', '03': 'mart', '04': 'aprel', '05': 'may', '06': 'iyun',
      '07': 'iyul', '08': 'avgust', '09': 'sentyabr', '10': 'oktyabr', '11': 'noyabr', '12': 'dekabr'
    };
    return months[month] ?? '';
  }
}
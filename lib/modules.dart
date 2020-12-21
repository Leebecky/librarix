 //^ Common Functions that can be reused
 
 //? Takes the dateTime string and extracts only the day/month/year
  String parseDate(String date) {
    var dateParse = DateTime.parse(date);
    var dateString = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return dateString.toString();
  }
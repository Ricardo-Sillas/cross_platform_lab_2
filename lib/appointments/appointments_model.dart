import 'package:flutter_book_non_nullsafe/base_model.dart';

AppointmentsModel appointmentsModel = AppointmentsModel();

class Appointment {
  int id;
  String title;
  String description;
  String date;
  String time;

  bool hasTime() => time != null;
  bool hasDate() => date != null;

  String toString()  =>
      "{ id=$id, title=$title, description=$description, date=$date, time=$time }";
}

class AppointmentsModel
    extends BaseModel<Appointment>
    with DateSelection {

  String time;

  void setDate(String date) {
    super.setChosenDate(date);
  }

  void setTime(String time) {
    this.time = time;
    notifyListeners();
  }
}

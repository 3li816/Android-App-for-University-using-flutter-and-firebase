import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class CalendarScreen extends StatefulWidget {
  var assessments;
  CalendarScreen(this.assessments);

  @override
  State<CalendarScreen> createState() => _CalenderScreenState();
}

CalendarController _controller = CalendarController();

class _CalenderScreenState extends State<CalendarScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Calender'),
        ),
        body: SfCalendar(
            allowedViews: [
              CalendarView.day,
              CalendarView.week,
              CalendarView.month
            ],
            controller: _controller,
            monthViewSettings: MonthViewSettings(
              showTrailingAndLeadingDates: false,
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            ),
            // view: myView,
            firstDayOfWeek: 6,
            
            appointmentTextStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.fade,
                fontStyle: FontStyle.italic),
            dataSource: _getCalendarDataSource(),
            appointmentBuilder:
                (BuildContext context, CalendarAppointmentDetails details) {
              final Appointment meeting = details.appointments.first;
              if (_controller.view == CalendarView.week) {
                return Container(
                  color: meeting.color,
                  child: Expanded(
                    child: SingleChildScrollView(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          meeting.subject,
                          maxLines: 10,
                              overflow: TextOverflow.ellipsis,
                          style:
                              TextStyle(fontWeight: FontWeight.bold, fontSize: 7),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (_controller.view == CalendarView.day){
                return Container(
                  color: meeting.color,
                  child: Expanded(
                    child: Center(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              meeting.subject,
                              style:
                                  TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Center(
                            child: Text(' ${DateFormat('hh:mm a').format(meeting.startTime)} - ' +
                                              '${DateFormat('hh:mm a').format(meeting.endTime)}',
                                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              else{
                return Container(color: meeting.color,child:Text(meeting.subject, style: TextStyle(fontSize: 5, fontWeight: FontWeight.bold),));
              }
            }));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _AppointmentDataSource _getCalendarDataSource() {
    var colors = [
      Colors.blue,
      Colors.red,
      Colors.grey,
      Colors.green.shade300, 
      Colors.green.shade700, 
      Colors.purple.shade900,
      Colors.pink

    ];
    
    List<Appointment> appointments = <Appointment>[];
    if (widget.assessments != null) {
      for (var data in widget.assessments) {
        var startTime = data['dateTimeAssessment'];
        var title =
            data['courseName'] + " - " + data['assessment']['assessmentName'];
        var endTime;
        if (data['assessment']['assessmentType'] == 'Quiz') {
          var minsHours = data['assessment']['minutesHours'];
          var duration = int.parse(data['assessment']['duration']);
          if (minsHours == 'Hours') {
            endTime = startTime.add(Duration(hours: duration));
          } else {
            endTime = startTime.add(Duration(minutes: duration));
          }
        }
        if (data['assessment']['assessmentType'] == 'Project' ||
            data['assessment']['assessmentType'] == 'Assignment') {
          endTime = startTime;
          startTime = startTime.subtract(Duration(hours: 2));
          title = title ;
        }
        Random random = new Random();
    int randomNumber = random.nextInt(7);
    Color color = colors[randomNumber];

        appointments.add(Appointment(
          startTime: startTime,
          endTime: endTime,
          subject: title,
          color: color,
          startTimeZone: '',
          endTimeZone: '',
        ));
      }
    }

    return _AppointmentDataSource(appointments);
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
    @override
    bool isAllDay(int index) {
      return false;
    }
  }
}

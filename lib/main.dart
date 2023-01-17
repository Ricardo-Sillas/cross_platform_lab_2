import 'package:flutter/material.dart';
import 'package:flutter_book_non_nullsafe/appointments/appointments.dart';
import 'package:flutter_book_non_nullsafe/tasks/tasks.dart';
import 'notes/notes.dart';

void main() {
  runApp(FlutterBook());
}

class FlutterBook extends StatelessWidget {
  static const _TABS = [
    const {'icon': Icons.date_range, 'name': 'Appointments'},
    const {'icon': Icons.note, 'name': 'Notes'},
    const {'icon': Icons.assignment_turned_in, 'name': 'Tasks'},
    const {'icon': Icons.contacts, 'name': 'Contacts'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DefaultTabController(
        length: _TABS.length, // 4
        child: Scaffold(
          appBar: AppBar(
            title: Text('Flutter Book'),
            bottom: TabBar(tabs: _TABS.map((tab) => Tab(icon: Icon(tab['icon']), text: tab['name'])).toList())
          ),
          body: TabBarView(
            children: _TABS.map((tab) => _Dummy(tab['name'])).toList(),
          )
        )
      )
    );
  }
}

class _Dummy extends StatelessWidget {
  final _title;

  _Dummy(this._title);

  @override
  Widget build(BuildContext context) {
    if (_title == 'Notes') return Notes();
    if (_title == 'Tasks') return Tasks();
    if (_title == 'Appointments') return Appointments();
    return Center(child: Text(_title));
  }
}


class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

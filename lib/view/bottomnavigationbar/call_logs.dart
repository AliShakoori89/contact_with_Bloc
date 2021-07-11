import 'package:call_log/call_log.dart';
import 'package:flutter/material.dart';


class CallLogs extends StatefulWidget {
  @override
  _CallLogsState createState() => _CallLogsState();
}

class _CallLogsState extends State<CallLogs> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[300].withOpacity(0.5),
        title: Center(
          child: Text('Call Logs',
            style: TextStyle(color: Colors.black87, fontSize: 16),),
        )
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/1.05,
          height: MediaQuery.of(context).size.height / 1.4,
          decoration: BoxDecoration(
              color: Colors.grey[400].withOpacity(0.5),
            borderRadius: BorderRadius.circular(15)
          ),
          child: FutureBuilder(
              future: CallLog.get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                List<CallLogEntry> entries = snapshot.data.toList();
                return Scrollbar(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      var entry = entries[index];
                      return Container(
                        margin: EdgeInsets.all(MediaQuery.of(context).size.height / 80),
                        child: Column(
                          children: [
                            Divider(
                              endIndent: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 80),
                                      child: Text('${entry.name}',style: TextStyle(fontSize: 20),),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: MediaQuery.of(context).size.height / 80,),
                                    Text('${entry.number}'),
                                    Text('${entry.callType}'),
                                    Text('${DateTime.fromMillisecondsSinceEpoch(entry.timestamp)}'),
                                    Text('${entry.duration}',),
                                  ],
                                )
                              ],
                            ),
                          ],
                        )
                      );
                    },
                    itemCount: entries.length,
                  ),
                );
              }),
        ),
      ),
    );
  }
}


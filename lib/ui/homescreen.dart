import 'dart:convert';

import 'package:blockten/services/api.services.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late final WebSocketChannel channel;
  

 List<Map<String, dynamic>> Crypto = [];



 @override
 void initState() {
   super.initState();
   channel = IOWebSocketChannel.connect("ws://prereg.ex.api.ampiy.com/prices");
    _listenToStream();
    _subscribeToTicker();
    
 }
   void _subscribeToTicker() {
    final subscriptionMessage = jsonEncode({
      "method": "SUBSCRIBE",
      "params": ["all@ticker"],
      "cid": 1
    });

    channel.sink.add(subscriptionMessage);
    print("Subscribed to ticker");
  }
void _listenToStream() {
    channel.stream.listen((event) {
      final data = jsonDecode(event);

      if (data['data'] != null && data['data'].isNotEmpty) {
        List<Map<String, dynamic>> newCrypto = List<Map<String, dynamic>>.from(
          data['data'].map((item) => {
                'symbol': item['s'],
                'currentPrice': double.tryParse(item['p'].toString()) ?? 0.0,
                'changePercent': item['Pp'],
              }),
        );

        newCrypto
            .sort((a, b) => b['currentPrice'].compareTo(a['currentPrice']));

        List<Map<String, dynamic>> top10Crypto = newCrypto.take(10).toList();

        setState(() {
          Crypto = top10Crypto;
        });
      }
    },);
  }


 
  @override
 Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Amplify Flutter'),
      ),
      body: Crypto.isNotEmpty
          ? ListView.builder(
              itemCount: Crypto.length,
              itemBuilder: (context, index) {
                final item = Crypto[index];
                return ListTile(
                  title: Text(item['symbol']?.toString() ?? 'N/A'),
                  subtitle: Text(item['currentPrice']?.toString() ?? 'N/A'),
                  trailing: Text(item['changePercent']?.toString() ?? 'N/A'),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
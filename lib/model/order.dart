import 'package:cloud_firestore/cloud_firestore.dart';

class OrderClass {
  final String orderId;
  final String userId;
  final String title;
  final String type;
  final dynamic price;
  final String date;
  final dynamic room;

  OrderClass({
    required this.orderId,
    required this.userId,
    required this.title,
    required this.type,
    required this.price,
    required this.date,
    required this.room,
  });

  factory OrderClass.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return OrderClass(
      orderId: snapshot.id,
      userId: data['userId'],
      title: data['title'],
      type: data['type'],
      price: data['price'].toDouble(),
      date: data['date'],
      room: data['room'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'type': type,
      'price': price,
      'date': date,
      'room': room,
    };
  }
}
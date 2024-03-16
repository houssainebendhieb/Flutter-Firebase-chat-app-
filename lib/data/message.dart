class Message {
  final String message;
  final String from;
  final String to;
  Message(this.message, this.from, this.to);

  factory Message.fromJson(jsonData) {
    return Message(jsonData['message'], jsonData['from'], jsonData['to']);
  }
}

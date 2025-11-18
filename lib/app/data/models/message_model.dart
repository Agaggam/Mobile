class Message {
  final int id; // ID dari tabel Supabase
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.createdAt,
  });

  // Factory baru untuk membaca data dari Supabase
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      text: json['message_text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Helper untuk mengirim data ke Supabase
  Map<String, dynamic> toJsonForInsert() {
    return {
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message_text': text,
    };
  }
}

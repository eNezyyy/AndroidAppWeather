class Note {
  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });

  final String id;
  final String title;
  final String content;
  final String date;

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? date,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'content': content,
      'date': date,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      content: map['content'] as String? ?? '',
      date: map['date'] as String? ?? '',
    );
  }
}


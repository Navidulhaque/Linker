class Storage {
  final String? text;
  final String? url;
  Storage({this.text, this.url});
  factory Storage.fromMap(Map<String, dynamic> json) => new Storage(
        text: json['text'],
        url: json['url'],
      );
  Map<String, dynamic> toMap() {
    return {
      'label': text,
      'url': url,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.

}

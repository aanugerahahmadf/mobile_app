class DropdownOption {
  final String key;
  final String label;

  const DropdownOption({required this.key, required this.label});

  factory DropdownOption.fromJson(Map<String, dynamic> json) {
    return DropdownOption(
      key: json['key'] as String? ?? '',
      label: json['label'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'key': key, 'label': label};
}

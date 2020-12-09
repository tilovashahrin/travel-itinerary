class Language{
  final int id;
  final String name;
  final String flag;
  final String languageCode;

  Language(this.id, this.name, this.flag, this.languageCode);

  static List<Language> languageList(){
    return <Language>[
      Language(1,'🇨🇦','English', 'en'),
      Language(2,'🇯🇵','日本人', 'ja'),
      Language(3,'🇷🇺','русский', 'ru'),
      Language(4,'🇮🇳','हिंदी', 'hi'),
    ];
  }

}
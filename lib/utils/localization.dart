class AppLocalizations {
  AppLocalizations(this.languageCode);

  final String languageCode;

  static const Map<String, Map<String, String>> _localizedValues = {
    'appTitle': {'en': 'Rajniti Sathi', 'hi': 'राजनीति साथी'},
    'splashTagline': {
      'en': 'Create campaign posters in seconds',
      'hi': 'सेकंडों में अभियान पोस्टर बनाएं',
    },
    'language': {'en': 'Language', 'hi': 'भाषा'},
    'english': {'en': 'English', 'hi': 'अंग्रेज़ी'},
    'hindi': {'en': 'Hindi', 'hi': 'हिंदी'},
    'headline': {
      'en': 'Your campaign-ready creative studio',
      'hi': 'आपका चुनावी क्रिएटिव स्टूडियो',
    },
    'subHeadline': {
      'en': 'Manage poster previews, personalize candidate identity, and keep upcoming dates in one place.',
      'hi': 'पोस्टर प्रीव्यू, उम्मीदवार की पहचान और आने वाली तारीखें एक ही जगह संभालें।',
    },
    'upcomingDates': {'en': 'Upcoming Dates', 'hi': 'आने वाली तिथियां'},
    'today': {'en': 'Today', 'hi': 'आज'},
    'posterFeed': {'en': 'Poster Feed', 'hi': 'पोस्टर फीड'},
    'dragHint': {'en': 'Hold and drag photo', 'hi': 'फोटो दबाकर खींचें'},
    'download': {'en': 'Download', 'hi': 'डाउनलोड'},
    'edit': {'en': 'Edit', 'hi': 'एडिट'},
    'share': {'en': 'Share', 'hi': 'शेयर'},
    'editPoster': {'en': 'Edit poster', 'hi': 'पोस्टर एडिट करें'},
    'changeName': {'en': 'Change name', 'hi': 'नाम बदलें'},
    'textColor': {'en': 'Text color', 'hi': 'टेक्स्ट रंग'},
    'nameBackground': {
      'en': 'Background behind name',
      'hi': 'नाम के पीछे बैकग्राउंड',
    },
    'saveChanges': {'en': 'Save changes', 'hi': 'बदलाव सहेजें'},
    'drawerSubtitle': {
      'en': 'Political poster dashboard',
      'hi': 'राजनीतिक पोस्टर डैशबोर्ड',
    },
    'home': {'en': 'Home', 'hi': 'होम'},
    'premium': {'en': 'Premium', 'hi': 'प्रीमियम'},
    'myPosters': {'en': 'My Posters', 'hi': 'मेरे पोस्टर'},
    'settings': {'en': 'Settings', 'hi': 'सेटिंग्स'},
    'about': {'en': 'About', 'hi': 'जानकारी'},
    'futureFirebasePlaceholder': {
      'en': 'Backend-ready placeholder: replace local poster data here when Firebase or another source is connected.',
      'hi': 'बैकएंड हेतु प्लेसहोल्डर: Firebase या अन्य स्रोत जुड़ने पर यहां लोकल पोस्टर डेटा बदलें।',
    },
  };

  String get appTitle => translate('appTitle');

  String translate(String key) {
    return _localizedValues[key]?[languageCode] ??
        _localizedValues[key]?['en'] ??
        key;
  }
}

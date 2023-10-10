# translations
Utility repo for generating translations 

1. My recommendation on the easiest way to use this repo is to create a directory in your Flutter project called translate at the same depth as your lib directory.  

2. The pubspec file just needs this:

```yaml
name: translate

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  translations:
    git: git@github.com:fhir-fli/translations.git
```

3. You will need GCP setup for this to work as expected, and you'll need a project that can have a service account, and you'll need to activate the Google Sheets API.

4. Then you'll need a file, I call mine ```generate_translations.dart``` but that part doesn't really matter. The content of that file looks mostly like this:

```dart
import 'package:translations/translate.dart';

Future<void> main() async => await translate(
      translationCredentials: translationCredentials,
      translationSheetId: translationSheetId,
    );

/// these are serviceAccount credentials that have access to your spreadsheet (that's all you need to give it access to)
const translationCredentials = {
  "type": "service_account",
  "project_id": "your_project_id",
  "private_key_id": "111112222233333444445555566666",
  "private_key":
      "-----BEGIN PRIVATE KEY-----SUPER-SECRET-PRIVATE-KEY\n-----END PRIVATE KEY-----\n",
  "client_email": "client.email.iam.gserviceaccount.com",
  "client_id": "66666777778888899999",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url":
      "https://www.googleapis.com/some/service/account",
  "universe_domain": "googleapis.com"
};

/// https://docs.google.com/spreadsheets/d/AAAAABBBBBCCCCCDDDDD-EEEEEFFFFFGGGGGHHHHH/edit#gid=0
const translationSheetId = 'AAAAABBBBBCCCCCDDDDD-EEEEEFFFFFGGGGGHHHHH';

```

5. Then, from the PRIMARY PROJECT DIRECTORY, run ```dart translate/generate_translations.dart```
# translations
Utility repo for generating translations 

My recommendation on the easiest way to use this repo is to create a directory in your Flutter project called translate at the same depth as your lib directory.  The pubspec file just needs this:

```yaml
name: translate

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  translations:
    git: git@github.com:fhir-fli/translations.git
```

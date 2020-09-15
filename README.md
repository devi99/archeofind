# archeofind

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

Invoke View > Command Palette.
Type “flutter”, and select the Flutter: New Project.

Deployment
https://flutter.dev/docs/deployment/android
flutter doctor -v
 Java binary at: C:\Program Files\Android\Android Studio\jre\bin\java
 cd "C:\Program Files\Android\Android Studio\jre\bin"
keytool -genkey -v -keystore c:\Users\dleemans\archeofind.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key

Enter keystore password:
Re-enter new password:
What is your first and last name?
  [Unknown]:  davy
What is the name of your organizational unit?
  [Unknown]:  What is the name of your organization?
  [Unknown]:
C:\Program Files\Android\Android Studio\jre\bin>keytool -genkey -v -keystore c:\Users\dleemans\archeofind.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
Enter keystore password:azerty123
Re-enter new password: azerty123
What is your first and last name?
  [Unknown]:  davy leemans
What is the name of your organizational unit?
  [Unknown]:  davy
What is the name of your organization?
  [Unknown]:  leemans
What is the name of your City or Locality?
  [Unknown]:  antwerp
What is the name of your State or Province?
  [Unknown]:  antwerp
What is the two-letter country code for this unit?
  [Unknown]:  be
Is CN=davy leemans, OU=davy, O=leemans, L=antwerp, ST=antwerp, C=be correct?
  [no]:  yes

Generating 2.048 bit RSA key pair and self-signed certificate (SHA256withRSA) with a validity of 10.000 days
        for: CN=davy leemans, OU=davy, O=leemans, L=antwerp, ST=antwerp, C=be
Enter key password for <key>
        (RETURN if same as keystore password):
Re-enter new password:
[Storing c:\Users\dleemans\archeofind.jks]

Warning:
The JKS keystore uses a proprietary format. It is recommended to migrate to PKCS12 which is an industry standard format using "keytool -importkeystore -srckeystore c:\Users\dleemans\archeofind.jks -destkeystore c:\Users\dleemans\archeofind.jks -deststoretype pkcs12".


https://developer.android.com/studio/publish/app-signing#generate-key

https://play.google.com/apps/publish

build.gradle
applicationId "be.davyleemans.archeofind"

increase version number in pubspec.yaml
flutter build appbundle
upload C:\dev\archeofind\build\app\outputs\bundle\release to 

probleem camera package
In build.gradle
minSdkVersion 21  ipv 16
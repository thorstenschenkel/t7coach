class User {
  final String uid;
  final String email;
  final String photoUrl;
  final String displayName;

  //
  // EmailAuthProviderID: password
  // PhoneAuthProviderID: phone
  // GoogleAuthProviderID: google.com
  // FacebookAuthProviderID: facebook.com
  // TwitterAuthProviderID: twitter.com
  // GitHubAuthProviderID: github.com
  // AppleAuthProviderID: apple.com
  // YahooAuthProviderID: yahoo.com
  // MicrosoftAuthProviderID: hotmail.com
  //
  final String providerId;
  final String signInMethod;

  User({this.uid, this.email, this.photoUrl, this.displayName, this.providerId, this.signInMethod});

  Map<String, dynamic> toJson() =>
      {
        'uid': uid,
        'email': email,
        'photoUrl': photoUrl,
        'displayName': displayName,
        'providerId': providerId,
        'signInMethod': signInMethod
      };

}

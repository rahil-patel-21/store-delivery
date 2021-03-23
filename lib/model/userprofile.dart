class UserProfile {
  String userId;
  String profilePic;
  String userName;
  String fullName;

  UserProfile({this.userId, this.profilePic, this.userName, this.fullName});

  UserProfile.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    profilePic = json['profilePic'];
    userName = json['userName'];
    fullName = json['fullName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId']= userId;
    data['profilePic'] = this.profilePic;
    data['userName'] = this.userName;
    data['fullName'] = this.fullName;
    return data;
  }
}
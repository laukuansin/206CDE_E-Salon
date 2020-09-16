
enum Role{
  OWNER,
  WORKER,
  CUSTOMER
}

class User{
  static User _user;
  String email;
  Role role;

  User._(final String email,final Role role): email = email, role = role;

  static bool isAuthenticated(){
    return _user != null;
  }

  static bool authenticate(String email, String password){
    if(_user == null)
      _user = User._(email, Role.WORKER);
    return true;
  }

  static Role getRole()=> _user.role;
}
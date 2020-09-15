class Project{
  int _id;
  String _name;
  String _address;
  int _type;
  int _start;
  int _end;

  //Default Constructor
  Project(this._name, this._start, this._type, [this._address]);

  //Getters
  int get id => _id;
  int get type => _type;
  String get name => _name;
  String get address => _address;
  int get start => _start; 
  int get end => _end; 

  //Setters
   set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set address(String newAddress) {
    if (newAddress.length <= 255) {
      this._address = newAddress;
    }
  }

  set type(int newType) {
    if (newType >= 1 && newType <= 2) {
      this._type = newType;
    }
  }

  set start(int newStart) {
    this._start = newStart;
  }

  set end(int newEnd) {
    this._end = newEnd;
  }

  // Convert a Project object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['address'] = _address;
    map['type'] = _type;
    map['start'] = _start;
    map['end'] = _end;
    return map;
  }

  // Extract a Note object from a Map object
  Project.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._address = map['address'];
    this._type = map['type'];
    this._start = map['start'];
    this._end = map['end'];
  }

}
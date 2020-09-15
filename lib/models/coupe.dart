class Coupe{
  int _id;
  String _name;
  String _dig;
  String _level;
  String _depth;
  String _image;
  int _date;

  //Default Constructor
  //Coupe(this._name, this._dig, this._level, this._depth);
  Coupe();

  //Getters
  int get id => _id;
  int get date => _date;
  String get name => _name;
  String get dig => _dig;
  String get level => _level; 
  String get depth => _depth; 
  String get image => _image;

  //Setters
  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }

  set dig(String newDig) {
    if (newDig.length <= 255) {
      this._dig = newDig;
    }
  }

  set level(String newLevel) {
    if (newLevel.length <= 255) {
      this._level = newLevel;
    }
  }

  set depth(String newDepth) {
    if (newDepth.length <= 255) {
      this._depth = newDepth;
    }
  }

  set image(String newImage) {
    if (newImage.length <= 255) {
      this._image = newImage;
    }
  }

  set date(int newDate) {
    if (newDate >= 1 && newDate <= 2) {
      this._date = newDate;
    }
  }

  // Convert a Coupe object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['dig'] = _dig;
    map['level'] = _level;
    map['depth'] = _depth;
    map['image'] = _image;
    map['date'] = _date;
    return map;
  }

  // Extract a Coupe object from a Map object
  Coupe.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._dig = map['dig'];
    this._level = map['level'];
    this._depth = map['depth'];
    this._image = map['image'];
    this._date = map['date'];
  }

}
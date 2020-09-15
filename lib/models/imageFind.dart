class ImageFind{
  int _id, _type, _date, _purpose, _uploaded;
  String _name, _project, _windDirection, _werkput, _vlak, _spoor, _coupe, _profiel, _structuur, _vondst; 
 
  ImageFind();

  //Getters
  int get id => _id;
  int get date => _date;
  int get type => _type;
  String get name => _name;
  String get project => _project;
  int get purpose => _purpose; 
  int get uploaded => _uploaded; 
  String get windDirection => _windDirection; 
  String get werkput => _werkput;
  String get vlak => _vlak;
  String get spoor => _spoor;
  String get coupe => _coupe;
  String get profiel => _profiel;
  String get structuur => _structuur;
  String get vondst => _vondst;

  //Setters
  set project(String newProject) {
    if (newProject.length <= 255) {
      this._project = newProject;
    }
  }
  set name(String newName) {
    if (newName.length <= 255) {
      this._name = newName;
    }
  }
  set windDirection(String newWindDirection) {
    if (newWindDirection.length <= 255) {
      this._windDirection = newWindDirection;
    }
  }
  set werkput(String newWerkput) {
    if (newWerkput.length <= 255) {
      this._werkput = newWerkput;
    }
  }
  set vlak(String newVlak) {
    if (newVlak.length <= 255) {
      this._vlak = newVlak;
    }
  }
  set spoor(String newSpoor) {
    if (newSpoor.length <= 255) {
      this._spoor = newSpoor;
    }
  }
  set coupe(String newCoupe) {
    if (newCoupe.length <= 255) {
      this._coupe = newCoupe;
    }
  }
  set profiel(String newProfiel) {
    if (newProfiel.length <= 255) {
      this._profiel = newProfiel;
    }
  }
  set structuur(String newStructuur) {
    if (newStructuur.length <= 255) {
      this._structuur = newStructuur;
    }
  }
  set vondst(String newVondst) {
    if (newVondst.length <= 255) {
      this._vondst = newVondst;
    }
  }  

  set type(int newType) {
      this._type = newType;
  }

  set date(int newDate) {
      this._date = newDate;
  }
  set purpose(int newPurpose) {
      this._purpose = newPurpose;
  }
  set uploaded(int newUploaded) {
      this._uploaded = newUploaded;
  }
  // Convert a Coupe object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }

    map['date'] = _date;
    map['type'] = _type;
    map['name'] =_name;
    map['project'] = _project;
    map['uploaded'] = _uploaded;
    map['purpose'] = _purpose;
    map['windDirection'] = _windDirection;
    map['werkput'] =_werkput;
    map['vlak'] = _vlak;
    map['spoor'] = _spoor;
    map['coupe'] = _coupe;
    map['profiel'] = _profiel;
    map['structuur'] =_structuur;
    map['vondst'] = _vondst;

    return map;
  }

  // Extract a Coupe object from a Map object
  ImageFind.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._date = map['date'];
    this._type = map['type'];
    this._project = map['project'];
    this._uploaded = map['uploaded'];
    this._purpose = map['purpose'];
    this._windDirection = map['windDirection'];
    this._werkput = map['werkput'];
    this._vlak = map['vlak'];
    this._spoor = map['spoor'];
    this._coupe = map['coupe'];
    this._profiel = map['profiel'];
    this._vondst = map['vondst'];
  }

}
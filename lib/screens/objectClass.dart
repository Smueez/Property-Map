class objectClass {
  double lat,lng;
  String add,title;

  objectClass(double lat,double lng,String add, String title){
    this.lat = lat;
    this.lng = lng;
    this.add = add;
    this.title = title;

  }
  String getAdd(){
    return this.add;
  }
  String getTitle(){
    return this.title;
  }
  double getLat(){
    return this.lat;
  }
  double getLng(){
    return this.lng;
  }
}
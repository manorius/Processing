// The following short JSON file called "data.json" is parsed 
// in the code below. It must be in the project's "data" folder.
//
// {
//   "id": 0,
//   "species": "Panthera leo",
//   "name": "Lion"
// }

JSONObject json;

void setup() {

  json = loadJSONObject("http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=228");

  //String id = json.getString("return");
  JSONObject returnO = json.getJSONObject("return").getJSONObject("markets");//.getJSONObject("CLOAK");//.getJSONArray("buyorders");
  //String species = json.getString("species");
  //String name = json.getString("name");
  println(returnO);
  //println(returnO.size());

 // println(returnO.getJSONObject(3));
}

// Sketch prints:
// 0, Panthera leo, Lion

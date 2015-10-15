ArrayList points = new ArrayList();

void setup()
{
  
String[] sa1 = { "OH", "NY", "CA"}; 
String[] sa2 = append(sa1, "MA"); 
//println(sa2);
// Prints updated array contents to the console:
// [0] "OH"
// [1] "NY"
// [2] "CA"
// [3] "MA"


points.add(1);
points.add(23425);
points.add(sa2);

// TYPECASING ((TYPE[])ARRAYLIST.get(pointer) )[pointer]
println(( (String[])points.get(2))[0] );

for(int n=0;n<10;n++)
{
// print(n); 
// print("\n"); 
}

for(int n=10;n<30;n++)
{
// print(n); 
// print("\n"); 
}

}

void draw()
{

//println(points.get(1));
}


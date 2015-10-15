String[] sa1 = { "OH", "NY", "CA"}; 
sa1 = append(sa1, "MA"); 
println(sa1);
// Prints updated array contents to the console:
// [0] "OH"
// [1] "NY"
// [2] "CA"
// [3] "MA"\\

PVector[] points = {};
points = (PVector[]) append(points, new PVector(10,20));
points = (PVector[]) append(points, new PVector(1123,1230));
points = (PVector[]) append(points, new PVector(11240,3210));
points = (PVector[]) append(points, new PVector(12410,2530));
println(points.length);

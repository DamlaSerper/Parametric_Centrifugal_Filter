// 0.Set Kernel
//SetFactory("Built-in");
SetFactory("OpenCASCADE");

// 1.Variables -- Belongs to top plane (circle) of the filter basket but written as top due to being a copy file
d = 0.0550;
h = 0.0740; 		
v = 0.0087;
w_in = 0.002;
y = 0.019;
a1 = 0.0042;
a2 = 0.0040; 		
w_fm = 0.0008; 
s_in = 0.0033;

r_cyl_top = h-a2-w_fm; // Radius of the bottom cylinder inside the inner basket, reference drawing (a3), unit: m
cyl_top_hi_y = 0; // Reference drawing: origin
r_cyl_top_2 = y-w_in; // Inner radius of the inlet pipe, unit: m
cyl_top_hi_y_2 = 0;

// Points definition
// Top outer circle points (the inner filtermesh radius) (Pi/2 degrees each, 4 circles)
Point(1) = {-r_cyl_top, cyl_top_hi_y, 0, 1};
Point(2) = {0, cyl_top_hi_y, -r_cyl_top, 1};
Point(3) = {r_cyl_top, cyl_top_hi_y, 0, 1};
Point(4) = {0, cyl_top_hi_y, r_cyl_top, 1};
Point(5) = {0, cyl_top_hi_y, 0, 1};

// Inner top circle points (the inner inlet pipe radius) (Pi/2 degrees each, 4 circles)
Point(6) = {-r_cyl_top_2, cyl_top_hi_y_2, 0, 1};
Point(7) = {0, cyl_top_hi_y_2, -r_cyl_top_2, 1};
Point(8) = {r_cyl_top_2, cyl_top_hi_y_2, 0, 1};
Point(9) = {0, cyl_top_hi_y_2, r_cyl_top_2, 1};
Point(10) = {0, cyl_top_hi_y_2, 0, 1};

// Circles and lines definition (8 circles, 4 lines)
// Top circles
Circle(1) = {1, 5, 2}; // Top outer circle 1
Circle(2) = {2, 5, 3}; // Top outer circle 2
Circle(3) = {3, 5, 4}; // Top outer circle 3
Circle(4) = {4, 5, 1}; // Top outer circle 4

Circle(5) = {6,10,7}; // Top inner circle 1
Circle(6) = {7,10,8}; // Top inner circle 2
Circle(7) = {8,10,9}; // Top inner circle 3
Circle(8) = {9,10,6}; // Top inner circle 4

Line(9) = {1,6};
Line(10) = {2,7};
Line(11) = {3,8};
Line(12) = {4,9};

// Curve loops
Curve Loop(1) = {1,10,-5,-9};
Curve Loop(2) = {2,11,-6,-10};
Curve Loop(3) = {3,12,-7,-11};
Curve Loop(4) = {4,9,-8,-12}; 

// Surfaces
Surface(1) = {1};
Surface(2) = {2};
Surface(3) = {3};
Surface(4) = {4};

// Mesh progression and number of mesh nodes definition // Change here for updating mesh quality!!!
// Circles
hor_cir = 14; 				       // Number of nodes on the circle in horizontal direction
hor_bump_cir = 1; 		       // Bump progression of nodes on the circle in horizontal direction
ver_cir = 12;
ver_bump_cir = 0.8; 


// Tranfinite curves
Transfinite Curve {1} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {2} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {3} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {4} =  hor_cir Using Bump hor_bump_cir;

Transfinite Curve {5} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {6} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {7} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {8} =  hor_cir Using Bump hor_bump_cir;

Transfinite Line {9} =  ver_cir Using Bump ver_bump_cir;
Transfinite Line {10} =  ver_cir Using Bump ver_bump_cir;
Transfinite Line {11} =  ver_cir Using Bump ver_bump_cir;
Transfinite Line {12} =  ver_cir Using Bump ver_bump_cir;

// Transfinite surfaces (Uses boundary points not the curve or loops)
Transfinite Surface(1) = {1,2,7,6};
Transfinite Surface(2) = {2,3,8,7};
Transfinite Surface(3) = {3,4,9,8};
Transfinite Surface(4) = {4,1,6,9};

// Meshing algorithm
Mesh.Algorithm = 5; // 5 is Delunay for triangles


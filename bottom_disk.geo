// 0.Set Kernel
//SetFactory("Built-in");
SetFactory("OpenCASCADE");

// 1.Variables -- Belongs to bottom plane (circle) of the filter basket but written as top due to having a copy file
d = 0.0550;
h = 0.0740; 		
v = 0.0087;
a1 = 0.0042;
a2 = 0.0040; 		
w_fm = 0.0008; 
s_in = 0.0033;

r_cyl_top = h-a2-w_fm; // Radius of the bottom cylinder inside the inner basket, reference drawing (a3), unit: m
cyl_top_hi_y = -(s_in+v+d-a1); // Reference drawing: -((v+d-a1) + s_in)

// Points definition
// Top circle points (Pi/2 degrees each, 4 circles)
Point(1) = {-r_cyl_top, cyl_top_hi_y, 0, 1};
Point(2) = {0, cyl_top_hi_y, -r_cyl_top, 1};
Point(3) = {r_cyl_top, cyl_top_hi_y, 0, 1};
Point(4) = {0, cyl_top_hi_y, r_cyl_top, 1};
Point(5) = {0, cyl_top_hi_y, 0, 1};

// Circles and lines definition (8 circles, 4 lines)
// Top circles
Circle(1) = {1, 5, 2}; // Top circle 1
Circle(2) = {2, 5, 3}; // Top circle 2
Circle(3) = {3, 5, 4}; // Top circle 3
Circle(4) = {4, 5, 1}; // Top circle 4

// Curve loops
Curve Loop(1) = {1, 2, 3, 4}; // Top full circle 

// Surfaces
Surface(1) = {1}; // Top full circle surface

// Mesh progression and number of mesh nodes definition // Change here for updating mesh quality!!!
// Circles
hor_cir = 30; 				       // Number of nodes on the circle in horizontal direction
hor_bump_cir = 1; 		       // Bump progression of nodes on the circle in horizontal direction


// Tranfinite curves
Transfinite Curve {1} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {2} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {3} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {4} =  hor_cir Using Bump hor_bump_cir;

// Transfinite surfaces (Uses boundary points not the curve or loops)
Transfinite Surface(1) = {1, 2, 3, 4}; // Top full circle 


// Meshing algorithm
Mesh.Algorithm = 5; // 5 is Delunay for triangles


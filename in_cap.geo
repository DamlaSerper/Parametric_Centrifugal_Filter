// Gmsh project created on Wed May  8 15:38:11 2024
SetFactory("OpenCASCADE");

// 1.Variables -- Belongs to inlet pipe cylinder but written as top due to having a copy file
s_in = 0.0033; // Submersion of the inlet pipe into the inner basket of the centrifuge (q+j=s_in+v+d-a1; from the s-side and under the thickness)
w_in = 0.002;
y = 0.019;

r_cyl_top = y-w_in; // Inner radius of the inlet pipe, unit: m
h_cyl_top = 0.0600; // Height of the inlet pipe, specifically chosen large value to ensure adjusted particle size fitting in the pipe, unit: m
cyl_top_hi_y = h_cyl_top-s_in; // Reference drawing:  -((v+d-a1) + s_in)

//Points definition
Point(1) = {-r_cyl_top, cyl_top_hi_y, 0, 1};
Point(2) = {0, cyl_top_hi_y, -r_cyl_top, 1};
Point(3) = {r_cyl_top, cyl_top_hi_y, 0, 1};
Point(4) = {0, cyl_top_hi_y, r_cyl_top, 1};
Point(5) = {0, cyl_top_hi_y, 0, 1};

// Circles definition (4 circles)
Circle(1) = {1, 5, 2}; // Top circle 1
Circle(2) = {2, 5, 3}; // Top circle 2
Circle(3) = {3, 5, 4}; // Top circle 3
Circle(4) = {4, 5, 1}; // Top circle 4

// Surface definition
Curve Loop(1) = {1, 2, 3, 4}; // Top full circle 
Surface(1) = {1}; // Top full circle surface

// Meshing
hor_cir = 16; 				       // Number of nodes on the circle in horizontal direction
hor_bump_cir = 1; 		               // Bump progression of nodes on the circle in horizontal direction
Transfinite Curve {1} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {2} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {3} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {4} =  hor_cir Using Bump hor_bump_cir;
Transfinite Surface(1) = {1, 2, 3, 4}; // Top full circle 

// Meshing algorithm
Mesh.Algorithm = 5; // 5 is Delunay for triangles

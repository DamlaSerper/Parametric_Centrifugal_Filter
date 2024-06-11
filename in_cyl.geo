// 0.Set Kernel
//SetFactory("Built-in");
SetFactory("OpenCASCADE");

// 1.Variables -- Belongs toinlet pipe cylinder but written as top due to having a copy file
s_in = 0.0033; // Submersion of the inlet pipe into the inner basket of the centrifuge (q+j=s_in+v+d-a1; from the s-side and under the thickness)
w_in = 0.002;
y = 0.019;

r_cyl_top = y-w_in; // Inner radius of the inlet pipe, unit: m
h_cyl_top = 0.0600; // Height of the inlet pipe, specifically chosen large value to ensure adjusted particle size fitting in the pipe, unit: m
cyl_top_lo_y = -s_in; // Reference drawing: -((v+d-f-a1) + s_in)
cyl_top_hi_y = h_cyl_top-s_in; // Reference drawing:  -((v+d-a1) + s_in)

// Points definition
// Top circle points (Pi/2 degrees each, 4 circles)
Point(1) = {-r_cyl_top, cyl_top_hi_y, 0, 1};
Point(2) = {0, cyl_top_hi_y, -r_cyl_top, 1};
Point(3) = {r_cyl_top, cyl_top_hi_y, 0, 1};
Point(4) = {0, cyl_top_hi_y, r_cyl_top, 1};
Point(5) = {0, cyl_top_hi_y, 0, 1};
// Bottom circle points (Pi/2 degrees each, 4 circles)
Point(6) = {-r_cyl_top, cyl_top_lo_y, 0, 1};
Point(7) = {0, cyl_top_lo_y, -r_cyl_top, 1};
Point(8) = {r_cyl_top, cyl_top_lo_y, 0, 1};
Point(9) = {0, cyl_top_lo_y, r_cyl_top, 1};
Point(10) = {0, cyl_top_lo_y, 0, 1};

// Circles and lines definition (8 circles, 4 lines)
// Top circles
Circle(1) = {1, 5, 2}; // Top circle 1
Circle(2) = {2, 5, 3}; // Top circle 2
Circle(3) = {3, 5, 4}; // Top circle 3
Circle(4) = {4, 5, 1}; // Top circle 4
// Bottom circles
Circle(5) = {6, 10, 7}; // Top circle 1
Circle(6) = {7, 10, 8}; // Top circle 2
Circle(7) = {8, 10, 9}; // Top circle 3
Circle(8) = {9, 10, 6}; // Top circle 4
// Lines
Line(9) = {1, 6}; // Line 1
Line(10) = {2, 7}; // Line 2
Line(11) = {3, 8}; // Line 3
Line(12) = {4, 9}; // Line 4

// Curve loops
//Curve Loop(1) = {1, 2, 3, 4}; // Top full circle 
Curve Loop(2) = {-9, 1, 10, -5}; // First side wall of the cylinder, back left
Curve Loop(3) = {-10, 2, 11, -6}; // Second side wall of the cylinder, back right
Curve Loop(4) = {-11, 3, 12, -7}; // Third side wall of the cylinder, front right
Curve Loop(5) = {-12, 4, 9, -8}; // Fourth side wall of the cylinder, front left
//Curve Loop(6) = {5, 6, 7, 8};  // Bottom full circle

// Surfaces
//Surface(1) = {1}; // Top full circle surface
Surface(2) = {2}; // First side wall of the cylinder, back left
Surface(3) = {3}; // Second side wall of the cylinder, back right
Surface(4) = {4}; // Third side wall of the cylinder, front right
Surface(5) = {5}; // Fourth side wall of the cylinder, front left
//Surface(6) = {6}; // Bottom full circle

// Mesh progression and number of mesh nodes definition // Change here for updating mesh quality!!!
// Side walls of the cylinder
ver_side = 20; 				// Number of nodes on the side wall of the cylinder in vertical direction
ver_bump_side = 1; 			// Bump progression of nodes on the side wall of the cylinder in vertical direction
// Circles
hor_cir = 8; 				       // Number of nodes on the circle in horizontal direction
hor_bump_cir = 1; 		       // Bump progression of nodes on the circle in horizontal direction


// Tranfinite curves
Transfinite Curve {1} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {2} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {3} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {4} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {5} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {6} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {7} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {8} =  hor_cir Using Bump hor_bump_cir;
Transfinite Curve {9} =  ver_side Using Bump ver_bump_side;
Transfinite Curve {10} =  ver_side Using Bump ver_bump_side;
Transfinite Curve {11} =  ver_side Using Bump ver_bump_side;
Transfinite Curve {12} =  ver_side Using Bump ver_bump_side;

// Transfinite surfaces (Uses boundary points not the curve or loops)
//Transfinite Surface(1) = {1, 2, 3, 4}; // Top full circle 
Transfinite Surface(2) = {6, 1, 2, 7}; // First side wall of the cylinder, back left
Transfinite Surface(3) = {7, 2, 3, 8}; // Second side wall of the cylinder, back right
Transfinite Surface(4) = {8, 3, 4, 9}; // Third side wall of the cylinder, front right
Transfinite Surface(5) = {6, 1, 4, 9}; // Fourth side wall of the cylinder, front left
//Transfinite Surface(6) = {6, 7, 8, 9};  // Bottom full circle

// Meshing algorithm
Mesh.Algorithm = 5; // 5 is Delunay for triangles


// 0.Set Kernel
//SetFactory("Built-in");
SetFactory("OpenCASCADE");

// 1.Variables 
	// 1.1. Inner Basket
	d = 0.0550*1000;
	h = 0.0740*1000; 
	j = 0.0548*1000;
	q = 0.0080*1000;
	v = 0.0087*1000;
	a1 = 0.0042*1000;
	a2 = 0.0040*1000; 		
	w_fm = 0.0008*1000; 
	s_in = 0.0033*1000;
	
	w_ib = a1; 		// Width of the inner basket walls
	r_ibo = h; 		// Outer radius of the inner basket
	h_ibi = q+j; 		// Inner height of the inner basket (q+j)
	r_ibi = r_ibo-w_ib; 	// Inner radius of the inner basket

	// 1.2. Filter Mesh
	h_fmo = h_ibi;		// Outer height of the filter mesh
	h_fmi = h_fmo; 		// Inner height of the filter mesh
	r_fmo = r_ibi; 		// Outer radius of the filter mesh 
	r_fmi = r_fmo-w_fm; 	// Inner radius of the filter mesh

	// 1.3. Filter Mesh Properties (Square Pores -> Guess)
	p_size = 14*(1e-6)*1000;
	s_mult = 30; 	

       // Renewed algorithm
       // Horizontal
	s_real_ideal = w_fm;
	v_real = p_size;
	np_hor_real = Floor((2*Pi*r_fmi)/(s_real_ideal+v_real));
	v_tot_real = np_hor_real*v_real;
	s_tot_real = (2*Pi*r_fmi)-v_tot_real;
	s_real = s_tot_real/np_hor_real;
	np_hor = Ceil(np_hor_real/s_mult); // Horizontal number of pores
	v = v_real*s_mult;
	v_tot = v*np_hor;
	s_tot = (2*Pi*r_fmi)-v_tot;
	s = s_tot/np_hor;
	w_p_real = v_real; // Width of the rectangle pore (guess)
	w_p = v; // Simulation value of the pore width
	ps_hor = s; // Horizontal spacing between pores
	
	// Vertical
	np_ver_real = Floor(h_ibi/(s_real_ideal+v_real));
	v_tot_real = np_ver_real*v_real;
	s_tot_real = h_ibi-v_tot_real;
	s_real = s_tot_real/np_ver_real;
	np_ver = Ceil(np_ver_real/s_mult); // Vertical number of pores
	v_tot = v*np_ver;
	s_tot = h_ibi-v_tot;
	s = s_tot/np_ver;
	h_p_real = v_real; // Height of the rectangle pore (guess)
	h_p = v; // Simulation value of pore height
	ps_ver =s; // Vertical spacing between pores
	
	
	Printf("np_hor %e np_ver %e",np_hor,np_ver);
	//Corresponding Angles
	alpha = ((w_p*360)/(2*Pi*r_fmi))/2; 		// Half of the arc angle that corresponds to pore width (in degrees)
	alpha_prime = ((ps_hor*360)/(2*Pi*r_fmi))/2; 	// Half of the arc angle that corresponds to horizontal spacing (in degrees)

	// 1.4. Point definition
	n_pt_hor = 2*np_hor; 				// Number of horizontal point for filter mesh wall
	n_pt_ver = (np_ver*2)+1; 			// Number of vertical point for filter mesh wall
	n_pt = n_pt_hor*n_pt_ver; 			// Number of point = number of curves for filter mesh wall
	n_ln = n_pt_hor*(n_pt_ver-1); 			// Number of lines for filter mesh wall
	lpt = 0;					// Number of points tracker
	lct = 0;					// Number of curve, line, curve loop and surface tracker

	// 1.5. Mesh division 
	
	//Filter mesh wall arcs
	mesh_div_arc_fm_small = 48; 				// Number of nodes on the horizontal pore spacing
	mesh_div_arc_fm_small_bump = 1; 			// Bump progression of nodes on the horizontal pore spacing  
	mesh_div_arc_fm_large = 6; 				// Number of nodes on the horizontal pore side
	mesh_div_arc_fm_large_bump = 1; 			// Bump progression of nodes on the horizontal pore side
	
	//Filter mesh wall lines
	mesh_div_line_fm_small = 36; 				// Number of nodes on the vertical pore spacing (is it pore)
	mesh_div_line_fm_small_bump = 1; 			// Bump progression of nodes on the vertical pore spacing
	mesh_div_line_fm_large = 4; 				// Number of nodes on the vertical pore side (is it pore spacing)
	mesh_div_line_fm_large_bump = 1; 			// Bump progression of nodes on the vertical pore side
	
	//Bottom of the centrifuge arcs
	mesh_div_arc_small_bot_cir = mesh_div_arc_fm_small; 	// Number of nodes on the horizontal pore spacing
	mesh_div_arc_small_bot_cir_bump = mesh_div_arc_fm_small_bump; 			// Bump progression of nodes on the horizontal pore spacing  
	mesh_div_arc_large_bot_cir = mesh_div_arc_fm_large; 	// Number of nodes on the horizontal pore side 
	mesh_div_arc_large_bot_cir_bump = mesh_div_arc_fm_large_bump; 			// Bump progression of nodes on the horizontal pore side 
	
	// 1.6. Mesh Algorithm
	Mesh.Algorithm = 5; // 5 is Delunay (triangles), 8 is Delaunay for quads (quarilaterals)
	//Mesh.RecombinationAlgorithm = 2; // 2 Simple full quads, 3 for Blossom Full Quads // This line is for quad meshing option
	//Mesh.Algorithm3D = 1; // 1 Delunay 10 HXT	
//-----------------------------------------------------------------------------------------------------------------------------
//2. Definition of the outer layer of the filter mesh	
	//2.1.Define the center points of the circle arcs
	k = -1; 			// starting substracting value for odd  i's
	m = -2; 			// starting substracting value for even i's
	l = 0; 				// records below If loop's y coordinates to be used in j for loop
	
	For i In {1:n_pt_ver}
		
		//Center point are tagged after the filter mesh points, hence n_pt + 1
		If (Fmod(i, 2) != 0) 	// If i is odd
			Point(n_pt+i) = {0, ((i+k)*(ps_ver+h_p)), 0, 1};  
			l = ((i+k)*(ps_ver+h_p));
			k = k-3;

		Else 			// If i is even
			Point(n_pt+i) = {0, ((i+m-1)*ps_ver+(i+m)*h_p), 0, 1};
			l = ((i+m-1)*ps_ver+(i+m)*h_p);
			m = m-3;
		EndIf	
		
	
		For j In {1:np_hor}
		//2.2. Definition of the angles
			alpha_new_odd =  ((j-1)*2+1)*alpha + ((j-1)*2)*alpha_prime; // For the odd points
			alpha_new_even = ((j-1)*2+1)*alpha + ((j-1)*2+2)*alpha_prime; // For the even points 
		
			
		//2.3. Definition of remaining two points of each circle arc
			Point((i-1)*n_pt_hor+(j-1)*2+1) = {(-r_fmi*Sin(alpha_new_odd*2*Pi/360)), l, (r_fmi*Cos(alpha_new_odd*2*Pi/360)), 1};
			Point((i-1)*n_pt_hor+(j-1)*2+2) = {(-r_fmi*Sin(alpha_new_even*2*Pi/360)), l, (r_fmi*Cos(alpha_new_even*2*Pi/360)), 1};

			
			//2.4.Definition of the cirle arcs & transfinite curve	
			If (j==1) 		// First arc has only one line
				Circle((i-1)*n_pt_hor+j) = {((i-1)*n_pt_hor+(j-1)*2+1), (n_pt+i), ((i-1)*n_pt_hor+(j-1)*2+2)};
			
			ElseIf (j==np_hor) 	// Last one has three (connects to the one from the beginning)
				Circle((i-1)*n_pt_hor+2*j-2) = {(((i-1)*n_pt_hor+(j-1)*2+1)-1), (n_pt+i), ((i-1)*n_pt_hor+(j-1)*2+1)};
				Circle((i-1)*n_pt_hor+2*j-1) = {((i-1)*n_pt_hor+(j-1)*2+1), (n_pt+i), ((i-1)*n_pt_hor+(j-1)*2+2)};	
				Circle((i-1)*n_pt_hor+2*j) = {((i-1)*n_pt_hor+(j-1)*2+2), (n_pt+i), ((i-1)*n_pt_hor+(j-1)*2+2-(2*j-1))};
			
			Else			// Has two
				Circle((i-1)*n_pt_hor+2*j-2) = {((i-1)*n_pt_hor+((j-1)*2+1)-1), (n_pt+i), ((i-1)*n_pt_hor+(j-1)*2+1)}; 
				Circle((i-1)*n_pt_hor+2*j-1) = {((i-1)*n_pt_hor+(j-1)*2+1), (n_pt+i), ((i-1)*n_pt_hor+(j-1)*2+2)};
			EndIf	

			
		EndFor
	EndFor
	
	For i In {1:(n_pt)}
		
		If (Fmod(i, 2) != 0) 	// If i is odd
			Transfinite Curve {i} = mesh_div_arc_fm_small Using Bump mesh_div_arc_fm_small_bump;
		Else 			// If i is even
			Transfinite Curve {i} = mesh_div_arc_fm_large Using Bump mesh_div_arc_fm_large_bump;
		EndIf	
	EndFor
	
	lct = lct + n_pt;		// Creating the same number of circle as the number of point 
	lpt = lpt + n_pt + n_pt_ver;	// Creating the point of the filter mesh and center point
	

	//2.5. Definition of the lines & transfinite line
	For i In {1:n_pt_hor}
		For j In {1:(n_pt_ver-1)}
			Line(lct+j+(i-1)*(n_pt_ver-1)) = {((j-1)*n_pt_hor+i),(j*n_pt_hor+i)};
		EndFor
	EndFor	
	
	For i In {1:(2*np_ver+1)}
		For j In {1:n_pt_hor}
			If (Fmod(i, 2) != 0) // If i is odd
				Transfinite Curve {i+(j-1)*(2*np_ver+1)+n_pt} = mesh_div_line_fm_small Using Bump mesh_div_line_fm_small_bump;
			Else
				Transfinite Curve {i+(j-1)*(2*np_ver+1)+n_pt_hor*n_pt_ver} = mesh_div_line_fm_large Using Bump mesh_div_line_fm_large_bump;
			EndIf
		EndFor
	EndFor
	
	lct = lct + n_pt_hor*(n_pt_ver-1); // Creating (np_pt_ver-1) lines for each horizontal point on the top 


	//2.6.Definition of the curve loops 
	For i In {1:(n_pt_ver-1)}
		For j In {1:n_pt_hor}
			If (j==n_pt_hor)
				Curve Loop(lct+j+(i-1)*n_pt_hor) = {(j+(i-1)*n_pt_hor), (n_pt+(j-1)*(n_pt_ver-1)+1+(i-1)), (j+(i-1)*n_pt_hor+n_pt_hor), (n_pt+i)};
				
			Else
				Curve Loop(lct+j+(i-1)*n_pt_hor) = {(j+(i-1)*n_pt_hor), (n_pt+(j-1)*(n_pt_ver-1)+1+(i-1)), (j+(i-1)*n_pt_hor+n_pt_hor), (n_pt+(j-1)*(n_pt_ver-1)+1+(i-1)+(n_pt_ver-1))};
				
			EndIf
		EndFor
	EndFor

	lct_arc_1 = lct; 			// Storing the previous lct value to create the surfaces
	lct = lct + (n_pt_ver-1)*n_pt_hor; 	// Creating (np_pt_ver-1) curve loop for each horizontal point on the top
	lct_del = lct;				// Storing lct to delete the surfaces later
	
	
	//2.7.Definition of the surfaces & transfinite surfaces
	For i In {1:(n_pt_ver-1)}
		For j In {1:n_pt_hor}
			Surface(lct+j+((i-1)*n_pt_hor))={lct_arc_1+j+((i-1)*n_pt_hor)};
		EndFor
	EndFor
	
	For i In {1:(2*np_ver+1)}
		For j In {1:n_pt_hor}
			If (j==(n_pt_hor) && i!=(2*np_ver+1))
				Transfinite Surface{(j+((i-1)*n_pt_hor))}={(j+n_pt_hor*(i-1)), (j+n_pt_hor*(i-1)+1-(n_pt_hor)), (j+n_pt_hor+n_pt_hor*(i-1)), (j+n_pt_hor+n_pt_hor*(i-1)+1-(n_pt_hor))};
			  	//Recombine Surface{(c+((b-1)*n_pt_hor))}; // This line is for quad meshing option
				
			ElseIf (j==(n_pt_hor) && i==(2*np_ver+1))
				Transfinite Surface{(j+((i-1)*n_pt_hor))}={(j+n_pt_hor*(i-1)), (j+n_pt_hor*(i-1)+1-(n_pt_hor)), (j+n_pt_hor+n_pt_hor*(i-1)), (j+n_pt_hor+n_pt_hor*(i-1)+1-(n_pt_hor))};
			 	//Recombine Surface{(c+((b-1)*n_pt_hor))}; // This line is for quad meshing option
			Else
				Transfinite Surface{(j+((i-1)*n_pt_hor))}={(j+n_pt_hor*(i-1)), (j+n_pt_hor*(i-1)+1), (j+n_pt_hor+n_pt_hor*(i-1)), (j+n_pt_hor+n_pt_hor*(i-1)+1)};
				//Recombine Surface{(c+((b-1)*n_pt_hor))}; // This line is for quad meshing option
			EndIf
		EndFor
	EndFor
	
	lct = lct +(n_pt_ver-1)*n_pt_hor; 	// Creating (np_pt_ver-1) surface for each horizontal point on the top	
//-----------------------------------------------------------------------------------------------------------------------------	
//8. Delete surfaces for filter mesh pores
	
	For s In {1:np_ver}
		For u In {1:np_hor}
			Delete{ Surface{lct_del+(n_pt_hor*(1+(2*(s-1)))+(u-1)*2+2)}; }
		EndFor
	EndFor
	

/* The sor06.C main program */
// WK for Mouse
// $Id: sor06.C,v 1.10 2005/10/14 18:05:59 heine Exp $

#include "sor06.h"
#include "tools.h"
#include "arteries.h"

extern "C"  void impedance_init_driver_(int *tmstps);

#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <ctime>
#include <cstring>

using namespace std;

// The vessel-network is specified and initialized, and the flow and
// pressures are to be determed. All global constants must be defined
// in the header file. That is the number of dots per cm, and the number
// of vessels.
int main(int argc, char *argv[])
{
  double tstart, tend, finaltime;

    double rm  = 0.04; //0.005;
    
    double f1   = 0; //1.99925e07;// 8.99925e07;
    double f2   = 1;
    double f3;//   = 2.0e05;//   = 1e5;// 1.95*8.65e05;

//    double rr1 = 0.0;
//    double rr2 = 0.0;
//    double cc1 = 0.0;
//    double a = 0.0;
//    double b = 0.0;
//    double d = 0.0;
    
    
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    
    
/* This is the working section: We want to have the vessel dimensions be a variable input, and hence we can account for the number of vessels and number of terminal vessels in any given network  */
    ////////////////////////////////////////  MJC 12/18/17 /////////////////////////////////////////
    
    int total_vessels  = atoi(argv[1]);
    int total_terminal = atoi(argv[2]);
    int total_conn     = total_vessels-total_terminal;
    f3                 = atof(argv[3]);
    nbrves             = total_vessels; // The number of vessels in the network.
    impedance_init_driver_(&tmstps);
    
    Tube   *Arteries[nbrves];                    // Array of blood vessels.

        fprintf(stdout, "Total Vessels:  %d \n Total Terminal:  %d \n",total_vessels, total_terminal);
    
    
    // 2 dimensions per vessel (for now), 3 BC's per terminal vessel, # vessels, CONNECTIVITY, # terminal, stiff, sor06
//    int number_of_inputs = 2.0*total_vessels + 4.0*(total_terminal + 1.0);
//    if (argc!= number_of_inputs)
//    {
//        printf("Not enough input arguments, need %d but only have %d", argc, number_of_inputs);
//        return 1;
//    }
    /////////////// Load in the connectivity Matrix
//    int oneflag   = 1;
//    int threeflag = 0;
    int conn_rows = (total_vessels-1)/2;
    int conn_cols = 3;
    int connectivity_matrix[conn_rows][conn_cols];
    FILE *conn;
    conn = fopen("connectivity.txt","rt");
    int parent, daughter1, daughter2, r_in;
    int conn_id = 0;
//    if (conn == NULL)
//    {
//        fprintf("Error: Connectivity File Does Not Exist \n");
//        return 1;
//    }
    while ((r_in = fscanf(conn, "%d %d %d", &parent, &daughter1, &daughter2)) != EOF)
    {
//        fprintf("The values are: p = %d, d1 = %d, and d2 = %d \n",parent,daughter1,daughter2);
        connectivity_matrix[conn_id][0] = parent;
        connectivity_matrix[conn_id][1] = daughter1;
        connectivity_matrix[conn_id][2] = daughter2;
        //fprintf(stdout, "Connectivity is  %d  %d  %d\n", parent, daughter1, daughter2);
        conn_id++;
    }
    fclose(conn);
    
       /////////////// Load in the Boundary Conditions Matrix
    FILE *BCs;
    BCs = fopen("Windkessel_Parameters.txt","rt");
//    if (BCs==NULL)
//    {
//        fprintf("Error: Boundary Conditions File Does Not Exist");
//        return 1;
//    }

    double bc_matrix[total_terminal][3];
    for (int i=0; i<total_terminal; i++){
        fscanf(BCs, "%lf %lf %lf",&bc_matrix[i][0],&bc_matrix[i][1],&bc_matrix[i][2]);
       // fprintf(stdout, "BCs are  %lf  %lf  %lf\n", bc_matrix[i][0], bc_matrix[i][1], bc_matrix[i][2]);
    }
    
    fclose(BCs);
    

    /////////////// Load in terminal vessels
    
    FILE *terminal_file;
    terminal_file = fopen("terminal_vessels.txt","rt");
    int terminal_vessels[total_terminal];
    for (int i=0; i<total_terminal; i++){
        fscanf(terminal_file, "%d", &terminal_vessels[i]);
        //fprintf(stdout,"Terminal vessels are %d \n", terminal_vessels[i]);
    }
    fclose(terminal_file);
    
    
    /////////////// Load in Dimensions
    FILE *dim_file;
    dim_file = fopen("Dimensions.txt","rt");
    double dimensions_matrix[total_vessels][2];
    for (int dim_ID = 0; dim_ID < total_vessels; dim_ID++){
        fscanf(dim_file, "%5lf %5lf", &dimensions_matrix[dim_ID][0],&dimensions_matrix[dim_ID][1]);
        //fprintf(stdout,"Dimensions:  %5lf  %5lf\n",dimensions_matrix[dim_ID][0], dimensions_matrix[dim_ID][1]);
    }
    fclose(dim_file);
    
    
    // Initialization of the Arteries.
    // Definition of Class Tube: (Length, topradius, botradius, *LeftDaughter, *RightDaughter, rmin, points, init, K, f1, f2, f3, R1, R2,  CT, LT);
    /////////////// Create a dynamic network (Arteries[1] = new Tube( L1, R1, R1, Arteries[ 2], Arteries[ 3], rm, 40, 0, 0,f1,f2,f3, 0, 0, 0, 0);)
    /*                 FORWARD VERSION             */
    int curr_d1, curr_d2;
    double R1, R2, CT;
    int term_id = total_terminal-1;
    int bc_id = total_terminal-1;
    conn_id = total_conn-1;
    
///// A hard code for a single vessel
    if (total_vessels == 1){
        R1 = bc_matrix[0][0];
        R2 = bc_matrix[0][1];
        CT = bc_matrix[0][2];
        //fprintf(stdout,"At terminal vessel %d with BCs %lf %lf %lf\n", 0, R1, R2, CT);
        Arteries[0] = new Tube( dimensions_matrix[0][0], dimensions_matrix[0][1], dimensions_matrix[0][1], Arteries[ curr_d1], Arteries[ curr_d2], rm, 40, 1, 0,f1,f2,f3, R1, R2, CT, 0);
    }
    else if (total_vessels > 1){
        for (int i=total_vessels-1; i>=0; i--) {
            if (i == connectivity_matrix[conn_id][0])
            {
                curr_d1     = connectivity_matrix[conn_id][1];
                curr_d2     = connectivity_matrix[conn_id][2];
                conn_id--;
            }
            //first vessels
            if (i==0) {
                //fprintf(stdout,"At first vessel with dimensions %lf %lf  and daughters %d  %d\n",dimensions_matrix[i][0],dimensions_matrix[i][1], curr_d1, curr_d2);
                Arteries[i] = new Tube( dimensions_matrix[i][0], dimensions_matrix[i][1], dimensions_matrix[i][1], Arteries[ curr_d1], Arteries[ curr_d2], rm, 40, 1, 0,f1,f2,f3, 0, 0, 0, 0);
            }
            else{
                if (i == terminal_vessels[term_id] && term_id>=0){
                    //fprintf(stdout,"Term ID %d  with vessel number %d\n", term_id, terminal_vessels[term_id]);
                    R1 = bc_matrix[bc_id][0];
                    R2 = bc_matrix[bc_id][1];
                    CT = bc_matrix[bc_id][2];
                    //fprintf(stdout,"At terminal vessel %d with BCs %lf %lf %lf\n", i, R1, R2, CT);
                    Arteries[i] = new Tube( dimensions_matrix[i][0], dimensions_matrix[i][1], dimensions_matrix[i][1], 0, 0, rm, 40, 0, 0,f1,f2,f3, R1, R2, CT, 0);
                    term_id--;
                    bc_id--;
                }
                else
                {
                    //fprintf(stdout,"At vessel %d with dimensions %lf %lf  and daughters %d  %d\n",i,dimensions_matrix[i][0],    dimensions_matrix[i][1], curr_d1, curr_d2);
                    Arteries[i] = new Tube( dimensions_matrix[i][0], dimensions_matrix[i][1], dimensions_matrix[i][1], Arteries[ curr_d1], Arteries[ curr_d2], rm, 40, 0, 0,f1,f2,f3, 0, 0, 0, 0);
                }
            }
    
        }
    
    }
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////////////// //////////////////////////////////////////////////////////////////////////////////
//    if (total_vessels == 1){
        const char *namepu1  = "pu1_C.2d"; // "pu1_H1.2d";
        FILE *fpu1 = fopen (namepu1, "w");
        const char *namepu2  = "pu2_C.2d"; // "pu1_H2.2d";
        FILE *fpu2 = fopen (namepu2, "w");
        const char *namepu3  = "pu3_C.2d"; // "pu1_H3.2d";
        FILE *fpu3 = fopen (namepu3, "w");

//        int oneflag = 1;
//        int threeflag = 0;
//    }
//    else if (total_vessels == 3){
//        const char *namepu1  = "pu1_C.2d"; // "pu1_H1.2d";
//        FILE *fpu1 = fopen (namepu1, "w");
//        const char *namepu2  = "pu2_C.2d"; // "pu1_H2.2d";
//        FILE *fpu2 = fopen (namepu2, "w");
//        const char *namepu3  = "pu3_C.2d"; // "pu1_H3.2d";
//        FILE *fpu3 = fopen (namepu3, "w");
//        int oneflag = 0;
//        int threeflag = 1;
//    }
//    else{
//        const char *namepu1  = "pu1_C.2d"; // "pu1_H1.2d";
//        FILE *fpu1 = fopen (namepu1, "w");
//        const char *namepu2  = "pu2_C.2d"; // "pu1_H2.2d";
//        FILE *fpu2 = fopen (namepu2, "w");
//        const char *namepu3  = "pu3_C.2d"; // "pu1_H3.2d";
//        FILE *fpu3 = fopen (namepu3, "w");
//        int oneflag = 0;
//        int threeflag = 1;
//        
//    }

    
    
    
  // Workspace used by bound_right

  // Workspace used by bound_bif
  for(int i=0; i<18; i++) fjac[i] = new double[18];

//  clock_t c1 = clock();        // Only used when timing the program.
  tstart    = 0.0;            // Starting time.
  finaltime = 9*Period;       // Final end-time during a simulation.
  tend      = 8*Period;       // Timestep before the first plot-point
                              // is reached.

  // The number of vessels in the network is given when the governing array of
  // vessels is declared.

      // In the next three statements the simulations are performed until
  // tstart = tend. That is this is without making any output during this
  // first period of time. If one needs output during this period, these three
  // lines should be commented out, and the entire simulation done within the
  // forthcomming while-loop.

  // Solves the equations until time equals tend.
    
  solver (Arteries, tstart, tend, k);
  tstart = tend;
  tend = tend + Deltat;

  // fprintf (stdout,"saves Q0\n");
  // Arteries[ 0] -> printQ0(fq0);

//  fprintf (stdout,"plots start\n");

  // The loop is continued until the final time
  // is reached. If one wants to make a plot of
  // the solution versus x, tend is set to final-
  // time in the above declaration.
  while (tend <= finaltime)
  {
    for (int j=0; j<nbrves; j++)
    {
      int ArtjN = Arteries[j]->N;
      for (int i=0; i<ArtjN; i++)
      {
        Arteries[j]->Qprv[i+1] = Arteries[j]->Qnew[i+1];
        Arteries[j]->Aprv[i+1] = Arteries[j]->Anew[i+1];
      }
    }

    // Solves the equations until time equals tend.
    solver (Arteries, tstart, tend, k);
//    fprintf (stdout,".");

    // A 2D plot of P(x_fixed,t) is made. The resulting 2D graph is due to
    // the while loop, since for each call of printPt only one point is set.
      
//      if (oneflag == 1){
      if (total_vessels == 1){
          Arteries[ 0]  -> printPxt (fpu1, tend, 0);
      }
      else{
          int first_branch  = connectivity_matrix[0][0];
          int second_branch = connectivity_matrix[0][1];
          int third_branch  = connectivity_matrix[0][2];
          Arteries[ first_branch]  -> printPxt (fpu1, tend, 0);
          Arteries[second_branch]  -> printPxt (fpu2, tend, 0);
          Arteries[ third_branch]  -> printPxt (fpu3, tend, 0);

      }
//      }
//      else if (threeflag == 1){
//          int first_branch  = connectivity_matrix[0][0];
//          int second_branch = connectivity_matrix[0][1];
//          int third_branch  = connectivity_matrix[0][2];
//
//          Arteries[ first_branch]  -> printPxt (fpu1, tend, 0);
//      }
//      else {
//          int first_branch  = connectivity_matrix[0][0];
//          int second_branch = connectivity_matrix[0][1];
//          int third_branch  = connectivity_matrix[0][2];
//          
//          Arteries[ first_branch]  -> printPxt (fpu1, tend, 0);
//          Arteries[ second_branch]  -> printPxt (fpu2, tend, 0);
//          Arteries[ third_branch]  -> printPxt (fpu3, tend, 0);
//      }

      
      
      
      
      

    // The time within each print is increased.
    tstart = tend;
    tend   = tend + Deltat; // The current ending time is increased by Deltat.
  }
//  fprintf(stdout,"\n");

  // The following statements is used when timing the simulation.
//  fprintf(stdout,"nbrves = %d, Lax, ", nbrves);
//  clock_t c2 = clock(); // FIXME clock() may wrap after about 72 min.
//  int tsec = (int) ((double) (c2-c1)/CLOCKS_PER_SEC + 0.5);
//  fprintf(stdout,"cpu-time %d:%02d\n", tsec / 60, tsec % 60);

  // In order to termate the program correctly the vessel network and hence
  // all the vessels and their workspace are deleted.
  for (int i=0; i<nbrves; i++) delete Arteries[i];

  // Matrices and arrays are deleted
  for (int i=0; i<18; i++) delete[] fjac[i];

//    fprintf(stdout, "Closing Files: \n");
//    if (fclose (fpu1)  != EOF) fprintf(stdout,"1pu OK, ");
//    else error("main.C","Close 1pu NOT OK");
//    if (fclose (fpu2)  != EOF) fprintf(stdout,"2pu OK, ");
//    else error("main.C","Close 2pu NOT OK");
//    if (fclose (fpu3)  != EOF) fprintf(stdout,"3pu OK, ");
//    else error("main.C","Close 3pu NOT OK");
//    if (total_vessels == 1){
//        fclose (fpu1);
//    }
//    else{
        fclose (fpu1);
        fclose (fpu2);
        fclose (fpu3);
//    }
//    else if (threeflag == 1){
//        fclose (fpu1);
//        fclose (fpu2);
//        fclose (fpu3);
//    }
//    else {
//        fclose (fpu1);
//        fclose (fpu2);
//        fclose (fpu3);
//    }
    fprintf(stdout, "\n");
    
  return 0;
}










#*************************************************************************#
#                                                                         #
#  Program: Makefile                                                      #
#  Version: 2.0                                                           #
#  By: Mette Olufsen                                                      #
#  Date: 14. Jan. 1997                                                    #
#                                                                         # 
#  A makefile that ensures that all modules are linked together in the    #
#  right order.                                                           #
#*************************************************************************#

# $Id: Makefile,v 1.8 2010-10-20 14:39:59 heine Exp $

# For Laptop
#CXX=/usr/local/Cellar/gcc/7.3.0/bin/g++-7
# For Desktop (Fast)
CXX=/usr/local/gfortran/bin/g++
#CXX = /usr/bin/g++
CXXFLAGS=-O2 -g -Wall -D_REENTRANT

# For Laptop
#FC=/usr/local/Cellar/gcc/7.3.0/bin/gfortran#/usr/local/gfortran/bin//gfortran
# For Desktop
FC=/usr/local/gfortran/bin/gfortran
FFLAGS=-O2 -g -Wall
FLIBS=-lgfortran -lquadmath


LIBS=$(FLIBS) -lm

LDFLAGS=-O2

OBJS1=tools.o sor06.o arteries.o
OBJS2=impedance_sub.o impedance_init_sub.o root_imp.o f90_tools.o

MAIN=sor06

all: $(MAIN)

$(MAIN): $(OBJS1) $(OBJS2) 
	$(CXX) -o $(MAIN) $(LDFLAGS) $(OBJS1) $(OBJS2) $(LIBS)
	
sor06.o: sor06.C sor06.h
	$(CXX) -c $(CXXFLAGS) sor06.C
	
arteries.o: arteries.C arteries.h tools.h sor06.h
	$(CXX) -c $(CXXFLAGS) arteries.C
	
tools.o: tools.C tools.h
	$(CXX) -c $(CXXFLAGS) tools.C
		
root_imp.o: root_imp.f90 f90_tools.o
	$(FC) -c $(FFLAGS) root_imp.f90
	
f90_tools.o: f90_tools.f90
	$(FC) -c $(FFLAGS) f90_tools.f90
	
impedance_sub.o: impedance_sub.f90 f90_tools.o root_imp.o
	$(FC) -c $(FFLAGS) impedance_sub.f90
	
impedance_init_sub.o: impedance_init_sub.f90 f90_tools.o root_imp.o
	$(FC) -c $(FFLAGS) impedance_init_sub.f90
	
clean:
	-rm -f *.o *.mod Zhat* *.2d
	
veryclean: clean
	-rm $(MAIN) a.out *~

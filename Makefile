#makefile
#edited for operation on Beluga by Hiro, Jan. 2020
#library locations for calculquebec Beluga (new)
NC_LIB=/home/satohiro/local/lib
NC_INC=/home/satohiro/local/include 

#library locations for calculquebec briaree (old)
#NC_LIB=/home/apps/Logiciels/netcdf-4.1.3/lib (old)
#NC_INC=/home/apps/Logiciels/netcdf-4.1.3/include (old)
# Librairy locations pour librairie perso(old)
#NC_LIB=/RQusagers/echaste/Local/lib (old)
#NC_INC=/RQusagers/echaste/Local/include (old)

#---- should not need to change anything below this line ----


CC = mpicc
FC = mpif90

LDFLAGS  = -L$(NC_LIB) #-i_dynamic
CPPFLAGS = -Difort -I$(NC_INC)

#---optimized flags for ifort---
#CFLAGS   = -xHost #-fast
#FCFLAGS  = -xHost #-fast

#---debugging flags for ifort---

#FCFLAGS = -debug -fpe0 -traceback -g -check -check noarg_temp_created #-warn all

#---debugging flags for gfortran---

FCFLAGS  = -ffree-line-length-none -finit-local-zero -fcheck=all  -g -fbacktrace -Wall -pedantic

#-ffpe-trap=invalid,zero,overflow,underflow

LIBS     = -lnetcdff -lnetcdf

#note: files without the 'mod' suffix are f77 source that eventually need to be converted

#       lpjstatevarsmod.o       \
#       statevarsmod.o          \

COREOBJS = overprint.o       \
       parametersmod.o   \
       randomdistmod.o   \
       weathergenmod.o   \
       orbitmod.o        \
       geohashmod.o      \
       mpistatevarsmod.o \
       iovariablesmod.o  \
       errormod.o        \
       coordsmod.o       \
       initsoilmod.o     \
       initclimatemod.o  \
       getyrdatamod.o    \
       netcdfsetupmod.o  \
       initjobmod.o      \
       radiationmod.o    \
       bioclimmod.o      \
       alccmod.o         \
       hetrespmod.o      \
       snowmod.o         \
       lightmod.o        \
       waterbalancemod.o \
       pedotransfermod.o \
       simplesoilmod.o   \
       nppmod.o          \
       gppmod.o          \
       establishmentmod.o\
       mortalitymod.o    \
       allocationmod.o   \
       turnovermod.o     \
       killplantmod.o    \
       individualmod.o   \
       spitfiremod.o     \
       budwormmod.o     \
	   soiltemperaturemod.o   \
       summerphenology.o      \
       reproduction.o         \
       photosynthesis.o       \
       isotope.o              \
       pftparameters.o        \
       fire.o                 \
       netcdfoutputmod.o \
       landscape_geometrymod.o \
       foragersmod.o \
       lpjmod.o

DRIVER_PARALLEL = mpimod.o     \
                  drivermod.o  \
                  main.o

DRIVER_SERIAL = drivermod_serial.o \
                main_serial.o

.SUFFIXES: .o .f90 .f .mod

%.o : %.c
	$(CC) $(CFLAGS) -c -o $(*F).o $(CPPFLAGS) $<

%.o : %.f
	$(FC) $(FCFLAGS) -c -o $(*F).o $(CPPFLAGS) $<

%.o : %.f90
	$(FC) $(FCFLAGS) -c -o $(*F).o $(CPPFLAGS) $<

all::	parallel

parallel: $(COREOBJS) $(DRIVER_PARALLEL)
	$(FC) $(FCFLAGS) -o lpj $(COREOBJS) $(DRIVER_PARALLEL) $(LDFLAGS) $(LIBS)

serial: $(COREOBJS) $(DRIVER_SERIAL)
	$(FC) $(FCFLAGS) -o lpjserial $(COREOBJS) $(DRIVER_SERIAL) $(LDFLAGS) $(LIBS)

clean::	
	-rm lpj *.mod *.o

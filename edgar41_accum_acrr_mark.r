
# browser()
rootpath<-"/global/u2/y/yashar/hopper/"
rpath<-paste(rootpath,"WRF/WRFV3-Chem-3.4_GHG/VPRMpreproc_LCC/RSources/",sep="")
rootpath0<-"/global/u1/j/jryoo/"
rootpath1<-"/global/u2/y/yashar/hopper/"
rootpath2<-"/scratch/scratchdirs/yashar/"
rootpath3<-"/scratch/scratchdirs/yashar/wrfoutput_input_chem-3.4_8_09_12/"
# wrfoutput<-paste(rootpath1,"WRF-VPRM3/test/em_real/",sep="")
# wrfoutput<-paste(rootpath1,"WRF/WRFV3-Chem-3.4/test/em_real/",sep="")
#wrfoutput<-paste(rootpath2,"wrfoutput_input_chem-3.4_8_09_12/",sep="")
wrfoutput<-paste(rootpath0,"WRF/WRFV3+Chem/run/",sep="")
path_edgar<-paste(rootpath1,"WRF/WRFV3-Chem-3.4/test/em_real/",sep="")
#path_edgar2<-paste(rootpath2,"PREP-CHEM-SRC-1.3.2_zl/bin/",sep="")
path_edgar2<-paste(rootpath0,"WRF/PREP_CHEM_SRC_1.3/bin/",sep="")
path_edgar3<-paste(rootpath2,"carbon_tracker_flux/",sep="")
path_antro<-paste(rootpath1,"WRF/WRFV3-Chem-3.4/test/em_real/",sep="")


#rqd functions
source(paste(rpath,"assignr.r",sep=""))
source(paste(rpath,"getr.r",sep=""))
source(paste(rpath,"distance.r",sep=""))
source(paste(rpath,"image.plot.fix.r",sep=""))
source(paste(rpath,"image.plot.plt.fix.r",sep=""))

go<-graphics.off
pc<-F #no windows
library(RNetCDF)

#read wrfinput file

  # get the domain (nest, coarse, etc.)
  # domain="1" #"2" for nest
#---------------------------
#  domain="1"
#  final <- 5
#   for (j in 1:final){
#    ifelse(j <= 9, final<-paste("0",j, sep=""), final <- j)  
#  date <- paste("02-",final,sep="")
#---------------------------
  domain="1"
  final <- 30
   for (j in 30:final){
    ifelse(j <= 9, final<-paste("0",j, sep=""), final <- j)  
  date <- paste("05-",final,sep="")
#---------------------------
  
  # get coordinates from WRF
  
  filename1 <- paste(wrfoutput,"wrfout_d0",domain,"_2012-",date,"_00:00:00",sep="")
  print(filename1)
  # load wrf output grid
  nc       <- open.nc(filename1)
  lat.wrf  <- (var.get.nc(nc,"XLAT"))
  lon.wrf  <- (var.get.nc(nc,"XLONG"))
  # print(lat.wrf)  
  # print(lon.wrf)
  close.nc(nc)

  lat.wrf0 <- t(lat.wrf[,,1])
  lon.wrf0 <- t(lon.wrf[,,1])
  # print(lat.wrf0)
  # print(lon.wrf0)
 
######################################################################################
######################################################################################
# For new wrf-ghg version
######################################################################################
######################################################################################

 ############load the EDGAR data for each hour separetely###############################
  time <- 24
  edgar_tot_ch4 <- array(0,cbind(dim(lat.wrf0)[2],dim(lat.wrf0)[1],1,24)) # 1 file per each hour
  edgar_tot_co2 <- array(0,cbind(dim(lat.wrf0)[2],dim(lat.wrf0)[1],1,24)) # 1 file per each hour
  edgar_tot_co <- array(0,cbind(dim(lat.wrf0)[2],dim(lat.wrf0)[1],1,24)) # 1 file per each hour
  xlat <-  array(0,cbind(dim(lat.wrf0)[2],dim(lat.wrf0)[1],24))
  xlong <- array(0,cbind(dim(lat.wrf0)[2],dim(lat.wrf0)[1],24))
  # print(xlat)
  # print(xlong)  
  # print(edgar_tot_co2)
  # print (dim(lat.wrf0)[1])
  # print (dim(lat.wrf0)[2]) 
  # print (dim(lat.wrf0))
  

  for (i in 0:time){
    ifelse(i <= 9, time<-paste("0",i, sep=""), time <- i)

# Get the lat/lon values of the EDGAR CO2 source file and alss the wrf output file (see above)
  
  # filename_edgar <- paste(path_edgar2,"EDG41-HIRES-CO2_ANTH_EMISSION-T-2013-",date,"-",time,"0000-g",domain,".nc",sep="") 
  # filename_edgar <- paste(path_edgar2,"EDG3-CO2_ANT_EMISS_DIURN_OFF-T-2006-",date,"-",time,"0000-g",domain,".nc",sep="")
  # filename_edgar <- paste(path_edgar2,"EDG41-CO2_ANT_EMISS_DIURN_OFF-T-2006-",date,"-",time,"0000-g",domain,".nc",sep="")
  filename_edgar <- paste(path_edgar2,"EDG41-CO2_ANT_EMISS_DIURN_ON-T-2012-",date,"-",time,"0000-g",domain,".nc",sep="")
  # filename_edgar <- paste(path_edgar2,"EDG41-CO2_ANT_BB_EMISSION-T-2006-",date,"-",time,"0000-g",domain,".nc",sep="")
  # filename_edgar <- paste(path_edgar2,"EDG3-CO2_ANTHRO_EMISSION-T-2006-",date,"-",time,"0000-g",domain,".nc",sep="")
  print(filename_edgar)

  nc <- open.nc(filename_edgar)
  edgar_ch4 <- (var.get.nc(nc,"ch4_edgar"))
  edgar_co2 <- (var.get.nc(nc,"co2_edgar"))
   edgar_co <- (var.get.nc(nc,"co_edgar"))
  close.nc(nc)
 
  edgar_ch4 <- (edgar_ch4)
  edgar_co2 <- (edgar_co2)
  edgar_co <- (edgar_co)

print(dim(edgar_ch4))
print(dim(edgar_tot_ch4))

  
  edgar_tot_ch4[,,1,i] <- edgar_ch4[,] 
  edgar_tot_co2[,,1,i] <- edgar_co2[,]
  edgar_tot_co[,,1,i] <- edgar_co[,]

  xlat[,,i]<-  lat.wrf0[,] 
  xlong[,,i] <-  lon.wrf0[,]
  
  # print(xlat)
  # print(xlat[,,1,i])
  # print(edgar_co2[,,1,i]) 
 
  }
  # print(edgar_tot_co2)  
  # print(edgar_co2)
  # print(edgar_tot_co2[,,1,i])

### get the units from kg/m²s to mol/km²h

edgar_tot_ch4 <- edgar_tot_ch4*3.6e9/(0.012+4.*0.001)
edgar_tot_co2 <- edgar_tot_co2*3.6e9/(0.012+2.*0.016)  # Use this when diurnal cycle is turned on in pre-processor
# print(edgar_tot_co2)
# edgar_tot_co2 <- edgar_tot_co2*9.469e5
edgar_tot_co <- edgar_tot_co*3.6e9/(0.012+1.*0.016)
### get the times from the WRF output file

 path_time <- "/global/u2/y/yashar/hopper/WRF/WRFV3-Chem-3.4/test/em_real/"
 filename_time <- paste(wrfoutput,"wrfout_d0",domain,"_2012-",date,"_00:00:00",sep="")
  nc <- open.nc(filename_time)
  times <- (var.get.nc(nc,"Times"))
  print(filename_time)
  print(times)
  close.nc(nc)

times2 <- times[0:24]
# print(times2)

####wite the netcdf file
print("hello1")
nc.out_wrf  <- create.nc(paste(path_antro,"CO2_edg41_ant_diurnon_",date,"_2012_d0",domain,sep=""))
##############################################################
dim.def.nc(nc.out_wrf,"Time",unlim=TRUE)
dim.def.nc(nc.out_wrf,"DateStrLength",19)
dim.def.nc(nc.out_wrf,"south_north",dimlength=dim(lat.wrf0)[1])
dim.def.nc(nc.out_wrf,"west_east",dimlength=dim(lon.wrf0)[2])
dim.def.nc(nc.out_wrf,"bottom_top",1)

# print(dim(lat.wrf0)[1])
# print(dim(lon.wrf0)[2])

var.def.nc(nc.out_wrf,"E_CH4", "NC_FLOAT",c(3,2,4,0))
var.def.nc(nc.out_wrf,"E_CH4TST", "NC_FLOAT",c(3,2,4,0))
var.def.nc(nc.out_wrf,"E_CO2", "NC_FLOAT",c(3,2,4,0))
var.def.nc(nc.out_wrf,"E_CO", "NC_FLOAT",c(3,2,4,0))

var.def.nc(nc.out_wrf,"Times","NC_CHAR",c(1,0))
var.def.nc(nc.out_wrf,"XLAT", "NC_FLOAT",c(3,2,0))

att.put.nc(nc.out_wrf, "XLAT", "FieldType", "NC_INT", 104)
att.put.nc(nc.out_wrf, "XLAT", "MemoryOrder", "NC_CHAR", "XY")
att.put.nc(nc.out_wrf, "XLAT", "description", "NC_CHAR", "LATITUDE, SOUTH IS NEGATIVE")
att.put.nc(nc.out_wrf, "XLAT", "units", "NC_CHAR", "degrees_north")
att.put.nc(nc.out_wrf, "XLAT", "stagger", "NC_CHAR", " ")
# att.put.nc(nc.out_wrf, "XLAT", "long_name", "NC_CHAR", "latitude coordinate")
# att.put.nc(nc.out_wrf, "XLAT", "standard_name", "NC_CHAR", "latitude")

var.def.nc(nc.out_wrf,"XLONG", "NC_FLOAT",c(3,2,0))
att.put.nc(nc.out_wrf, "XLONG", "FieldType", "NC_INT", 104)
att.put.nc(nc.out_wrf, "XLONG", "MemoryOrder", "NC_CHAR", "XY")
att.put.nc(nc.out_wrf, "XLONG", "description", "NC_CHAR", "LONGITUDE, WEST IS NEGATIVE")
att.put.nc(nc.out_wrf, "XLONG", "units", "NC_CHAR", "degrees_east")
att.put.nc(nc.out_wrf, "XLONG", "stagger", "NC_CHAR", " ")
# att.put.nc(nc.out_wrf, "XLONG", "long_name", "NC_CHAR", "longitude coordinate")
# att.put.nc(nc.out_wrf, "XLONG", "standard_name", "NC_CHAR", "longitude")

var.put.nc(nc.out_wrf, "E_CH4", edgar_tot_ch4)
att.put.nc(nc.out_wrf, "E_CH4", "FieldType", "NC_INT", 104)
att.put.nc(nc.out_wrf, "E_CH4", "MemoryOrder", "NC_CHAR", "XYZ")
att.put.nc(nc.out_wrf, "E_CH4", "coordinates", "NC_CHAR", "XLONG XLAT")
att.put.nc(nc.out_wrf, "E_CH4", "description", "NC_CHAR", "EMISSIONS")
att.put.nc(nc.out_wrf, "E_CH4", "stagger", "NC_CHAR", " ")
att.put.nc(nc.out_wrf, "E_CH4", "units", "NC_CHAR", "mol km^-2 hr^-1")


var.put.nc(nc.out_wrf, "E_CO2", edgar_tot_co2)
att.put.nc(nc.out_wrf, "E_CO2", "FieldType", "NC_INT", 104)
att.put.nc(nc.out_wrf, "E_CO2", "MemoryOrder", "NC_CHAR", "XYZ")
att.put.nc(nc.out_wrf, "E_CO2", "coordinates", "NC_CHAR", "XLONG XLAT")
att.put.nc(nc.out_wrf, "E_CO2", "description", "NC_CHAR", "EMISSIONS")
att.put.nc(nc.out_wrf, "E_CO2", "stagger", "NC_CHAR", " ")
att.put.nc(nc.out_wrf, "E_CO2", "units", "NC_CHAR", "mol km^-2 hr^-1")

var.put.nc(nc.out_wrf, "E_CO", edgar_tot_co)
att.put.nc(nc.out_wrf, "E_CO", "FieldType", "NC_INT", 104)
att.put.nc(nc.out_wrf, "E_CO", "MemoryOrder", "NC_CHAR", "XYZ")
att.put.nc(nc.out_wrf, "E_CO", "coordinates", "NC_CHAR", "XLONG XLAT")
att.put.nc(nc.out_wrf, "E_CO", "description", "NC_CHAR", "EMISSIONS")
att.put.nc(nc.out_wrf, "E_CO", "stagger", "NC_CHAR", " ")
att.put.nc(nc.out_wrf, "E_CO", "units", "NC_CHAR", "mol km^-2 hr^-1")

# Global attributes

att.put.nc(nc.out_wrf, "NC_GLOBAL", "TITLE", "NC_CHAR", "OUTPUT FROM *             PROGRAM:WRF/CHEM V3.4 MODEL")
att.put.nc(nc.out_wrf, "NC_GLOBAL", "START_DATE", "NC_CHAR", "2013-02-01_00:00:00")
att.put.nc(nc.out_wrf, "NC_GLOBAL", "SIMULATION_START_DATE", "NC_CHAR", "2013-02-01_00:00:00")
att.put.nc(nc.out_wrf, "NC_GLOBAL", "WEST-EAST_GRID_DIMENSION", "NC_FLOAT", 97)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "SOUTH-NORTH_GRID_DIMENSION", "NC_FLOAT", 97)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "BOTTOM-TOP_GRID_DIMENSION", "NC_INT", 1)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "DX", "NC_FLOAT", 3000)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "DY", "NC_FLOAT", 3000)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "GRID_ID", "NC_INT", 1)                                                                            
att.put.nc(nc.out_wrf, "NC_GLOBAL", "PARENT_ID", "NC_INT", 0)   
att.put.nc(nc.out_wrf, "NC_GLOBAL", "I_PARENT_START", "NC_INT", 1)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "J_PARENT_START", "NC_INT", 1)  
att.put.nc(nc.out_wrf, "NC_GLOBAL", "PARENT_GRID_RATIO", "NC_INT", 1)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "DT", "NC_FLOAT", 120)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "CEN_LAT", "NC_FLOAT", 39.73)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "CEN_LON", "NC_FLOAT", -123.64)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "TRUELAT1", "NC_FLOAT", 39.73)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "TRUELAT2", "NC_FLOAT", 81.)  
att.put.nc(nc.out_wrf, "NC_GLOBAL", "MOAD_CEN_LAT", "NC_FLOAT", 39.73)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "STAND_LON", "NC_FLOAT", -123.64)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "POLE_LAT", "NC_FLOAT", 90.)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "POLE_LON", "NC_FLOAT", 0.)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "GMT", "NC_FLOAT", 0.)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "JULYR", "NC_INT", 2013)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "JULDAY", "NC_INT", 32)
att.put.nc(nc.out_wrf, "NC_GLOBAL", "MAP_PROJ", "NC_INT", 1) 

var.put.nc(nc.out_wrf,"Times",times2)
var.put.nc(nc.out_wrf,"XLAT",xlat)
var.put.nc(nc.out_wrf,"XLONG",xlong)

close.nc(nc.out_wrf)
print("hello2")

}


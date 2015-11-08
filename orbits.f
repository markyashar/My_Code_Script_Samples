      Program ORBITS
c
c Mark Yashar
c
c 
c ****************************************************************
c General Description
c
c This program computes a closed orbital ellipse of an extra-solar planet 
c orbiting a single star using data input by the user. The program queries
c the user to enter the mass of the parent star (in solar masses), the mass 
c of the extra-solar planet (in Jupiter masses), the semi-major axis of the
c planet's orbit (in astronomical units), the orbital inclination angle (in 
c degrees), and the angle between the major axis of the planet's orbit and
c the line of site in degrees.(This is the position of the periastron 
c measured in the orbital plane from the intersection between the 
c perpendicular plane to the line of sight and the orbital plane (line 
c of nodes). The program evaluates for the radial position of the extra-
c solar planet moving about it's star, and writes out the Cartesian 
c coordinates in astronomical units (AU) for the X and Y positions. This
c program works for any bound orbit (in which the eccentricity is less 
c than one). It is coded in DOUBLE PRECISION FORTRAN.
c 
c The program also uses this inputed data to calculate the orbital speed
c of the planet at a given orbital phase over one complete orbital 
c period. (The planetary orbital phase is the time elapsed since the
c planet moved from its periastron point (where t=0) to its current 
c position (at time t>0), divided by its orbital period.
c
c The program also queries the user to input the radius of the planet in
c Jupiter radii, the radius of the star in solar radii, the emissivity or
c emission coefficient of the planet, the effective temperature of the 
c parent star in units of Kelvins, the number of time steps to be 
c calculated, and the frequency in which the time steps are to be printed.
c
c The program uses all of this inputed data to also calculate the 
c observed effective equilibrium blackbody temperature of the extrasolar 
c planet for a given orbital phase. Finally, the program calculates
c the planet-to-star flux ratios at given orbital phases (again, through
c the course of a single orbital period) at wavelengths of 0.5, 1, 3, and
c 10 micrometers. 
c
c The output file, 'orbits.dat', is written in the same directory as
c the 'orbits.f' program. The data in the output file is written in the
c form of columns with column header labels for each of the data columns.
c
c The IDL program 'plots_orbits.pro' reads this output file and 
c generates four plots in one large display window: Y (AU) vs. X (AU) (which
c helps the user to visualize the shape of the orbit, e.g., how circular 
c or eccentric (oval-shaped) it is), orbital speed vs. orbital phase, planet 
c temperature vs. orbital phase, and planet-to-star flux ratios vs orbital 
c phase at wavelengths of 0.5,1,3, and 10 micrometers. Displays of orbital 
c parameters and a legend for the planet-to-star flux ratios plot are also 
c generated. The IDL program also gives an indication as to whether the 
c inputs entered meet the criteria for a habitable planet -- a planet that lies
c lies within the "habitable zone" of its parent star. (For the purposes of 
c this program, a habitable planet or planet lying in the habitable zone of 
c its parent star has a temperature that fluctuates within and between 280K 
c and 320K (where H2O can exist in liquid form) as it moves around its star 
c in an elliptical orbit.
c
c Note that in order for plots to be generated, one must first compile
c and execute the IDL program 'plots_orbits.pro' within the IDL 
c environment, i.e.,
c
c IDL> .r plots_orbits.pro
c % Compiled module: PLOTS_ORBITS.
c IDL> plots_orbits
c 
c The program calls or 'spawns' this 'orbits.f' program within the IDL
c environment so that the 'orbits.f' program is executed within the IDL
c environment (in other words, at the IDL command prompt). Hence, the
c user is queried to enter data at the IDL command prompt (due to the 
c IDL 'spawn' command, which compiles and runs 'orbits.f' "within" IDL  
c such that the queries for data generated by 'orbits.f' are accessible 
c to the user within the IDL environment).  The calculated data is then 
c written into the 'orbits.dat' output file by this 'orbits.f' program, 
c and the IDL program then generates all of the plots and image displays 
c after reading the data in the 'orbits.dat' file.
c  
c ********************************************************************
c
c Code Physics/Astrophysics
c
c
c This code uses Kepler's laws, Newton's form of Kepler's third law,
c conservation of energy and momentum, etc. to compute the orbits of 
c planets or smaller objects around a single star (the mass of the star and 
c planet, and other orbital parameters mentioned above,  are specified by 
c the user). Specifically, the program uses the "vis viva equation (Zeilik,
c Gregory, and Smith, 1992) to calculate the total orbital speed of the
c extrasolar planet. It then uses the inclination of the orbital pole
c to the line of site (i.e., the angle between the normal to the orbital 
c plane and the line of sight), along with angle the between the major axis 
c of the planet's orbit and the line of site in degrees (both input by the
c user) to calculate the total orbital radial speed of the extrasolar
c planet at a given time.
c
c The program also calculates the planetary blackbody temperature
c as the planet moves through its elliptical orbit.( We are using a simple 
c model here in which we assume that the extrasolar planet behaves as a
c blackbody.) The program does this by finding the temperature at which a 
c small blackbody (the extrasolar planet) must radiate to balance energy
c input from the star. The program uses Stefan's law of blackbody radiation
c and the concept of equilibrium: that the rate of absorption of energy 
c equals the rate at which it is radiated away fixes an equilibrium  
c temperature. By including the emissivity or emission coefficient
c of the planet, we may more closely approximate the observed planetary
c temperatures. However, we must keep in mind that this simple 
c model does not take into account such important factors as the circulation
c of planetary atmospheres, their heat retention, internal heat sources, 
c and the variation of emissivity with wavelength.
c
c For the simple model used in this program, we use 'gray' calculations
c and theories of the atmospheres (i.e., a gray surface model) of extra-solar 
c gas giant planets. 
c
c We explain a 'gray' body as follows. If a radiating body is not black, 
c the total emission may be described by introducing the emissivity 
c emiss(lambda,T) for some wavelength and temperature. The emissivity 
c or emission coefficient is defined as the ratio of the actual radiation 
c emitted and the radiation that would be emitted if the body at hand were 
c black. A black body therefore has an emissivity equal to one and any other 
c body has an emissivity between zero and one. According to the 
c definition of the emissivity, the spectral intensity of radiation 
c emitted by a non-black body is given by its emissivity multiplied
c by the emission spectrum of a black body. For simplicity, the emissivity
c is often assumed to be independent of wavelength and temperature, i.e,
c emiss(lambda,T)=emiss. Objects that show such a wavelength-independent
c and temperature and temperature independent emissivity are usually
c called gray. Although gray objects are not found in the physical world,
c some objects (such as planet surfaces or atmospheres) show spectral
c characteristics that approximate those of a gray body. 
c
c The program also uses Planck's Radiation Law and the Law of Stefan and
c Boltzmann to calculate planet-to-star flux ratios at wavelengths of
c 0.5, 1, 3, and 10 micrometers. These wavelengths and wavelengths in this
c range are of interest to astronomers who are attempting to detect 
c extrasolar planets at infrared wavelengths from starlight reflected from
c their atmospheres or from radiation from the planet itself. For example, 
c radiation from Jupiter in the visible range is only about 10^-9 as intense
c as that from the Sun; in the infrared, where its own radiation is more 
c intense than the reflected sunlight, this fraction is higher, about 10^-6
c to 10^-4 (Unsold and Baschek, 2002).
c
c Another example: A Jupiter size planet at a distance of 0.05 AU could
c produce a reflected light component at the level of about 7x10^-5 
c relative to its host star (Charbonneau, 1999). Although the star and
c planet are at very small angular separation, they would be well-resolved
c spectroscopically, due to the large orbital velocity of the extrasolar
c planet (and, thus, a larger Doppler shift). The distinctive signature 
c produced by the addition of this secondary reflected light (and the 
c radiation/heat from an extra-solar gas giant planet itself) could be 
c observable given sufficient spectral resolution and signal-to-noise (
c such as, perhaps, the spectral resolution provided by the Texas Echelon 
c Cross Echelle Spectrograph -- a sensitive high-resolution grating 
c spectrograph for the mid-infrared.) A detection would be very significant, 
c as it would be th first direct detection of an extrasolar planet. 
c It would yield the orbital inclination and hence the mass of the planet 
c (Charbonneau, 1999). Furthermore, a measurement of a combination of the 
c planetary radius and albedo (and, thus, the emissivity) could be obtained, 
c from which a minimum planetary radius may be deduced (Charbonneau, 1999).
c 
c ****************************************************************
c 
c  REFERENCES USED
c  
c   
c  Chakrabarty, Deepto,  "MIT::Physics, Astrophysics I, Fall 2002, PS3 
c  Solutions", 2002
c  http://web.mit.edu/8.901/www/homework/ps3sol.pdf
c  
c
c  D. Charbonneau, "Reflected Light from Close-In Extra-Solar Giant 
c  Planets" in Mariotti, J. and Alloin, D. (Editors), "Proceedings of the 
c  NATO Advanced Institute on Planets Outside the Solar System: Theory and 
c  Observations.", Kluwer Academic Publishers, 1999.  
c
c  Chivers, Ian and Clark, Malcom, "Interactive Fortran -- A Hands-On
c  Approach", Ellis Horwood Limited, 1984.
c
c  Copeland, G. E., "Phys 313 - Elements of Astrophysics, Spring 2001",
c  2001
c  http://www.physics.odu.edu/~gec100f/p313/
c
c  Karttunen, H. , Kroger, P., Oja, H., Poutanen, M., and Donner, K. J.
c  (Editors), "Fundamental Astronomy", Springer-Verlag Berlin Heidelberg,
c  1996
c
c Korista, Kirk T, "Physics 325: An Introduction to Astrophysics,Spring 2003"
c Spring 2003
c http://homepages.wmich.edu/~korista/phys325.html
c  
c  Ostlie, Dale A., and Carroll, Bradley W., "An Introduction to
c  Modern Stellar Astrophysics", Addison-Wesley Publishing Company,
c  Inc., Reading Massachussetts, 1996 
c
c  Ostlie, Dale A., and Carroll, Bradley W. "Software for Modern 
c  Astrophysics"
c  http://astrophysics.weber.edu/Codes.html
c 
c  Queloz, D."Indirect Searches: Doppler Spectroscopy and Pulsar Timing."
c  From: Mariotti, J. and Alloin, D. (Editors), "Proceedings of the 
c  NATO Advanced Institute on Planets Outside the Solar System: Theory and 
c  Observations.", Kluwer Academic Publishers, 1999.  
c
c
c  Student Laboratory, vrije Universiteit amsterdam
c  "Radiation and Convection"
c  http://www.nat.vu.nl/envphysexp/REAL%20Experiments/Heat%20radiation/Radiationc  _Theory.html
c
c  Unsold, A. and Baschek, B., "The New Cosmos -- An Introduction to 
c  Astronomy and Astrophysics, Springer-Verlag, 2002.
c
c
c  Zeilik, Michael, Gregory, Stephen A., and Smith, Elske V. P.,
c  "Introductory Astronomy and Astrophysics, Saunders College 
c  Publishing, Fort Worth, 1992
c
c   
c 
c  
c
c
c **************************************************************** 
c
c Program Modules, Subroutines, Subprograms, Parts, etc...
c
c  This computing project consists of three separate computer
c  programs:'orbits.f' (Fortran 77),'plots_orbits.pro (IDL)', and
c  'loadcolors.pro'(written by Liam E.Gumley ; see references in the
c  "References Used ..." comment section of the 'plots_orbits.pro'
c  IDL program). 
c               
c 'orbits.f' queries the user to enter some parameters and properties
c  of the planet-star system and calculates values of planetary x,y
c  positions, orbital phase orbital radial speed, planetary temperatures,
c  and planet to star flux ratios over one complete orbital period
c  of the planet around its host star. All of this data is written
c  to an output file called 'orbits.dat'.      
c    
c 'plots_orbits.pro' is an IDL program which generates plots
c  of the planet's y-position vs. x-position over the course
c  of one period (i.e., it 'draws' the orbit to help the user
c  visualize the shape of the orbit), the orbital speed vs.
c  orbital phase, the planet's temperature vs. orbital phase,
c  and plots of planet-to-star flux ratios for different wavelengths
c  (all over-plotted on a single graph) vs. orbital phase. This program 
c  also generates display windows showing  orbital parameters and a 
c  legend for the planet-to-star flux ratio plots. The plots are
c  displayed in color as standard output on the screen. The program
c  also generates black and white postscript and .jpg images, which
c  are written to and save in the current directory. The user does
c  have an option to display and/or print out these postscript and
c .jpg files. 'plots_orbits.pro' also assesses whether the extrasolar 
c  planet may lie in the "habitable zone" of its host star. The simple
c  criteria used is the following: If an extra-solar planet's temperature
c  varies or fluctuates between 280K and 320K (where liquid water can
c  exist), the the planet is considered to lie in the habitable zone
c  of its host star. If a planet is deemed "habitable in this (simplified)
c  way, the planetary temperature vs. orbital phase plot will turn green
c  in color and a message will appear in the plot notifying the user that
c  the planet may lie in the habitable zone of its parent star.
c 
c 'loadcolors.pro' is an IDL procedure from pages 249-250 of the book 
c "Practical IDL Programming" by Liam E. Gumley ; Copyright 2002 by
c Academic Press. This procedure loads 16 plotting colors into
c the color table. The colors are loaded starting at index 0
c by default, or at the index specified by the 'bottom' keyword.
c The names of the colors can be returned by the 'names' keyword.
c The loadcolors.pro code (procedure) must be in the same 
c directory as the 'orbits.f' and 'plots_orbits.pro' programs
c in order for the overall program/code to be successfully
c compiled and executed.
c 
c This entire package of programs are to be compiled and executed
c at the IDL command prompt by first compiling the 'loadcolors.pro'
c procedure, and then compiling and running the 'plots_orbits.pro'
c program.
c
c
c ******************************************************************
c Major Program Variables:      
c
c     a         - semi-major axis of orbit in units of centimeters
c     r         - distance between planet and star at a given
c                 time during the planet's orbital period.      
c     aau       - semi-major axis of orbit in AU (astronomical unit)
c     akm       - semi-major axis of orbit in units of kilometers
c     e         - eccentricity of orbit       
c     time      - elapsed time
c     tyears    - time elapsed divided by the number of seconds in a year
c                 (i.e., time in units of years)
c     dt        - incrementing the elapsed time
c     v         - total orbital speed of the extrasolar planet
c                 in units of centimeters per second
c     vkm       - total orbital speed of the extrasolar planet
c                 in units of kilometers per second
c     vr        - total orbital radial speed of the extrasolar
c                 planet in units of centimeters per second
c     vrkm      - total orbital radial speed of the extrasolar 
c               - planet in units of kilometers per second.
c     LoM       - angular momentum per unit mass L/m
c     period    - orbital period in units of seconds
c     Pyears    - orbital period in units of years
c     Mstrsun   - mass of parent star in solar masses
c     Mstar     - mass of parent star in units of grams
c     Mpltjup   - mass of extrasolar planet in Jupiter masses
c     Mplanet   - mass of extrasolar planet in units of grams
c     theta     - Angle swept out by the radius vector in radians.
c                 Specifically, it is the position angle of the
c                 extrasolar planet measured from periastron (the
c                 point in its orbit where the planet is closest
c                 to its parent star.
c     thetadeg  - angle swept out by the radius vector in degrees
c     dtheta    - used for incrementing theta (i.e., used for 
c                 calculating each of the next values of theta)              
c     x         - x position of planet at time t in units of Aus
c     y         - y position of planet at time t in units of AUs
c     rau       - distance between planet (or brown or methane dwarf star)
c                 and parent star at time t in units of AUs
c     Tplanet   - observed effective equilibrium blackbody temperature
c                 of extrasolar giant planet in units of Kelvins.
c     Tstar     - Effective temperature of the parent star in units
c                 of Kelvins.
c     emis      - Emissivity or emission coefficient of the extrasolar planet.
c                 The emissivity of the planet is defined as the ratio of the 
c                 actual radiation emitted and the radiation that would be
c                 emitted if the planet were a perfect blackbody.
c     Rs        - Radius of the star in solar radii
c     Rscm      - Radius of parent star in units if centimeters
c     Rskm      - Radius of the parent star in units of kilometers.
c     Rsau      - Radius of parent star in astronomical units
c     Rplnt     - Radius of the extra-solar planet in Jupiter radii
c     Rplcm     - Radius of extra-solar planet in units of centimeters
c     
c     Fr05um    - Ratio of the observed flux density of the planet to 
c                 that of the parent star at a wavelength of 0.5 micrometers
c     Fr1um     - Ratio of the observed flux density of the planet to 
c                 that of the parent star at a wavelength of 1 micrometers
c     
c     Fr3um     - Ratio of the observed flux density of the planet to 
c                 that of the parent star at a wavelength of 3 micrometers
c
c     Fr10um    - Ratio of the observed flux density of the planet to 
c                 that of the parent star at a wavelength of 10 micrometers
c     inc       - Angle between the normal to the orbital plane and the
c                 line of site (i.e., the inclination of the orbital pole
c                 to the line of site (in degrees).
c       
c     beta      - angle between the major axis of the planet's orbit and
c                 the line of site in degrees. This is the position of
c                 the periastron measured in the orbital plane from
c                 the intersection between the perpendicular plane to the
c                 the line of sight and the orbital plane (line of nodes).
c
c*****************************************************************************
c Definition of basic constants
c
c G = constant of gravitation = 6.67259 x 10^-8 cm^3/(gm.s^2)
c AU = 1 Astronomical Unit = distance between earth and sun
c                          = 1.4960 x 10^13 cm
c AUkm = 1 Astronomical Unit in terms of kilometers
c      = 1.4960 x 10^8 km
c spyr = number of seconds in a year = 3.155815 x 10^7
c Msun = mass of sun in units of grams = 1.989 x 10^33 grams
c Mjup = mass of Jupiter in units of grams = 1.90 x 10^30 grams
c Rsuncm = radius of the Sun in units of centimeters = 6.96 x 10^10 cm 
c parscm = 1 parsec in terms of centimeters = 3.06 x 10^18 cm
c Rj   = Radius of Jupiter in centimeters = 7.1398 x 10^9 cm
c c    = speed of light in units of meters/sec. = 2.99792458 x 10^8 m/s
c h    = Planck's constant in units of Joules*seconds = 6.6260755 x 10^-34 J.s
c kboltz = Boltzmann's constant in units of Joules/Kelvin = 1.380658 x 10^-23 J/k
c ********************************************************************************
c
c
      real*8 a, aau, e, time, tyears, phase, dt, LoM, period, Pyears
      real*8 Mstrsun, Mstar, Mplanet, Msun, Mjup, Mpltjup,cos2pi,M 
      real*8 theta,dtheta, r, x, y, rau, v, vkm,thetadeg,v4,gpp
      real*8 Tplanet, Tpau, Tstar,emis,Rskm,Rscm,Rsuncm,Rs,parscm,Rplnt
      real*8 Rplcm,Fr10um,inc,Ep10um,Es10um,sini,sintb,vr,vrkm,costb
      real*8 Ep05um,Ep1um,Ep3um,Es05um,Es1um,Es3um,Rpls,beta,ecc
      real*8 G, AU, AUkm, spyr,Rj,c,h,kboltz,pi,cosb,ps,akm,v5
      integer*4 n, k, kmax, i
c  Define basic constants (in cgs units here).
c  Note that the 'data' statement below is used to provide initial
c  values for variables and arrays.
      data G,Msun,Mjup,AU,AUkm,spyr,Rsuncm,parscm,Rj,c,h,kboltz,pi
     1 / 6.67259d-08, 1.989d33, 1.899d30, 1.4959787069d13,  
     1 1.49597870691d8, 3.15581495d7, 6.9599d10, 3.06d18, 7.1398d9, 
     1 2.99792458d8,6.6260755d-34, 1.380658d-23,3.141592653589793d0 /
c  Note that the 'data' statement is used to provide initial
c  values for variables and arrays.
c
c  open output file for orbital parameters
      open(unit=10,file='orbits.dat',form='formatted',status='unknown')
c  enter physical parameters for the system
      write(*,*) ' Enter the mass of the parent star (in solar masses):'
c  Note that the 'write' statement allows us to direct output to any
c  file, including standard output. The first asterisk in the 'write'
c  statement above that output is to be written to the terminal. The 
c  second asterisk produces output controlled by the list of variables
c  (i.e., "list directed output.")
      read(*,*) Mstrsun
      print *
      write(*,*) ' Enter the mass of the extrasolar planet',
     1 '(in Jupiter masses):'
      read(*,*) Mpltjup
c  The 'read' statement is an i/o statement. It is an instruction to 
c  read from the terminal or keyboard. Whatever is typed in from the
c  terminal will end up being associated with the variable.
      write(*,*) ' Enter the semimajor axis of the orbit (in AU):'
      read(*,*) aau
 2    print *
      write(*,*) ' Enter the eccentricity, e '
      read(*,*) e
      if (e .ge. 1.) then
        write (6,*) 'orbit unbound; enter another value of e < 1'
        go to 2
      endif 
      print *
      write(*,*) ' Enter the radius of the parent star in solar radii'
      read(*,*) Rs
 3    print *
      write(*,*) ' Enter the emissivity or emission coefficient of the', 
     1 'extrasolar planet (a number between 0 and 1)'
      read(*,*) emis
      if (emis .eq. 0.) then
        write(6,*) 'emissivity must be greater than 0'
        go to 3
      elseif (emis .gt. 1.) then
        write(6,*) 'emissivity must be less that or equal to 1.',
     1 'Note that in practice, grey objects can have emission',
     1 'coefficients up to about 0.8.' 
      go to 3
      endif
      print *
      write(*,*) ' Enter the effective Temperature of the parent star ',
     1 'in units of Kelvins '
      read(*,*) Tstar
      print *
      write(*,*) ' Enter the equatorial radius of the planet in ',
     1 'Jupiter radii '
      read(*,*) Rplnt
 4    print *
      write(*,*) ' Enter the orbital inclination angle in degrees',
     1 '(i.e., the angle between the normal to the orbital plane',
     1 'of the extrasolar planet and the line of site.)' 
      read(*,*) inc
      if (inc .eq. 0.) then
        write(6,*) 'orbit in plane of sky; enter another value of i'
        go to 4
      elseif (inc .gt. 90.) then
        write(6,*) 'angle must be less than or equal to 90 degrees'
        go to 4
      endif
 5    print*
      write(*,*) ' Enter the angle between the major axis of the',
     1 'extrasolar planet and the line of site, (i.e.,the position',
     1 'of the periastron measured in the orbital plane from the ',
     1 'intersection between the perpendicular plane to the line',
     1 'of sight and the orbital plane (line of nodes)).'
      read(*,*) beta
      if (beta .gt. 90.) then
        write(6,*) 'angle must be less than or equal to 90 degrees'
        go to 5
      endif
      print *
c  Calculate orbital period using Kepler's third law 
      Pyears = sqrt(aau**3/(Mstrsun + Mpltjup*9.553d-04))
      write(*,*) ' '
      write(*,100) Pyears
c  The  label 100 in the 'write' statement above takes the place of
c  the asterisk and links the 'write' statement with the 'format'
c  statement below. (100 is the 'format label')
c
c  Enter the number of time steps and the time interval to be printed
      write(*,*) ' '
      write(*,*) ' '
      write(*,*) ' You may now enter the number of time steps to ',
     1 'be calculated and the'
      write(*,*) ' frequency with which you want time steps printed.'
      write(*,*) ' Note that taking too large a time step during the',
     1 ' calculation will'
      write(*,*) ' produce inaccurate results.'
      write(*,*) ' '
      write(*,*) ' Enter the number of time steps desired for the ',
     1 'calculation: '
      read(*,*) n
      write(*,*) ' '
      write(*,*) ' How often do you want time steps printed?'
      write(*,*) '     1 = every time step'
      write(*,*) '     2 = every second time step'
      write(*,*) '     3 = every third time step'
      write(*,*) '                etc.'
      read(*,*) kmax
c  Convert to cgs units
      period = Pyears*spyr
      dt = period/float(n-1)
      a = aau*AU
      Mstar = Mstrsun*Msun
      Mplanet= Mpltjup*Mjup
      Rscm=Rs*Rsuncm
      dcm= d*parscm
      Rplcm= Rplnt*Rj
c  Convert semi-major axis to kilometers
      akm=aau*AUkm
c  Initialize print counter, angle, elapsed time, and temperature
      k = 0.
      theta = 0.0d0
      time = 0.0d0
c  Print output header
      write(10,200) Mstrsun,Mpltjup,aau,Pyears,e,Tstar,Rs,emis,Rplnt,
     1 inc, beta
c     write(10,200) 
c  Note that the 'write' statement above includes the
c  use of positionally dependent parameters. In this case,
c  10 is the unit number and 200 is the format label. 
c  Specifically, the 10 here means that the output will be
c  written to the file given the unit number 10
c
c  Start main time step loop
      do 10 i = 1,n
c      
c  increment print counter
          k = k+1
c  use Eq. (2.3) to find r
          
          r = a*(1.0d0-e**2)/(1.0d0+e*cos(theta))

c  Use the 'Vis viva' equation to find the total
c  orbital speed of the extrasolar planet.
   
          v = sqrt(G*(Mstar+Mplanet)*(2./r - 1./a))
c
c  Calculate the orbital radial velocity of the extrasolar planet
c  as a function of time for any orientation (i.e., any orbital
c  inclination and any angle between the orbit's major axis
c  and the line of sight).
c
c  First, convert the orbital inclination to radians and take the sine
          sini=sin(pi*inc/180.d0)   
c Convert the angle beta to radians, and then calculate
c sin(theta + beta), where theta and beta are in radians. 
          sintb=sin(theta + beta*pi/180.d0)
          vr=-(Mstar/(Mplanet+Mstar))*sini*sintb*v
c
c ****************************************************
c Here are two other possible ways of calculating vr that give
c similar but not always exactly the same results as the
c above calculation for vr. The user should feel free to 
c experiment with different values obtained for calculating
c vr in different ways (using different equations). Please 
c see references .. (listed above).
c
c  Setting up the calculations.
c
c  costb=cos(theta + beta*pi/180.d0)
c  cosb=cos(beta*pi/180.d0)
c  ps=2.*pi*akm/period
c  ecc = (1.-e*e)**(-0.5)
c  M=Mplanet+Mstar 
c  cos2pi=cos(2.*pi*phase)
c  gpp=-(2.*pi*G*M/period)**(0.3333333333333)
c  
c  Here are two different possible ways or approaches
c  to calculating the orbital radial speed of an extrasolar
c  planet around its parent star. (See references ...)
c                   
c  vr2=-2.*pi*akm*sini*M*ecc*(costb+e*cosb)/(period*Mstar)
c  vr3=gpp*sini*ecc*(costb+e*cosb)/100000.
c ***************************************************
c
c  Calculate the observed effective equilibrium blackbody planetary 
c  temperature of the extrasolar planet.
c
          Tplanet=((emis)**0.25)*((Rscm/(2.*r))**(0.5))*Tstar
          tyears = time/spyr
c
c Setting up the calculations for the flux ratios (see below).

          Ep10um=(h*c)/(kboltz*Tplanet*10.d-6)
          Es10um=(h*c)/(kboltz*Tstar*10.d-6)
          Ep3um=(h*c)/(kboltz*Tplanet*3.d-6)
          Es3um=(h*c)/(kboltz*Tstar*3.d-6)
          Ep1um=(h*c)/(kboltz*Tplanet*1.d-6)
          Es1um=(h*c)/(kboltz*Tstar*1.d-6)
          Ep05um=(h*c)/(kboltz*Tplanet*5.d-7)
          Es05um=(h*c)/(kboltz*Tstar*5.d-7)
          Rpls = (Rplnt*Rplnt)/(Rs*Rs)
          
c  Convert to Cartesian coordinates and print time, position, 
c  orbital velocity (in kilometers per second), effective
c  planetary temperature (in Kelvins), and planet-to-star flux
c  ratios for wavelengths of 0.5, 1, 3, and 10 micrometers.
c  Also print last point to close ellipse 
          if (k.eq.1 .or. i.eq.n) then
          Fr05um=(Rpls)*((exp(Es05um)-1)/(exp(Ep05um)-1.))
          Fr1um=(Rpls)*((exp(Es1um)-1.)/(exp(Ep1um)-1.))
          Fr3um=(Rpls)*((exp(Es3um)-1.)/(exp(Ep3um)-1.))
          Fr10um=(Rpls)*((exp(Es10um)-1)/(exp(Ep10um)-1.))
          Tplanet=((emis)**0.25)*((Rscm/(2.*r))**(0.5))*Tstar
          vrkm = vr/100000.
          rau = r/AU
          y = r*sin(theta)/AU
          x = r*cos(theta)/AU
          phase = tyears/Pyears
          tyears = time/spyr
          write(10,300) tyears,phase,x,y,rau,vrkm,Tplanet,Fr10um,
     1 Fr3um,Fr1um,Fr05um      
          end if
c  calculate the angular momentum per unit mass L/m 
          LoM=sqrt(G*Mstar*a*(1.0d0-e**2.))*(Mstar/(Mplanet+Mstar))
c  calculate the next value of theta by using Kepler's second law
          dtheta = LoM/r**2.*dt
          theta = theta + dtheta
c  update the elapsed time
          time = time + dt
c  check print counter then return to the top of the loop
          if (k.eq.kmax) k = 0
   10 continue
      write(*,*) ' '
      write(*,*) ' The calculation is finished and listed in ',
     1  'orbits.dat'
      write(*,*) 'The IDL program plots_orbits.pro will now ',
     1  'generate four plots: orbital speed vs. orbital phase, ',
     1  'planet temperature vs. orbital phase, and planet-to- ',
     1  'star flux ratios vs orbital phase at wavelengths of ',
     1  '0.5,1,3, and 10 micrometers. Displays of orbital ',
     1  'parameters and a legend for the planet-to-star flux ',
     1  'ratios plot will also be generated.' 
      write(*,*) ' '
      stop ' '
c  Formats
c  Note that through the 'format' statement, we can specify how
c  many columns a number should take up, and, where appropriate,
c  where a decimal point should lie. The 'format' statement has
c  a label associated with it; through this label, the 'write'
c  statement associates the data to be written with the form in 
c  which to write it. The 'x's in the 'format' statements below
c  are used for generating spaces in the output, and the 'f's are
c  used for printing out real numbers. The form of the 'f' format
c  specifies where the decimal point will occur, and how many digits
c  follow it. Thus, f10.3 means that there are 3 digits after the
c  decimal point, in a total field width of 10 digits. Since the 
c  decimal point is also written out, there may be up to 6 digits 
c  before the decimal point. Also, any minus sign is part of the 
c  number, and would take up one column.
c
c  '25x' indicates that a (blank) space is repeated 25 times, and '1x'
c  indicates that a single space is being left.
c
 100  format(1x,25x,'The period of this orbit is ',f10.3,' years')
 200  format(1x, 25x,'Elliptical Orbit',//,   
      1 21x,'Mass of Star = ',f10.3,' Msun',/,
      2 21x,'Mass of Planet =',f10.3,' Mjupiter',/,  
      3 21x ,'a = Semimajor Axis = ',f10.3,' AU',/,
      4 21x,'P = Period = ',f10.3,' yr',/,
      5 21x,'e = Eccentricity = ',f11.4,/,
      6 21x,'Temperature of Star = ',f10.3,' Kelvin',/,
      7 21x,'Radius of Star = ',f10.3,' Rsun',/,
      8 21x,'Emissivity of Planet = ',f10.3,/,
      1 21x,'Radius of Planet = ',f10.3,' Rjupiter',/,
      2 21x,'Orbital Inclination = ',f10.3,' degrees',/,
      3 21x,'Angle of Major Axis wrt l.o.s. = ',f10.3,' deg.',///,  
      4 2x,'t(yr)',5x,'phase',3x,' x(AU)',2x,' y(AU)',3x,'r(AU)', 
      5 4x,'vr(km/s)',1x,'Tplanet(K)',2x,'F.R.(10um)',
      6 5x,'F.R.(3um)',7x,'F.R.(1um)',8x,'F.R.(0.5um)')
  300 format(1x,f6.3,4x,f6.3,2x,f7.3,2x,f6.3,2x,f6.3,1x,f9.3,1x,
     1 f9.3,3x,f11.10,3x,f14.13,3x,f14.13,3x,f14.13)
      end

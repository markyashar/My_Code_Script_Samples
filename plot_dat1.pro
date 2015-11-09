PRO plot_dat1
device,retain=2,pseudo=8,decomposed=0
;The following two lines compile and execute a procedure named
;'loadcolors.pro' from pages 249-250 of the book "Practical
; IDL Programming" by Liam E. Gumley ; Copyright 2002 by
; Academic Press. This procedure loads 16 plotting colors into
; the color table. The colors are loaded starting at index 0
; by default, or at the index specified by the 'bottom' keyword.
; The names of the colors can be returned by the 'names' keyword.
; The loadcolors.pro code (procedure) must be in the same 
; directory as the 'orbits.f' and 'plots_orbits.pro' programs
; are in order for the overall program/code to be successfully
; compiled and executed
loadcolors 
; The 'orbits.f' Fortran 77 program is 'spawned' (i.e., it is
; compiled and executed) here within the IDL environment 
;spawn, 'g77 orbit2.f'
;spawn, './a.out'
OPENR,lun,'orbit.dat',/GET_LUN
header=STRARR(16)
READF,lun,header
time=FLTARR(10000)
phase=FLTARR(10000)
xpos=FLTARR(10000)
ypos=FLTARR(10000)
radius=FLTARR(10000)
velocity=FLTARR(10000)
temp=FLTARR(10000)
fluxr10=FLTARR(10000)
fluxr3=FLTARR(10000)
fluxr1=FLTARR(10000)
fluxr05=FLTARR(10000)
t=0.0
p=0.0
x=0.0
y=0.0
r=0.0
v=0.0
te=0.0
fr10=0.0
fr3=0.0
fr1=0.0
fr05=0.0
count=0
WHILE (NOT EOF(lun)) DO BEGIN
READF, lun, t,p,x,y,r,v,te,fr10,fr3,fr1,fr05
time(count)=t
phase(count)=p
xpos(count)=x
ypos(count)=y
radius(count)=r
velocity(count)=v
temp(count)=te
fluxr10(count)=fr10
fluxr3(count)=fr3
fluxr1(count)=fr1
fluxr05(count)=fr05
count = count + 1
ENDWHILE
time = time(0:count-1)
phase=phase(0:count-1)
xpos=xpos(0:count-1)
ypos=ypos(0:count-1)
radius=radius(0:count-1)
velocity=velocity(0:count-1)
temp=temp(0:count-1)
fluxr10=fluxr10(0:count-1)
fluxr3=fluxr3(0:count-1)
fluxr1=fluxr1(0:count-1)
fluxr05=fluxr05(0:count-1)
close, lun
window, 0, xsize=890,ysize=740
!p.multi=[0,2,2]
plot, xpos, ypos, linestyle=2, $
title='X (AU)  vs.  Y(AU)', $
xtitle='X in AU',  $
ytitle='Y in AU'
plot, phase, velocity, psym=4,/noclip, $
title='Plot of Orbital Speed  vs.  Orbital Phase', $
xtitle='Orbital Phase (elapsed time/orbital period)',xcharsize=1.0,  $
ytitle='Orbital speed in km/s'
amax=max(temp)
amin=min(temp)
if (amin ge 280.) and (amax le 320.) then begin
plot, phase,temp, psym=6,color=4, $
title='Planet Temperature (K) vs Orbital Phase', $
xtitle='Orbital Phase (time elapsed / orbital period)', $
ytitle='Temperature (K) of Extra-Solar Planet'
xyouts, 0.08,0.25,'!6THIS PLANET LIES IN THE HABITABLE ZONE OF ITS PARENT STAR!X', /normal, charsize=1.0,color=4
xyouts, 0.08,0.21,'!6(Its temperature varies between 280K and 320K, where water!X', /normal, charsize=1.02,color=4
xyouts, 0.08,0.19,'!6can exist in liquid form, as it moves through its orbit)!X', /normal, charsize=1.02,color=4
goto, jump1
endif
plot, phase,temp, psym=6, $
title='Planet Temperature (K) vs Orbital Phase', $
xtitle='Orbital Phase (time elapsed / orbital period)', $
ytitle='Temperature (K) of Extra-Solar Planet'
jump1: ymax=max(fluxr10)
foo=[fluxr10,fluxr3,fluxr1,fluxr05]
gd=where(foo gt 0.)
ymin=min(foo[gd])
plot, phase,fluxr10,yrange=[ymin,ymax],/ylog, linestyle=2,/noerase,  $
title='Planet to Star Flux Ratios vs Orbital Phase',   $
xtitle='Orbital Phase (time elapsed / orbital period)',   $
ytitle='Planet to Star Flux Ratios vs Orbital Phase'
oplot, phase,fluxr3, linestyle=3, color=5
oplot, phase,fluxr1,linestyle=4, color=6
oplot, phase,fluxr05,linestyle=5, color=9
window, 1, xsize=470, ysize=350
xyouts,0.0,0.95,'!6Orbital Parameters:!X', /normal, charsize=1.5,color=2, $
alignment=0.0
xyouts,0.0,0.90,header(0), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.86, header(2), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.82, header(3), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.78, header(4), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.74, header(5), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.70, header(6), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.66, header(11), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.62, header(12), /normal, alignment=0.0, charsize=1.3, color=2
xyouts,0.0,0.55,'!6Star and Planet Properties:!X', /normal, charsize=1.5, $
color=15, alignment=0.0
xyouts,0.0,0.50, header(7), /normal, alignment=0.0, charsize=1.3,color=15 
xyouts,0.0,0.46, header(8), /normal, alignment=0.0, charsize=1.3,color=15
xyouts,0.0,0.42, header(9), /normal, alignment=0.0, charsize=1.3,color=15
xyouts,0.0,0.38, header(10), /normal, alignment=0.0, charsize=1.3,color=15
window,2,ysize=300
xyouts,0.0,0.95,'!6Legend for the Plot of Planet to Star Flux Ratios vs Orbital Phase!X', $
/normal, charsize=1.5,color=14
xyouts,0.0,0.87,'----------  Planet to Star Flux Ratio at wavelength = 10 microns (dashed ; white)', $ 
/normal, alignment=0.0, charsize=1.3
xyouts,0.0,0.81,'-.-.-.-.-.-.-.  Planet to Star Flux Ratio at wavelength = 3 microns (dash/dot ; red)',$ 
/normal, alignment=0.0, charsize=1.3, color=5
xyouts,0.0,0.75, '-...-...-...-...  Planet to Star Flux Ratio at wavelength = 1 micron  (dash/dot/dot/dot ; blue)',$ 
/normal, alignment=0.0, charsize=1.3, color=6
xyouts,0.0,0.69, '_ _ _ _ _ _ _ _ Planet to Star Flux Ratio at wavelength = 0.5 micron (long dashes ; gold)',$ 
/normal, alignment=0.0, charsize=1.3, color=9
; Creates postscript versions of these plots in a file called
; 'orbits_plots.ps' in the current directory
mydevice=!D.NAME
SET_PLOT, 'PS'
DEVICE, FILENAME = 'orbits_plots.ps', /LANDSCAPE
!p.multi=[0,2,2]
plot, xpos, ypos, linestyle=2, $
title='X (AU)  vs.  Y(AU)', $
xtitle='X in AU',  $
ytitle='Y in AU'
plot, phase, velocity, psym=4, $
title='Plot of Orbital Speed  vs.  Orbital Phase', $
xtitle='Orbital Phase (elapsed time/orbital period)',xcharsize=1.0,  $
ytitle='Orbital speed in km/s'
plot, phase,temp, psym=6, $
title='Planet Temperature (K) vs Orbital Phase', $
xtitle='Orbital Phase (time elapsed / orbital period)', $
ytitle='Temperature (K) of Extra-Solar Planet'
foo=[fluxr10,fluxr3,fluxr1,fluxr05]
gd=where(foo gt 0.)
ymin=min(foo[gd])
plot, phase,fluxr10,yrange=[ymin,ymax],/ylog, linestyle=2,/noerase,  $
title='Planet to Star Flux Ratios vs Orbital Phase',   $
xtitle='Orbital Phase (time elapsed / orbital period)',   $
ytitle='Planet to Star Flux Ratios vs Orbital Phase'
oplot, phase,fluxr3, linestyle=3, color=5
oplot, phase,fluxr1,linestyle=4, color=6
oplot, phase,fluxr05,linestyle=5, color=9
DEVICE, /CLOSE
SET_PLOT, mydevice
spawn, 'more orbit.dat'
; Note that the postscript plots can be displayed and viewed by
; typing in '$gv orbits_plot.ps &' at the IDL command prompt
END

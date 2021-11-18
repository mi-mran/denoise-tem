// Script to create and position an

// ROI on the foremost image with defined size and position

 

// D. R. G. Mitchell, adminnospam@dmscripting.com (remove the nospam to make this email address work)

 

// v1.0, March 2004

 

// version:20040301

 

// Variables

 

number width, height, top, left, bottom, right, roiwidth, roiheight

number scalex, scaley

roi theroi

string buttonstring

 

Image front:=getfrontimage()

imagedisplay imgdisp=front.imagegetimagedisplay(0)

 

getscale(front, scalex, scaley)

string imagename=getname(front)

 

string unitstring=getunitstring(front)

if(unitstring=="") buttonstring="Units"

else buttonstring=unitstring

 

number roinumber=imgdisp.imagedisplaycountrois()

 

// If no ROI is present in the image then one is created and added

 

if(roinumber<1)

{

 

//if(twobuttondialog("Do you want to work in pixels or calibrated units?","Pixels", buttonstring)) unitstring="Pixels"

// Get the ROI paramaters from the user

 

//if(!getnumber("Enter the width of the ROI in "+unitstring,0,width)) exit(0)

//if(!getnumber("Enter the heightof the ROI in "+unitstring,0,height)) exit(0)

//if(!getnumber("Enter the Top (Y) coordinate of the ROI in "+unitstring,0,top)) exit(0)

//if(!getnumber("Enter the Left (X) coordinate of the ROI in "+unitstring,0,left)) exit(0)

// for tem_video

// for left crop
//top=1578
//left=165
//width=512
//height=512

// for bottom crop
top=3472.79
left=1928.47
width=1024
height=1024

// for temp_range

// for left crop
//top=1048.57
//left=85.52
//width=512
//height=512

//  for centre crop
//top=2117.88
//left=1414.61
//width=256
//height=256

result("\nROI added to image : "+imagename+"\n")

result("ROI Width = "+width+" "+unitstring+", Height = "+height+" "+unitstring+"\n")

result("ROI Position : Top (Y) = "+top+" "+unitstring+", Left (X) = "+left+" " +unitstring+"\n")

 

// If the user has supplied ROI parameters in calibrated units, then these are converted to pixels

 

//if(unitstring!="Pixels")

//{

//width=width/scalex

//height=height/scaley

//top=top/scaley

//left=left/scalex

//}

 

// The ROI is added

 

showimage(Front)

theroi=newroi()

imagedisplayaddroi(imgdisp, theroi)

roisetrectangle(theroi, top, left, (top+height), (left+width))

imagedisplaysetroiselected(imgdisp, theroi, 1)

 

exit(0)

}

 

else

{

 

// If an ROI is already present, then its dimensions are displayed and the user can modify it

// provided it is a rectangular ROI

 

showimage(front)

theroi=imagedisplaygetroi(imgdisp,0)

 

if(!roiisrectangle(theroi))

{

beep()

okdialog("A Rectangular Region of Interest (ROI) must be present for this script to work!")

exit(0)

}

 

 

// Source the ROI dimensions and display them in both pixels and units

 

roigetrectangle(theroi, top, left, bottom, right)

roiwidth=right-left

roiheight=bottom-top

 

result("\nAn ROI is already present in "+imagename+"\nROI width = "+roiwidth+" pixels ("+(roiwidth*scalex)+" "+unitstring+")\nROIheight= "+roiheight+" pixels ("+(roiheight*scaley)+" "+unitstring+")\nTop (Y) = "+top+" pixels ("+(top*scaley)+ " "+unitstring+") \nLeft (X) ="+left+" pixels ("+(left*scalex)+" "+unitstring+")\n")

if(twobuttondialog("An ROI is already present in "+imagename+"\nROI width = "+roiwidth+" pixels ("+(roiwidth*scalex)+""+unitstring+")\nROI height= "+roiheight+" pixels ("+(roiheight*scaley)+" "+unitstring+")\nTop (Y) = "+top+" pixels ("+(top*scaley)+ ""+unitstring+") \nLeft (X) = "+left+" pixels ("+(left*scalex)+" "+unitstring+")","OK", "Modify ROI")) exit(0)

if(twobuttondialog("Do you want to work in pixels or calibrated units?","Pixels", buttonstring))

{

unitstring="Pixels"

}

else

{

// If the user is supplying parameters in units, these are converted into pixels

 

getunitstring(front, unitstring)

roiwidth=roiwidth*scalex

roiheight=roiheight*scaley

top=top*scaley

left=left*scalex

}

// The user supplies the new parameters, the defaults are the existing ROI parameters

// displayed in either pixels or units as appropriate

if(!getnumber("Enter the width of the ROI in "+unitstring,roiwidth,roiwidth)) exit(0)

if(!getnumber("Enter the height of the ROI in "+unitstring,roiheight, roiheight)) exit(0)

if(!getnumber("Enter the Top (Y) coordinate of the ROI in "+unitstring,top,top)) exit(0)

if(!getnumber("Enter the Left (X) coordinate of the ROI in "+unitstring, left,left)) exit(0)

 

}

 

 

// The reults of the change are written into the results window

 

result("\nROI modified in image : "+imagename+"\n")

result("ROI Width = "+roiwidth+" "+unitstring+", Height = "+roiheight+" "+unitstring+"\n")

result("ROI Position : Top (Y) = "+top+" "+unitstring+", Left (X) = "+left+" " +unitstring+"\n")

 

 

// If working in units then the ROI parameters are converted back into pixel values for setting the modified ROI

 

if(unitstring!="Pixels")

{

roiwidth=roiwidth/scalex

roiheight=roiheight/scaley

top=top/scaley

left=left/scalex

}

 

 

// The ROI is modified

 

showimage(Front)

roisetrectangle(theroi, top, left, (top+roiheight), (left+roiwidth))

imagedisplaysetroiselected(imgdisp, theroi, 1)
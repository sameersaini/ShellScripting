#!/bin/sh

file=$HOME/bin/fname
tempfile=/$HOME/bin/$file.$$
pause()
{
echo -n Press ENTER to continue:
read junk
}
yesno()
{
while true
do
	echo -n "$* ? (Y/N)"
	read ans junk
	case $ans in 
	y|Y|yes|Yes|YES|YEs)
		return 0
	;;
	n|n|no|No|NO)
		return 1
	;;	
	*)
		echo please enter yes or no
	;;
	esac
done
}

docreate()
{
  while true
  do

	while true
	do
	clear
	echo "Enter the following Records"
	echo -n " Enter your First name : "; read name
	echo -n "               Surname : "; read surname
	echo -n " 		   City : "; read city
	echo -n "	          State : "; read state
	echo -n "		    Zip : "; read zip
 	clear

	echo "You have entered the following details :"
	echo
	echo "  Given Name : $name"
	echo "     Surname : $surname"
	echo "        City : $city"
	echo "       State : $state"
	echo "         Zip : $zip"
	echo
	 if yesno Are these Records correct
	then
	  echo $name:$surname:$city:$state:$zip >> $file
	  echo
	  echo  SAVING RECORD
	  sleep 2
		break
	fi
	done
    yesno Do you want to create a new record || break
done
}

doview()
{
 
echo The database cotains Followong Records
	echo ==================================================================
#DISPLAYING RECORDS
	echo "Firstname      Surname        City           State	    Zip"
	echo ==================================================================
        awk -F : '{printf("%-15s%-15s%-15s%-15s%-15s\n",$1,$2,$3,$4,$5)}' $file | more
	echo
	echo  Database has TOTAL `cat $file | wc -l` Records
	echo
}

dosearch()
{
 echo -n Enter the contact name you want to search... ; read string
 grep "$string" $file > /dev/null
 if [ $? -eq 0 ]
 then
	echo "Firstname      Surname        City           State	    Zip"
	echo ==================================================================
	grep "$string" $file | awk -F : '{printf("%-15s%-15s%-15s%-15s%-15s\n",$1,$2,$3,$4,$5)}'
	return 0
 else
	echo No matching records
	return 1
 fi
}
dodelete()
{
  dosearch && yesno Do you want to delete this record || return
  if [ "$string" = "" ]
  then
	( yesno Delete all the records && > $file ) && echo All records have been deleted....
	
  else
	sed "/$string/d" $file > $tempfile
	mv $tempfile $file
	echo "All the records containing \"$string\" in file \"$file\" has been deleted"
 fi
}


[ ! -f $file ] && > $file

while true
do
clear
echo  "\n\t\tSHELL PROGRAMMING DATABASE"
echo  "\t\t\tMAIN MENU "
echo
echo  " \t\t1. Enter a records"
echo  " \t\t2. View ecords in Database "
echo  " \t\t3. Search a Record "
echo  " \t\t4. Delete a Record "
echo  " \t\t5. Quit"
echo -n "Enter your Choice:  "

read ans 


[ "$ans" = "" ] && continue

case $ans in 
	1)
	  docreate ;;
	2)
	  doview ;;
	3)
	  dosearch ;;
	4)
	  dodelete ;;
	5)
	  yesno Do you really want to quit && break
	;; 
esac
pause
done

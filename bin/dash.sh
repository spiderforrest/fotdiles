#!/bin/bash

# scope: script that loops, tracking time, distance, location, etc. of deliveries
# on start: ask for current milage, location, and mark time etc
# in loop: take how far it is and then how much i made. timestamping. give feedback(wage, etc) and encouragement ig

# out of scope: import results into spreadsheet, hooked to google assistant so i can just yell at it while i drive, and tie in with gps to figure out where i pick things up and all that shit


# definitions
log="/home/spider/dashTemplate"
tmp="/home/spider/dashTmp"
deliveryIndexNum=0
# check if exited wrong last time
if [ -f "$tmp" ]; then
	echo "shit, didn't exit right last time. check $tmp, that's got your last run's (incomplete)log, i won't run til that's gone"
	exit
fi
touch $tmp

# prelim questions
echo -e "damn daniel back at it again with your shit fucking excuse for a job go make money \nanyway current car milage?" 
read startMilage
echo "and what zone?"
read startLocation
echo "starting at $(date -u +"%H:%M"), you've done $(tac $log | grep -B1 "index" | head -n 1) runs, gl luv"
startTime=$(date +%s)

# write that info down in case program doesn't end correctly:
echo "$startTime ($startLocation) [$startMilage]" >> $tmp

# main loop
while :; 
do
	echo -e "you've done $deliveryIndexNum deliveries in this run so far.\nnext delivery's distance, or 'done' to end this shit. or switch zones or whatever."
	read mainInput
	# dash end code
	if [ $mainInput = 'done' ]; then
		echo "Whatcha milage at now?"
		read endMilage
		milage=$(($endMilage - $startMilage))
		echo $milage
		echo "cool, you worked for $(date -ud "@$(($(date +%s) - $startTime))" +%T)"
		# calculate $/h and shit
		#tail -n +2 $tmp >> $log
		exit
	fi
	# main delivery loop
	deliveryIndexNum=$(tac $tmp | grep -B1 "#" | head -n 1) # gets last delivery number
	deliveryIndexNum=$(($deliveryIndexNum + 1))
	deliveryStartTime=$(date +%T)
	# truncate $mainInput
	echo -e "#\n$deliveryIndexNum\nstart\n$(date +%T)\ndistance\n$mainInput" >> $tmp
	echo -e "whenever you're done, enter how much of thy daily bread you got, and optionally flags(stops, y/n post-tip)"
	read mainInput
	echo -e "end\n$(date +%T)\nelapsed\n$(date -ud "@$(($(date +%T) - $deliveryStartTime))" +%T)"
done

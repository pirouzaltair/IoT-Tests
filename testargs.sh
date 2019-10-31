#!/bin/bash
######################################################
#variables modified by user:
#THRESHOLD: Max quantity of reports per collection
#MAX_AGE: Max age for report (in days)
######################################################
THRESHOLD=""                                   # Max number of reports per collection.
MAX_AGE=1                                      # Max age for a report.

usage() {                                      # Function: Print a help message.
  echo "Usage: $0 [ -n THRESHOLD ] [ -t MAX_AGE ]" 1>&2
}
exit_abnormal() {                              # Function: Exit with error.
  usage
  exit 1
}
while getopts ":n:t:" options; do              # Loop: Get the next option;
                                               # use silent error checking;
                                               # options n and t take arguments.
  case "${options}" in
    n)                                         # If the option is n,
      THRESHOLD=${OPTARG}                      # set $THRESHOLD to specified value.
      ;;
    t)                                         # If the option is t,
      MAX_AGE=${OPTARG}                        # Set $MAX_AGE to specified value.
      re_isanum='^[0-9]+$'                     # Regex: match whole numbers only
      if ! [[ $MAX_AGE =~ $re_isanum ]] ; then # if $MAX_AGE not a whole number:
        echo "Error: MAX_AGE must be a positive, whole number."
        exit_abnormally
        exit 1
      elif [ $MAX_AGE -eq "0" ]; then          # If it's zero:
        echo "Error: MAX_AGE must be greater than zero."
        exit_abnormal                          # Exit abnormally.
      fi
      ;;
    :)                                         # If expected argument omitted:
      echo "Error: -${OPTARG} requires an argument."
      exit_abnormal                            # Exit abnormally.
      ;;
    *)                                         # If unknown (any other) option:
      exit_abnormal                            # Exit abnormally.
      ;;
  esac
done

#remove files > the set maximum age (in days)
find newman -type f -mmin -$((60*24*$MAX_AGE)) -exec ls -halt {} +

# NUM_COLLECTIONS: quantity of collections in collections directory
# CURRENT_NUM_REPORTS: quantity of reports in newman directory
# NUM_REPORTS_PER_COLLECTION: quantity of reports per collection
# GCM: not in use.
NUM_COLLECTIONS=$(ls -1 collections | wc -l)
CURRENT_NUM_REPORTS=$(ls -1 newman | wc -l)
NUM_REPORTS_PER_COLLECTION=$(expr $CURRENT_NUM_REPORTS / $NUM_COLLECTIONS)
declare -i GCM=0
# echo
# echo The set threshold is $THRESHOLD reports per collection
# echo the set max age is $MAX_AGE days
# echo there are $NUM_COLLECTIONS collections
# echo there are $CURRENT_NUM_REPORTS reports
# echo there are $NUM_REPORTS_PER_COLLECTION reports per collection
# echo

if test "$NUM_REPORTS_PER_COLLECTION" -gt "$THRESHOLD"  #if there are more reports-per-collection than desired
then                                                    #find greatest common multiple
  z=$(expr $NUM_COLLECTIONS - $THRESHOLD)
  y=$(expr $NUM_COLLECTIONS \* $z)
  x=$(expr $CURRENT_NUM_REPORTS - $y )
  showback=$(expr $x / $NUM_COLLECTIONS )
  n=$(expr $x)
  num_to_delete=$(expr $n \* -1 )
  num_to_delete=$(expr $num_to_delete - 1 )

  # echo n is $showback and there should be $num_to_delete files removed
  # num_to_delete=$(expr $CURRENT_NUM_REPORTS - $n )
  # num_to_delete=$(expr $num_to_delete \* -1)

  ls newman -t | cat | head $num_to_delete | xargs -I{} mv newman/{} deletefile
  rm deletefile

  # for (( i=CURRENT_NUM_REPORTS; i>=1; i-- ))
  # do
  #   REM=$(( $CURRENT_NUM_REPORTS % i ))
  #   declare -i TARGET_REM=0
  #   if [ $REM -eq $TARGET_REM ]
  #   then
  #     # echo remainder is $(( $CURRENT_NUM_REPORTS % $i ))
  #     # echo remainder is $REM
  #     GCM=$(expr $i + 0)
  #     echo FOUND GCM $i
  #     echo So there should only be like 2 reports left
  #     break
  #   fi
  # done
fi

# echo
# echo remaining reports:
# echo
# ls -l newman
# echo

unset z
unset y
unset x
unset n
unset showback
unset num_to_delete
unset NUM_COLLECTIONS
unset THRESHOLD
unset MAX_AGE
unset GCM
unset CURRENT_NUM_REPORTS
unset NUM_REPORTS_PER_COLLECTION
exit 0

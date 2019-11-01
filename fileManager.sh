#!/bin/bash
######################################################
#variables modified by user:
#THRESHOLD: Max quantity of reports per collection
#MAX_AGE: Max age for report (in days)
######################################################
THRESHOLD=""                                   # Max number of reports per collection.
MAX_AGE=1                                      # Max age for a report.

usage() {                                      # Function: Print a help message.
  echo "Usage: $0 [ -l LIMIT ] [ -d DAYS_OLD ]" 1>&2
}
exit_abnormal() {                              # Function: Exit with error.
  usage
  exit 1
}
while getopts ":l:d:" options; do              # Loop: Get the next option;
                                               # use silent error checking;
                                               # options l and d take arguments.
  case "${options}" in
    l)                                         # If the option is l,
      THRESHOLD=${OPTARG}                      # set $THRESHOLD to specified value.
      ;;
    d)                                         # If the option is d,
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
# find newman -type f -mmin +$((60*24*$MAX_AGE)) -exec ls -halt {} +
find newman -type f -mmin +$((60*24*$MAX_AGE)) -exec rm -f {} +
echo reports removed after trimming off desired reports by age:
find newman -type f -mmin +$((60*24)) -exec ls -halt {} + | wc -l ;
echo they are:
find newman -type f -mmin +$((60*24)) -exec ls -halt {} +

# NUM_COLLECTIONS: quantity of collections in collections directory
# CURRENT_NUM_REPORTS: quantity of reports in newman directory
# NUM_REPORTS_PER_COLLECTION: quantity of reports per collection
# GCM: not in use.
NUM_COLLECTIONS=$(ls -1 collections | wc -l)
CURRENT_NUM_REPORTS=$(ls -1 newman | wc -l)
NUM_REPORTS_PER_COLLECTION=$(expr $CURRENT_NUM_REPORTS / $NUM_COLLECTIONS)
# declare -i GCM=0
echo
echo The set threshold is $THRESHOLD reports per collection
echo the set max age is $MAX_AGE days
echo there are $NUM_COLLECTIONS collections
echo there are $CURRENT_NUM_REPORTS reports
echo there are $NUM_REPORTS_PER_COLLECTION reports per collection
echo
#if there are more reports-per-collection than desired
if test "$NUM_REPORTS_PER_COLLECTION" -gt "$THRESHOLD"
then
# if r is odd then made it even
  is_even=$(( $CURRENT_NUM_REPORTS % 2 ))
  if [ $is_even -eq 0 ]
  then
    let CURRENT_NUM_REPORTS+=1
  fi

  # if r = number of existing reports,
  # c is the number of collections,
  # and n is the arg passed:
  # r - cn = num of reports remaining
  # cn = num of reports to remove
  cn=$(expr $NUM_COLLECTIONS \* $THRESHOLD)
  r=$(expr $CURRENT_NUM_REPORTS)
  fn=$(expr $r - $cn)
  num_to_delete=$(expr $fn \* -1 )
  let num_to_delete+=1
  echo $num_to_delete files should be remove and there should be $cn files remaining
  ls -t -r newman | cat | head $num_to_delete | xargs -I{} mv newman/{} deletefile
  rm deletefile
fi

echo
echo remaining reports:
echo
ls -lt newman
echo

unset c
unset r
unset n
unset cn
unset is_even
unset num_to_delete
unset NUM_COLLECTIONS
unset THRESHOLD
unset MAX_AGE
unset GCM
unset CURRENT_NUM_REPORTS
unset NUM_REPORTS_PER_COLLECTION
exit 0

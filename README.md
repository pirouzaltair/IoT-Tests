# IoT-Tests
Repo for all QA tests pointing to IoT.

As of now, documentation consists of a record for the logic which will be implemented to manage the dynamic size of our reports directory.


In order to manage the dynamic size of our repo I'm finishing up a shell script that will execute one of two behaviors:

1. remove all reports older than a given date.

2. keep only a certain number of reports... I think explaining the logic to be applied in this scenario reveals the importance of file management.
This situation might not occur frequently but might during times of heavy postman testing and test generation:

Say that a Jenkins job which runs daily runs 7 collections; then we have 7 collections per week.
By EOW we'd have 49 reports and that's a number to note. Cleanup should clearly be automated if this were ever to be the case.

* Let r = total reports currently occupying server space.
* Let c = # collections in job.
* Let n = number of reports you want to keep per collection.
* Removal of reports is always done in descending order by age (oldest first).

Say also that you only want the most recent report.
Call application of this logic f:

f(n) = (r - c*(c-n))

n = (r - c*(c-n))/c

1 = (49 - 7*6)/7 = (49 - 42)/7 = 7/7

Removing c*(c-n) = 7*6 = 42 reports.
Leaves r - c*(c-n) = 49-42 = 7 reports.
This implies leaving only n = 1 report per collection.


3.) Keep a certain number of reports generated before a certain date.

Step 1: remove files > t weeks old
* Let t = the upper limit for the age of a test.
* Apply the cutoff time t: so the new number of reports currently existing
  is r' >= r

find newman -type f -mtime +{SOME NUMBER-1} -exec rm -f {} \;

Step 2: Remove all but n number of reports from r'

* let m be largest common multiple between r' and c.
  Trim r' to = k, so 0 < (k = c*m) <= r'

pseudocode:
___________________________________________
    bool foundFactor = false;
    for (int i = r'; i > 0; i--) {
      if (foundFactor = false && r'%c=0) {
        r' = i;
        foundFactor = true;
      }  
    }
___________________________________________

* Remove as many reports from r until r = r'

Step 3.) Compute f(n)

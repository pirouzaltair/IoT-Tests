# IoT-Tests
<br>
### An Altair API Testing Framework for the IoT cluster

## Contents

 * [Description](#description)
 * [Requires](#requires)
 * [Getting Started](#getting-started)
     * [fileManager](#using-file-manager)
	    * [Running with the CLI](#running-the-tool)
	    * [Arguments](#change-filemanager-settings)
     * [Using Jenkins](#using-Jenkins)
	    * [Build Script](#build-script)
	    * [Post-Build Script](#post-build-script)
    * [Managing Github Repo](#github)
	    * [Commits](#build-script)
	    * [Merging Pull Requests](#pull-requests)
 * [Future Features](#future-features)
	 * [Better Data Management](#better-data-management)
	 * [CLI](#cli)
 * [Authors](#authors)

## Description
This repository consists of components which ultimately intended to be used by a Jenkins job, however it may be utilized as a CLI tool on a local machine if need be.
At its core, IoT-Tests uses the Altair SmartEdge API and Postman/Newman to:
* Run Postman tests against a specified cloud (IoT)
* Generate report HTML files for each test
* Manage the quantity and lifespan of test reports.

## Requires

IoT-Tests uses a number of open source projects to work properly. Thanks to @dannydainton, a visually appealing extionsion of newman-html-reports is available for us to utilize. It is assumed that you have Postman installed locally. If you do not have Newman installed, follow the installation guidelines as listed in the link below:
* [Node]
* [NPM]
* [Python 3.5]
* [Postman]
* [Newman]
* [Breakdance](http://breakdance.io) - HTML to Markdown converter
* [~superagent-throttle~](https://www.npmjs.com/package/superagent-throttle)- superagent throttle library _(to be used in future iterations)_

## Getting Started

It is assumed that you have Postman installed locally. If you do not have Newman installed, follow the installation guidelines as listed on the Postman blog:
Once you have the entire repository downloaded, simply cd into the `IoT-Tests` directory:
```
cd IoT-Tests
```
...then run:
```
python runCollections.py
```

## Using fileManager

fileManager.sh is a shell script which affords a hands-off approach to organizing an ever-changing flow of test reports. The script enforces a lifespan for all reports as well as a maximum quantity of reports retained per-test. As the quantity of reports are housed within the `newman` file may be ever-growing and proportional to the quantity of tests, manual file management _should_ be automated; configure the usage of this script as so:

sh filemanager.sh [ -n A NUMERIC LIMIT ON REPORTS-PER-TEST ] [ -t MAX LIFESPAN IN DAYS ]" 1>&2

Say that in some case you maintain a Jenkins job which builds once every workday and runs 50 tests- you would have 250 collections per work week if you leave your `newman` directory untouched. You have two ways to manage the quantity of reports at any given time:

1. Retain only reports younger than _t_ days old.

2. Retain only a certain number of reports per-test/Postman collection.

3. The conjunction of both conditions: Retain only reports younger than _t_ days old _AND_ retain a maximum of _n_ reports-per-collection.

An explanation of how files are managed is as so:

* _Removal of reports is always done in descending order by age (oldest first)._
* _Let r be total quantity reports in `newman` directory._
* Let c be the total quantity of collections in `collections` directory._
* _Let n be the total quantity of reports you want to keep per collection._
* _Let t be maximum age of a desired report, in days._
* _Let _f(n)_ be a function which represents the application of our logic onto n._


_f(n) = r - c * n = number of reports to remove._


Say also that you only want the most recent report, so let _n = 1:_


_f(1) = 500 - 50 * 1 = 450_

450 report files will be removed, leaving 50 reports in `newman`. Since each time runCollections.py is run 50 reports are produced and reports are removed after having been sorted by age in descending order, the only tests remaining would be all of the tests from the most recent run.

If a cutoff date of 1 day is to be applied, then the first operation to be conducted would be the removal of all reports older than 24 hours. If use this script on the last day of the week, all reports from Monday to Thursday would be removed, or 450 removals leaving only 50 of the most recent reports. In this case _r = 50_, and:

_f(1) = 50 - 50 * 1 = 0_

_0_ reports will be removed.

### Running With the CLI

To get started, cd into the `IoT-Tests` directory:
```
cd IoT-Tests
```
...then run:

```
sh filemanager.sh -n {A NUMERIC LIMIT ON REPORTS-PER-TEST} -t {MAX LIFESPAN IN DAYS}
```

Under the hood, each Postman collections is run and a corresponding Newman report is produced. A shell script is then invoked which acts as a garbage collection utility, removing reports to maintain a provided limit and enforce a lifespan.

### Future Features
Ideally the CLI would be refactored to provide options for invoking any suite of tests and their respective reports followed by a proverbial garbage run. Current plans are to add support for mustache files and handlebars.js for more custimizeable Postman reporting.

#### Better Data Management

A single removeDeviceCds backup and no prompted control over backups is... less than ideal.
A perfect design would allow for a complete history of adds, deletes, and errors.
Again, I leave this as a challenge to a future developer (or me, if we ever find the time).

## Acknowledgements
A special thanks to @brents for making himself available while I learn the ins and outs of CI/CD processes, and to @dannydainton for his artful appendation to the postman html reporting tool, newman report htmlextra.
I'm always appreciative of @hlipsig for enabling me to leverage my curiosity and penchant for automation to the benefit of our team, and @vmartin for her excellent documentation skills and contagious air of encouragement.  

## Author
* [*Pirouz Mehmandoost*](https://github.com/pirouzaltair) - Software Test Engineer and former intern QA software developer. Author of the Device Cds download functionality for the Mahalo testing tool, and guidelines for QA API test design and report generation.

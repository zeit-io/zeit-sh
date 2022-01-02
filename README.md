# ZEIT.IO Shell Scripts for the TimeRecords API

This repository contains shell scripts which deal with the TimeRecords Endpoints from the [ZEIT.IO REST API](https://zeit.io/api-docs/index.html).
All scripts here have been initially created by [Christian Spanner](https://www.xing.com/profile/Christian_Spanner2/cv), a freelance IT expert from Munich. His work is highly appreciated! 

## Configuration

Before using any of the scripts, you should configure the project with your credentials. 
Fill in your credentials into the `config.sh` file. Credentials like your personal API Key, Project ID and Project Header.  

## Get TimeRecords 

If your `config.sh` is setup correctly, you can fetch the TimeRecords for the configured project and a given month like this: 

```
./get.sh 2021-12
```

The above command would fetch all the booked times from the configured project from the month of December in 2021. The response will be a JSON object. 

## Delete TimeRecords 

The time records of the configured project, from a given month can be deleted like this: 

```
./delete.sh 2022-01
```

The command above would delete all time records from the month January 2022. The response would look like this: 

```
{"message":"The time record was deleted successfully."}
```

## Create one TimeRecord 

A new time record can be created with the `put.sh` script, with this schema: 

```
./put.sh <YYYY-MM-DD> <START-TIME> <STOP-TIME> <PAUSE> <ACTIVITY> <COMMENT> 
```

START-TIME, STOP-TIME and PAUSE have to follow this pattern `HH:MM`. Here is an example: 

```
./put.sh 2022-01-02 09:00 12:00 00:00 'Development' 'Testing the put'
```

In case of success, the response will be `OK`.


## Upload a Timesheet

If you have a txt/csv timesheet based on a template from https://www.cherokey.de/StundenzettelProjektsteuerung.xlsx, then you can 
upload the file to ZEIT.IO like this: 

```
./upload.sh Zeiterfassung.txt
```


## License 

The whole project is published under the MIT license. 

# ZEIT.IO Shell Scripts for the TimeRecords API

This repository contains shell scripts which deal with the TimeRecords Endpoints from the [ZEIT.IO REST API](https://zeit.io/api-docs/index.html).
All scripts here have been initially created by [Christian Spanner](https://www.xing.com/profile/Christian_Spanner2/cv), a freelance IT expert from Munich. His work is highly appreciated! 

# Configuration

Before using any of the scripts, you should configure the project with your credentials. 
Fill in your credentials into the `config.sh` file. Credentials like your personal API Key, Project ID and Project Header.  

# Get TimeRecords 

If your `config.sh` is setup correctly, you can fetch the TimeRecords for the configured project and a given month like this: 

```
./get.sh 2021-12
```

The above command would fetch all the booked times from the configured project from the month of December in 2021. 

# License 

The whole project is published under the MIT license. 

# (UNDER CONSTRUCTION - This sample and its instructions are under development)

# sample.edge-app-control

The application used in this sample is a simple SPL application that reads stock ticker entries from a file, does a simple calculation on them, and then writes them out to a file. It will continue doing this in a loop.

The objective of this sample is to illustrate the steps involved with developing an Streams Programming Language (SPL) application for the Edge.  It will start with the application SPL source code, proceed to the application build process, followed by deployment (including configuration) to the edge nodes, and finish with examining the runtime output.  

There are two ways of managing the edge application deployment lifecycles.

1. Using built-in edge deployment support in Cloud Pak for Data (CP4D)
1. Using an instance of the IBM Edge Application Manager (IEAM)
    
This sample will demonstrate both of these scenarios.

The sample will also show how the runtime behavior of a Streams Edge application can be configured at deployment time via the following two mechanisms.

- **_submission time variables_**.  These are optional, application specific variables that are defined in the application. The application code determines how the values passed in for these variables at deployment time affects the behavior of the application at runtime.


- **_runtime options_**.  These control more basic built-in capabilities and therefore available for every application.  The set of supported built-in options are described in [runtime-options](#stv).

The SPL sample application has two submission time variables defined in it.  It will show how values for these variables, and the trace runtime-options, can be passed into the application at deploy time.  Also, it will show how the resulting trace statements can be viewed.

## Skill Level 

* The sample program is written in SPL, so an elementary understanding of SPL might help understanding the sample better.  See  [SPL Reference.](https://www.ibm.com/support/knowledgecenter/SSCRJU_5.3/com.ibm.streams.splangref.doc/doc/spl-container.html)

## Prerequisite steps that are needed prior to trying this sample 
  
1. [Install IBM Cloud Pak for Data (CPD) 3.0.1](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/install/install.html)
    - Gather the following information
        - **_web client URL_**: This is the URL used to access the IBM Cloud Pak for Data environment in your browser. It should be of the form: https://HOST:PORT (e.g., https://123.45.67.89:12345).
        - **_credentials_**
        : These are the credentials (username and password) used to log in to the IBM Cloud Pak for Data environment in your browser. 
        - **_version_**: You can find the version number in the About section after logging in to the IBM Cloud Pak for Data environment in your browser.

2. [Install IBM Edge Analytics beta service on CPD](https://www.ibm.com/support/knowledgecenter/SSQNUZ_3.0.1/svc-edge/install.html) and [setup edge systems](https://www.ibm.com/support/knowledgecenter/SSQNUZ_3.0.1/svc-edge/admin.html)
    - Gather the credentials (root password) for Edge nodes
    
3. [Install IBM Streams 5.4.0 service on CPD](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/svc/streams/install-intro.html)

4. [Provision a Streams instance](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/svc/streams/provision.html#provision)

5. If IEAM will be used to managed edge application lifecycles
    - [Install IBM Edge Application Manager 4.1](https://www.ibm.com/support/knowledgecenter/SSFKVV_4.1/hub/hub.html)
    
        - Gather the following information
            - API key for IEAM access  
                - _eam-api-key_
    - Reference Openshift administrator information
    
        - Gather Openshift cluster url & credentials 
            - _openshift-cluster-url:port_
            - _default-route-to-openshift-image-registry_
            - _openshift-token-for-cpd-admin-sa_
         
6. Clone this repository or download the source archive. 
   
   
7. Install and setup the Visual Studio Code (VSCode) tool. 
    1. Install and setup VS Code. See the "Installation and setup" section of this reference: 
<http://ibmstreams.github.io/streamsx.documentation/docs/spl/quick-start/qs-1b/>
    1. Follow instructions in the "Add a Streams instance: IBM Cloud Pak for Data deployment" section
    1. Import the project for this sample
        - Select File > Open
        - Browse to following project folder, and open it.
            - sample.edge-app-control/TradesApp_withLogTrace
    1. Edit application
        - Browse to application/TradesAppCloud_withLogTrace.spl
        - Open it in the editor


## Steps 

This sample will show how to develop and deploy an Edge application in an CPD environment without using an EAM instance, and how to develop and deploy an Edge application in an CPD environment when using an EAM instance.  Here are the high level steps for developing and deploying the Edge application.   
1. Develop and Build Application for the Edge
1. Select Edge nodes to use
1. Develop/Publish Application
1. Deploy Application to Edge nodes
1. View log
1. Un-deploy Application

While the high level flow applies for both scenarios, the detailed steps have some differences in them and will be described separately in the following two scenarios.

### Scenario#1 - Develop and deploy application without IBM Edge Application Manager

![non-EAM Deploy](./images/DeployAppPkg-withoutEAM.png)

#### 1. Develop and Build application for the Edge (via VS Code)

1. Work with application by opening up the VS Code editor on the TradesAppCloud_withLogTrace.spl SPL source code

    Notice the trace and println statements that have been added to the application to show examples of how to define and reference submission time variables, and how to add application trace statements to output these values into the application log.
    
    Search for "LOOK HERE" to see the section of the application that is most relative to this sample.
    
    Notice the names for the two submission time variable names as they will be needed later on. 
    - _mySubmissionTimeVariable_string_
    - _mySubmissionTimeVariable_listOfStrings_
           
    Change the "yourName" string to something of your choosing.  This will allow you to see how it gets printed to the log. 
    Save the application file.
        
    ```        
    { 
    
        // LOOK HERE

        // define submission time variables; 1 of each supported type (string, list of strings)
        rstring mySubmissionTimeVariable_string = getSubmissionTimeValue("mySubmissionTimeVariable_string","defaultValue");
        list<rstring> mySubmissionTimeVariable_listOfStrings = getSubmissionTimeListValue("mySubmissionTimeVariable_listOfStrings","defaultFirstListElement", "defaultSecondListElement"]);
						
        // add trace statements that will display the submission time values that were inputted
        appTrc(spl::Trace.info, "mySubmissionTimeVariable_string =" + mySubmissionTimeVariable_string);
        appTrc(spl::Trace.info, "mySubmissionTimeVariable_listOfStrings var: ");
        for (rstring parm in mySubmissionTimeVariable_listOfStrings) {
            appTrc(spl::Trace.info, "   String element: "+parm);
        }
                        
        // notice the following trace statement is 'debug' level, 
        //    & will only show in log when trace level is 'debug' or 'trace'
        appTrc(spl::Trace.debug, "*** DEBUG-LEVEL of trace message ***");

        // add some print lines - modify "yourName" below if you would like to customize the output.
        printStringLn("Average asking price for " + ticker + "  is " + (rstring) average);
        printStringLn("This sample is being is being tried out by: USER-NAME= " + "yourName");

        // submit the tuple
        submit(AvgPrice, PrintAvPrice);						
    } 
    ``` 
    
1. Build the application image for the Edge
    1. Right click in the TradesAppCloud_withLogTrace application editing window, and select "Build"
        - Monitor the console output until the "Successfully build the application" message is displayed
    1. Right click in the TradesAppCloud_withLogTrace application editing window, and select "Build Edge Application Image"
        - When prompted, select the base image that contains "streams-edge-base-application", and enter "trades-withtrace" for image name, and "1.0" for image tag
        - Click "Build image"
        - Monitor the console output until "Successfully built the edge application image", and take note of the imagePrefix from the Image Details.
        

#### 2. Develop / Publish application package 
    
- From CP4D Console, perform these steps. For more information, see "Packaging using Cloud Pak for Data" topic. 
    1. Select CPD Console > Navigation Menu > Analyze > Edge Analytics > Analytics apps
    1. Click 'Add Application packages' and fill in these values
        | Field | Value |
        | ----- | ----- |
        | Name | App Control Sample | 
        | Version | 1.0 |
        | Image reference | trades-withtrace:1.0 | 
    1. Scroll down to Additional attributes > Environment variables and add the following variables.  Clicking 'Add more" as needed.  See more information on [determining what variables are supported.](#stv)
        
        | Variable Name | Value |
        | ------------- | ----- |
        | mySubmissionTimeVariable_string | MyFavoriteFootballTeams |
        | mySubmissionTimeVariable_listOfStrings | Vikings,Packers,Lions,Bears |
        | STREAMS_OPT_TRACE_LEVEL | 3  | 
    1. Save
    
#### 3. Deploy application package to an Edge node 
From CP4D Console perform these steps. For more informations, see "Deploying using Cloud Pak for Data" topic. The values for the submission time variables can not be changed at this time.
1. Continuing from the 'Analytics apps' panel
    - CPD Console > Navigation Menu > Analyze > Edge Analytics > Analytics apps
1. Go to end of the row with "App Control Sample" and click on three dots to open list of options, and select 'Deploy to edge'
    1. When the list of remote systems is displayed, check the box next to the remote system you want to deploy to.
    1. Select 'Deploy' option.
1. To verify that the app was deployed successfully, select the "App Control Sample"
    1. Verify that there is an application instance for the deployment to your chosen system.

#### 4. View the runtime logs
From CP4D Console, perform these steps.  For more information, see ".... logs ...." topic.
1. Continuing from the 'App Control Sample' panel
    - CPD console > Navigation Menu > Analyze > Edge Analytics > Analytics apps > app control sample
1. Go to row for the application instance for the edge node that you would like to see log for, and select three dots at clear right part of row to see the list of options.
    1. Select 'Download logs'.
1. Unzip downloaded log package.
1. Open up app-control-sample-xxxx.log file
    - This file contains a variety of statements.  The standard println output will be in this log, as well as the output from the trace statements.  Search for "USER-NAME" for example of println output. You should see the value for 'yourName' that you previously entered in to the application. The statements added due to the application trace statements will contain "#splapptrc".  
    
    - Here is a snippet of the log. Notice that the values for the input variables that were supplied made it to the application and were output to this log file. (e.g. MyFavoriteFootballTeams). 
    Also, notice that the DEBUG-LEVEL message was not in the log.  This means the STREAMS_OPT_TRACE_LEVEL runtime-option that set the level to INFO was received and acted upon by the application, so as only trace statements of info level were accepted in the file. 

```
2020-08-19T10:07:10.064038778-07:00 stdout F 19 Aug 2020 17:07:10.063+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:82]  - mySubmissionTimeVariable_string =MyFavoriteFootballTeams
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.063+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:83]  - mySubmissionTimeVariable_listOfStrings var: 
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.064+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Vikings
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.064+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Packers
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.065+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Lions
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.065+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Bears

2020-08-19T10:07:10.066033579-07:00 stdout F This sample is being is being tried out by: USER-NAME=  yourName


```
              
#### 5. Un-deploy application
From CP4D Console, perform these steps.  For more information, see "Deleting an application deployment" topic.
1. Continuing from the 'App Control Sample' panel
    - CPD console > Navigation Menu > Analyze > Edge Analytics > Analytics apps > App Control Sample
1. Go to row for the application instance for the edge node that you would like to un-deploy the app from, and select three dots at clear right part of row to see the list of options.
    1. Select 'Delete'
    1. Confirm the Delete

### Scenario#2 - Develop and deploy application with IBM Edge Application Manager

![EAM Deploy](./images/DeployAppPackage-withEAM.png)

#### 1. Develop and Build application for the Edge (via VS Code)
- same as Scenario#1
        
#### 2. Select Edge Node(s) for development and deployment (via CP4D Console)
To see list of Edge nodes that have been tethered to this CPD instance, do these steps:
1. login in to CPD Console
1. Select Navigation Menu > Analyze > Edge Analytics > Remote systems
    This will display a list of the available nodes.  Select one of the _ieam-analytics-micro-edge-system_ type nodes for the development system.  Also, select one of these for the deployment system.  It can be the same system.

#### 3. Develop / Publish application package 
ssh to CP4D Edge node chosen for development and perform the following steps.  For more information, see the "Packaging an edge application service for deployment by using Edge Application Manager" topic.  The submission time variables from the application will be included in the resulting application package. The values for the variables are not specifed as part of the application package.

- Install the OpenShift® command-line interface. See xxxx.

- Setup the environment variables

```
    eval export $(cat agent-install.cfg)
    export HZN_EXCHANGE_USER_AUTH= _my_eam_api_key_
    export OCP_USER="cpd-admin-sa"
    export OCP_DOCKER_HOST=_default-route-to-openshift-image-registry_
    export OCP_TOKEN=_cpd-admin-sa_openshift-token_
    export IMAGE_PREFIX=_imagePrefix_   // from build step
```
    
- Login to OpenShift and Docker
```
    oc login _openshift_cluster_url:port_ --token $OCP_TOKEN --insecure-skip-tls-verify=true
    docker login $OCP_DOCKER_HOST --username $OCP_USER --password $(oc whoami -t)
```
- Pull the edge application image to the development node
```
    docker pull $OCP_DOCKER_HOST/$IMAGE_PREFIX/trades-withtrace:1.0
```
- Create a cryptographic signing key pair.
```
    hzn key create "my_company_name" "my_email_address"
```
- Create EAM service project
```
    mkdir app_control_sample; cd app_control_sample
    hzn dev service new -s app-control-service -V 1.0 --noImageGen -i $OCP_DOCKER_HOST/$IMAGE_PREFIX/trades-withtrace:1.0
```
- Add submission time variables and runtime-option:trace
    1. edit horizon/service.definition.json with editor of your choosing.
    1. insert the submission time variables into the "userInput" array such that it looks like the following.  See more information on [determining what variables are supported.](#stv)
    
```
    {
        "org": "$HZN_ORG_ID",
        "label": "$SERVICE_NAME for $ARCH",
        "description": "",
        "public": true,
        "documentation": "",
        "url": "$SERVICE_NAME",
        "version": "$SERVICE_VERSION",
        "arch": "$ARCH",
        "sharable": "multiple",
        "requiredServices": [],
        "userInput": [
		      {
			     "name": "mySubmissionTimeVariable_string",
			     "type": "string",
			     "defaultValue": "defaultValue"
		      },
		      {
			     "name": "mySubmissionTimeVariable_listOfStrings",
			     "type": "list of strings",
			     "defaultValue": "defaultFirstListElement,defaultSecondListElement"
		      },
              {
                    "name": "STREAMS_OPT_TRACE_LEVEL",
                    "label" : "Tracing level: 0=OFF, 1=ERROR, 2=WARNING, 3=INFO, 4=DEBUG, 5=TRACE",
                    "type": "string",
                    "defaultValue": "1"
                }
        ],
        "deployment": {
            "services": {
                "tradesappcloud-withlogtrace": {
                "image": "$OCP_DOCKER_HOST/$IMAGE_PREFIX/trades-withtrace:1.0",
                "privileged": false,
                "network": ""
            }
        }
    }
}
```
- Test the service by starting the service, reviewing the container logs, and stopping the service.

```
    hzn dev service start -S
    sudo cat /var/log/syslog | grep trades-withtrace[[]
    hzn dev service stop
```

- Publish service

```
    hzn exchange service publish -r "$OCP_DOCKER_HOST:$OCP_USER:$OCP_TOKEN" -f horizon/service.definition.json
```
    
    1. verify app-control-service was published and exists in the service list.
    
        hzn exchange service list
        
- Publish pattern

```
    hzn exchange pattern publish -f horizon/pattern.json 
```
    
    1. verify pattern-app-control-service pattern was published and exists in this pattern list.
    
    
```
        hzn exchange pattern list
```
            

#### 4. Deploy application package to an Edge node 
ssh to CP4D Edge node chosen for deployment and perform the following steps.  For more information, see the "Deploying using Edge Application Manager" topic.  The values for the submission time variables from the application will be specified during deployment.
- Edit horizon/userinput.json with editor of your choosing and add the following json to it.
        
```
    {
        "services": [
            {
                "org": "$HZN_ORG_ID",
                "url": "app-control-service",
                "variables": {
                    "mySubmissionTimeVariable_string": "MyFavoriteFootballTeams",
                    "mySubmissionTimeVariable_listOfStrings": ["Vikings,Packers,Lions,Bears"],
                    "STREAMS_OPT_TRACE_LEVEL" : "3"
                }
            }
        ]
    }       
```

- Deploy pattern/service with user inputs.

```
    hzn register -p pattern-app-control-service-amd64    -f horizon/userinput.json
    
```
- Verify that application is deployed, by checking for an agreement being created.  This make take a few minutes to show up.
    
```
    hzn agreement list
```
    

#### 5. View the runtime logs (ssh to CP4D Edge node chosen for deployment)

    hzn service log -f app-control-service
    
- View log statements
    - This log contains a variety of statements.  The standard println output will be in this log, as well as the output from the trace statements.  Search for "USER-NAME" for example of println output. The trace statements will contain "#splapptrc".  
    - Here is a snippet of the log. Notice that the input variables that were supplied made it to the application and were output to this log file. (e.g. MyFavoriteFootballTeams). Also, notice that the DEBUG-LEVEL message was not in the log.  This means the STREAMS_OPT_TRACE_LEVEL runtime-option that set the level to INFO made it to the application as well. 

```
2020-08-19T10:07:10.064038778-07:00 stdout F 19 Aug 2020 17:07:10.063+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:82]  - mySubmissionTimeVariable_string =MyFavoriteFootballTeams
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.063+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:83]  - mySubmissionTimeVariable_listOfStrings var: 
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.064+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Vikings
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.064+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Packers
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.065+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Lions
2020-08-19T10:07:10.066033579-07:00 stdout F 19 Aug 2020 17:07:10.065+0000 [56] INFO #splapptrc,J[0],P[0],PrintAvPrice M[TradesAppCloud_withLogTrace.spl:appTrc:85]  -    String element: Bears

2020-08-19T10:07:10.066033579-07:00 stdout F This sample is being is being tried out by: USER-NAME=  yourName


```

        
#### 6. Un-deploy application

```
        hzn unregister -f
```


## Additional Resources

<a id="stv">
    
**Submission Time Variable Names:** 

For simple applications, the submission time variable names are just how they appear in the application. However, when the same name is used for a submission time variable in different namespaces or composites of the application, the variable names must be prepended by the application namespace and composite operator name.  To determine what this fully qualified name looks like, you may retrieve the names of the supported variables by following the "Retrieving service variables for edge applications" topic. 

This is also useful to discover the supported variables for an image whose source code is not readily available for. Also, a complete list of the supported runtime options can be discovered this way.

For illustration purposes, the information retrieved by performing this process for this sample application are shown in these files in this repo:
    
- sample.edge-app-control/config-files/app-definition.json
- sample.edge-app-control/config-files/runtime-options.json

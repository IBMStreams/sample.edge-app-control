# (UNDER CONSTRUCTION - This sample and its instructions are under development)

# sample.edge-app-control

The objective of this sample is to illustrate the steps involved with developing an Streams Programming Language (SPL) application for the Edge.  It will start with the application SPL source code, proceed to the application build process, followed by deployment (including configuration) to the edge nodes, and finish with examining the runtime output.  

There are two ways of managing the edge application deployment lifecycles.

1. Using built-in edge deployment support in Cloud Pak for Data (CP4D)
1. Using an instance of the IBM Edge Application Manager (IEAM)
    
This sample will demonstrate both of these scenarios.

The sample will also show how the runtime behavior of a Streams Edge application can be configured at deployment time via the following two mechanisms.

- **_submission time variables_**.  These are optional, application specific variables that are defined in the application. The application code determines how the values passed in for these variables at deployment time affects the behavior of the application at runtime.


- **_runtime options_**.  These control more basic built-in capabilities and therefore available for every application.  The set of supported built-in options are described in [runtime-options](#runtime-options).

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
    - Gather the following information
        - Credentials (root password) for Edge nodes
    
3. [Install IBM Streams 5.4.0 service on CPD](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/svc/streams/install-intro.html)

4. [Provision a Streams instance](https://www.ibm.com/support/producthub/icpdata/docs/content/SSQNUZ_current/cpd/svc/streams/provision.html#provision)

5. If IEAM will be used to managed edge application lifecycles
    - [Install IBM Edge Application Manager 4.1](https://www.ibm.com/support/knowledgecenter/SSFKVV_4.1/hub/hub.html)
    
        - Gather the following information
            - API key for IEAM access  
                - _eam-api-key_
    - Reference Openshift administrator
    
        - Openshift cluster url & credentials 
            - _openshift-cluster-url:port_
            - _default-route-to-openshift-image-registry_
            - _openshift-token-for-cpd-admin-sa_

            
* Clone this repository or download the source archive. 
   
   
* Install and setup the Visual Studio Code (VSCode) tool. 
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

This sample will show how to develop and deploy an Edge application in an CPD environment without using an EAM instance, and how to develop and deploy an Edge application in an CPD environment when using an EAM instance.  The high level steps are the same for both of these scenarios.  
1. Develop Application
1. Build Application for the Edge
1. Select Edge nodes to use
1. Develop/Publish Application
1. Deploy Application to Edge nodes
1. View log
1. Undeploy Application

While the steps are the same for both scenarios, the detailed steps have some differences in them.  These detailed flows will be described separately.  

### Scenario#1 - Develop and deploy application without IBM Edge Application Manager

![non-EAM Deploy](./images/DeployAppPkg-withoutEAM.png)

1. Develop application (via VS Code)

    The application used in this sample is a simple SPL application that reads stock ticker entries from a file, does a simple calculation on them, and then writes them out to a file. It will continue doing this in a loop.

    Some additional trace and println statements have been added to the application to show examples of how to define and reference submission time variables, and how to add application trace statements to output these values into the application log.
    
    Search for "LOOK HERE" to see the section of the application that is most relative to this sample.
    
    Notice the names for the two submission time variable names as they will be needed later on. 
    - _mySubmissionTimeVariable_string_
    - _mySubmissionTimeVariable_listOfStrings_
        
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

    
To further demonstrate the println function working, you may customize the "yourName" string in the application to see how it gets printed to the output log.
    
1. Build application for the Edge (via VS Code)
    - Use the VSCode tool to compile the SPL application code, and ultimately build into a Docker image.
        1. Right click in the TradesAppCloud_withLogTrace application, and select "Build"
            - Monitor the console output until the "Successfully build the application" message is displayed
        1. Right click in the TradesAppCloud_withLogTrace application, and select "Build Edge Application Image"
            - When prompted, select the base image that contains "streams-edge-base-application", and enter "tradesappcloud-withlogtrace" for image name, and "1.0" for image tag
            - Invoke "Build image"
            - Monitor the console output until "Successfully built the edge application image", and take note of the imagePrefix from the Image Details.
        
1. Select Edge Node(s) for development and deployment (via CP4D Console)
    To see list of Edge nodes that have been tethered to this CPD instance, do these steps:
    1. login in to CPD Console
    1. Select Navigation Menu > Analyze > Edge Analytics > Remote systems
        This will display a list of the available nodes. Select one of the _analytics-micro-edge-system_ type nodes.

1. Develop / Publish application package 
    
    - From CP4D Console, perform these steps. For more information, see "Packaging using Cloud Pak for Data" topic. 
        1. Select CPD Console > Navigation Menu > Analyze > Edge Analytics > Analytics apps
        1. Add Application packages
            | Field | Value |
            | ----- | ----- |
            | Name | app control sample | 
            | Version | 1.0 |
            | Image reference | trades-withtrace:1.0 | 
        1. Scroll down to Additional attributes > Environment variables
        
            | Variable Name | Value |
            | ------------- | ----- |
            | mySubmissionTimeVariable_string | MyFavoriteFootballTeams |
            | mySubmissionTimeVariable_listOfStrings | Vikings,Packers,Lions,Bears |
            | STREAMS_OPT_TRACE_LEVEL | 3  | 
        1. Save
    
1. Deploy application package to an Edge node 
    - From CP4D Console perform these steps. For more informations, see "Deploying using Cloud Pak for Data" topic. The values for the submission time variables can not be changed at this time.
        1. Select CPD Console > Navigation Menu > Analyze > Edge Analytics > Analytics apps
        1. Go to row with "app control sample" > select three dots at end for row > Deploy to edge
            1. Select check box for remote system to deploy to.
            1. Select Deploy option.
        1. Select "app control sample"
            1. Look at Application instances
                - verify that there is entry for a deployment

1. View the runtime logs
    - From CP4D Console, perform these steps.  For more information, see ".... logs ...." topic.
        1. Select CPD console > Navigation Menu > Analyze > Edge Analytics > Analytics apps
        1. Select "app control sample'
        1. Scroll down to Application instances.
        1. Goto row for edge node that you would like to see log for, and select three dots at clear right part of row.
            1. Select Download logs.
        1. Unzip downloaded log package.
        1. Open up app-control-sample-xxxx.log file
            - This file contains a variety of statements.  The standard println output will be in this log, as well as the output from the trace statements.  Search for "USER-NAME" for example of println output. The trace statements will contain "#splapptrc".  
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
              
1. Undeploy application
    - From CP4D Console, perform these steps.  For more information, see "Deleting an application deployment" topic.
        1. Select CPD console > Navigation Menu > Analyze > Edge Analytics > Analytics apps
        1. Select "app control sample'
        1. Scroll down to Application instances.
        1. Goto row for edge node that you would like to delete, and select three dots at clear right part of row.
            1. Select Delete

### Scenario#2 - Develop and deploy application with IBM Edge Application Manager

![EAM Deploy](./images/DeployAppPackage-withEAM.png)

1. Develop application (via VS Code)
    - same as Scenario#1
    
1. Build application for the Edge (via VS Code)
    - same as Scenario#1
        
1. Select Edge Node(s) for development and deployment (via CP4D Console)
    To see list of Edge nodes that have been tethered to this CPD instance, do these steps:
    1. login in to CPD Console
    1. Select Navigation Menu > Analyze > Edge Analytics > Remote systems
        This will display a list of the available nodes.  Select one of the _ieam-analytics-micro-edge-system_ type nodes for the development system.  Also, select one of these for the deployment system.  It can be the same system.

1. Develop / Publish application package 
    - ssh to CP4D Edge node chosen for development and perform the following steps.  For more information, see the "Packaging an edge application service for deployment by using Edge Application Manager" topic.  The submission time variables from the application discovered in step #1 above will be included in the resulting application package. The values for the variables are not specifed as part of the application package.
        1. Install the OpenShift® command-line interface. See xxxx.
        1. Setup the environment variables
            - eval export $(cat agent-install.cfg)
            - export HZN_EXCHANGE_USER_AUTH= _my_eam_api_key_
            - export OCP_USER="cpd-admin-sa"
            - export OCP_DOCKER_HOST=_default-route-to-openshift-image-registry_
            - export OCP_TOKEN=_cpd-admin-sa_openshift-token_
            - export IMAGE_PREFIX=_imagePrefix_   // from build step
        1. Login to OpenShift and Docker
            - oc login _openshift_cluster_url:port_ --token $OCP_TOKEN --insecure-skip-tls-verify=true
            - docker login $OCP_DOCKER_HOST --username $OCP_USER --password $(oc whoami -t)
        1. Pull the edge application image to the development node
            - docker pull $OCP_DOCKER_HOST/$IMAGE_PREFIX/tradeswithlogtrace:1.0
        1. Create EAM service project
            1. mkdir app_control_sample; cd app_control_sample
            1. hzn dev service new -s app-control-sample-service -V 1.0 --noImageGen -i $OCP_DOCKER_HOST/$IMAGE_PREFIX/tradeswithlogtrace:1.0
        1. Add submission time variables and runtime-option:trace
            1. vi horizon/service.definition.json
            1. insert the submission time variables into the "userInput" array such that it looks like this:
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
                            "image": "$OCP_DOCKER_HOST/$IMAGE_PREFIX/tradesappcloud-withlogtrace:1.0",
                            "privileged": false,
                            "network": ""
                            }
                        }
                    }
                }
                ```
            

1. Deploy application package to an Edge node 
    - ssh to CP4D Edge node chosen for deployment and perform the following steps.  For more information, see the "Deploying using Edge Application Manager" topic.  The values for the submission time variables from the application will be specified during deployment.
        1. vi userinput.json and add the following json to it.
        
        ```
                {
                    "services": [
                        {
                            "org": "$HZN_ORG_ID",
                            "url": "sample-trace",
                            "variables": {
                                "mySubmissionTimeVariable_string": "MyFavoriteFootballTeams",
                                "mySubmissionTimeVariable_listOfStrings": ["Vikings,Packers,Lions,Bears"],
                                "STREAMS_OPT_TRACE_LEVEL" : "3"
                            }
                        }
                    ]
                }       
        ```

1. View the runtime logs (ssh to CP4D Edge node chosen for deployment)
    - same as Scenario#1

The system log file contains several messages from many different sources.  To filter off what you are interested requires using grep'g techniques.
- See all messages for service
    - cat /var/log/syslog | grep image-name
- See all trace messages for service - trace statements
    - cat /var/log/syslog | grep image-name | grep apptrc
        Notice the xxx statements produced from the application trace statements.
        Notice also that they contain the variable values that we inputted.
        
1. Undeploy application


## Additional Resources

Note: if there is a naming conflict with submission time variables with different parts of the your application, or if you do not have access to the application source code, you will need to retrieve the names of the supported variables by following the "Retrieving service variables for edge applications" topic.  For illustration, the information retrieved by performing this process for this sample application are shown in these files in this repo:
    
    - sample.edge-app-control/config-files/app-definition.json
    - sample.edge-app-control/config-files/runtime-options.json

* Outline major steps to complete the task, e.g. They must use the X operator with parameters a,b, and c. State that early and repeat it a couple of times. 
* Discuss details about each step
   * Keep the steps to the point and concise.
   * Make sure there is validation at the end of each step ... so the user knows that they have completed the steps successfully.  i.e. what should the user see at the end of each major step?

Avoid discussing information that is interesting/cool but that a user, especially a novice, does not need to know to complete the task.

# Preparing to write

Some questions to help you identify the key information to highlight:
* What pain points does this task address? Who would be interested in learning this information?

* If I was a developer trying to find this article, what keywords would I be using to search for it? 
   * Are those keywords highlighted early in the article?
* Is there a real-world problem or user story around which you can frame the article?

* What are the key points they need to know? E.g. They must use the X operator with parameters a,b, and c. 

# Before you Start Writing
If the article has a long list of instructions, put together a table of contents first to organize the flow of the instructions.

Examples:
* https://developer.ibm.com/streamsdev/docs/streams-quick-start-guide/
* https://developer.ibm.com/streamsdev/2018/01/12/calculate-moving-averages-real-time-data-streams-designer/
* https://developer.ibm.com/streamsdev/docs/common-patterns-tracking-moving-objects-streams-part-2-geofencing/

You can create links to sections in the doc using the anchor tag, e.g:

```
- [step 1](#step1)
- [step 2](#step2)
...
<a id="step1">
<h2>Step 1</h2>
```

The section below outlines things that you should cover, but your outline and table of contents are important to flush out first.



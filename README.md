# sample.edge-app-control
Application control sample

#Brad's new sample documention.
When writing a guide or article about how to perform a specific task, here are some tips to speed up writing time and improve the quality of the finished article.

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

# Sample outline

## Introduction
The objective of this sample is to illustrate the steps involved with developing an SPL application for the Edge.  It will start with the application SPL source code, proceed to the application build process, followed by deployment (including configuration) to the edge nodes, and finish with examining the runtime output.

The runtime behavior of a Streams Edge application may be configured at deployment time via the following two mechanisms.

- **_submission time variables_**.  These are optional, application specific variables that are defined in the application. The application code determines how the values passed in for these variables at deployment time affects the behavior of the application at runtime.


- **_runtime options_**.  These control more basic built-in capabilities and therefore available for every application.  The set of supported built-in options are described in [runtime-options](#runtime-options).

This article will use an SPL sample application that has some submission time variables defined in it.  It will show how values for these variables, and the trace runtime-options, can be passed into the application at deploy time.  Also, it will show how the resulting trace statements can be viewed.

## Skill Level 

* The sample program is written in SPL, so an elementary understanding of SPL might help understanding the sample better.  See SPL reference below.
* Expected skills level - what does the reader need to know to understand this article?
* If the user does not have the required skills, where should they go to learn more? 

## Requirements/Information to collect 

* The VSCode tool will be used in this sample. For more information on how to install and setup Visual Studio Code for use in this sample, see:  
<http://ibmstreams.github.io/streamsx.documentation/docs/spl/quick-start/qs-1b/>

* You will need the following information prior to starting this sample exercise:   
    - IBM Cloud Pak for Data information
        - **_version_**: You can find the version number in the About section after logging in to the IBM Cloud Pak for Data environment in your browser.
        - **_web client URL_**: This is the URL used to access the IBM Cloud Pak for Data environment in your browser. It should be of the form: https://HOST:PORT (e.g., https://123.45.67.89:12345).
        - **_credentials_**
        : These are the credentials (username and password) used to log in to the IBM Cloud Pak for Data environment in your browser. 
    - credentials (username and password) for Edge nodes
    - EAM Scenario only
        - API key for EAM access
        - open shift cluster url & credentials (user & api-key)


## Steps 

This sample will show how to develop and deploy the application with and without EAM.  The high level steps are the same for both of these cases.  The individual steps will point out when there is difference between these two scenarios.
1. Develop Application
1. Build Application for the Edge
1. Select Edge nodes to use
1. Develop/Publish Application Package
    - The generic term "Application Package" will be used in the top level step description.  The specific terms used in the different scenarios will be tailored to that scenario. 
    - The detailed steps for each of the scenarios will be described separately.
1. Deploy Application Package
    - The detailed steps for each of the scenarios will be described separately.
1. View log


![EAM Deploy](./images/DeployAppPackage-withEAM.png)

![non-EAM Deploy](./images/DeployAppPkg-withoutEAM.png)

1. Develop application (via VS Code)

    In this sample we use a predefined sample application called "TracesAppCloud.spl".  It is an SPL application that shows a simple SPL application that reads some stock ticker entries, does a simple calculation on them, and then writes them out. It will continue doing this in a loop.

    For the purpose of this sample, some additional statements have been added to the application to show examples of how to define and reference submission time variables, and how to add application trace statements to output these values into the application log.
    
    Search for "LOOK HERE" to see the section of the application that is most relative to this sample.
    
    Notice the names for the two submission time variable names as they will be needed later on. 
    - _mySubmissionTimeVariable_string_
    - _mySubmissionTimeVariable_listOfStrings_
    
    Note: if there is a naming conflict with submission time variables with different parts of the your application, or if you do not have access to the application source code, you will need to retrieve the names of the supported variables by following the "Retrieving service variables for edge applications" topic.  The information retrieved by performing these for this sample application are shown in the attached files:
        - config-files/app-definition.json
        - runtime-options.json
    
    ![App Snippet](./images/App_snippet.png)
    
    To further demonstrate, you may customize the "yourName" string in the application to see how it gets printed to the output log.
    
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
        This will display a list of the available nodes of two types:
            - analytics-micro-edge-system = Edge nodes for non-EAM scenario
            - ieam-analytics-micro-edge-system = Edge nodes for EAM scenario

1. Develop / Publish application package 
    - If EAM scenario, ssh to CP4D Edge node chosen for development and perform the steps described in the "Packaging an edge application service for deployment by using Edge Application Manager".  The submission time variables from the application discovered in step #1 above will be included in the resulting application package. The values for the variables are not specifed as part of the application package.
    
    - If CPD scenario, login to CP4D Console, and perform these steps. For more informations, see "Packaging using Cloud Pak for Data" topic. 
        1. Select CPD Console > Navigation Menu > Analyze > Edge Analytics > Analytics apps
        1. Add Application packages
            | Field | Value |
            | ----- | ----- |
            | Name | app-control-sample | 
            | Version | 1.0 |
            | Image reference | tradesappcloud-withlogtrace:1.0 | 
        1. Scroll down to Additional attributes > Environment variables
        
            | Variable Name | Value |
            | ------------- | ----- |
            | mySubmissionTimeVariable_string | My-favorite-football-teams |
            | mySubmissionTimeVariable_listOfStrings | Vikings,Packers,Lions,Bears |
            | STREAMS_OPT_TRACE_LEVEL | 3  |  
    
    
    The values for the submission time variables discovered above in step#1 will be included in the resulting application package. To set these. 
        - mySubmissionTimeVariable_string

1. Deploy application package to an Edge node 
    - If EAM scenario, ssh to CP4D Edge node chosen for deployment and perform the steps described in the "Deploying using Edge Application Manager".  The values for the submission time variables from the application will be specified during deployment.
    
    - If CPD scenario, login to CP4D Console, and perform the steps described in the "Deploying using Cloud Pak for Data" topic. The values for the submission time variables can not be changed at this time.

1. View the runtime logs (ssh to CP4D Edge node chosen for deployment)


* Outline major steps to complete the task, e.g. They must use the X operator with parameters a,b, and c. State that early and repeat it a couple of times. 
* Discuss details about each step
   * Keep the steps to the point and concise.
   * Make sure there is validation at the end of each step ... so the user knows that they have completed the steps successfully.  i.e. what should the user see at the end of each major step?

Avoid discussing information that is interesting/cool but that a user, especially a novice, does not need to know to complete the task.

## Additional Resources / What's Next?

* List of resources to help the user learn more about the task?
* What can they do next?


* SPL reference



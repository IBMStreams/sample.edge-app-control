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
The runtime behavior of a Streams Edge application may be configured at deployment time via the following two mechanisms.

- **_submission time variables_**.  These are optional, application specific variables that are defined in the application. The application code determines how the values passed in for these variables at deployment time affects the behavior of the application at runtime.


- **_runtime options_**.  These control more basic built-in capabilities and therefore available for every application.  The set of supported built-in options are described in [runtime-options](#runtime-options).

This article will use an SPL sample application that has some submission time variables defined in it.  It will show how values for these variables, and the trace runtime-options, can be passed into the application at deploy time.  Also, it will show how the resulting trace statements can be viewed.

## Skill Level 

* The sample program is written in SPL, so an elementary understanding of SPL might help understanding the sample better.  See SPL reference below.
* Expected skills level - what does the reader need to know to understand this article?
* If the user does not have the required skills, where should they go to learn more? 

## Requirements/Information to collect 

* The VSCode tool will be used in this sample.  See the reference below for more info on how to install and set it up.
* You will need the following information prior to starting this sample exercise:   
    - IBM Cloud Pak for Data information
        - **_version_**: You can find the version number in the About section after logging in to the IBM Cloud Pak for Data environment in your browser.
        - **_web client URL_**: This is the URL used to access the IBM Cloud Pak for Data environment in your browser. It should be of the form: https://HOST:PORT (e.g., https://123.45.67.89:12345).
        - **_credentials_**
        : These are the credentials (username and password) used to log in to the IBM Cloud Pak for Data environment in your browser. 


* Any software to install?  Where do they get the software? Which version?
* What toolkits do they need?  Where do they get the toolkit?  How to set it up?

Discuss any information to collect:

* E.g. If the user is connecting to Event Streams in IBM Cloud, what credentials info they need to collect and how to collect it?

## Steps 

![EAM Deploy](./images/DeployAppPackage-withEAM.png)

![non-EAM Deploy](./images/DeployAppPkg-withoutEAM.png)

1. Build docker image for the application
    - Use the VSCode tool to compile the SPL application code, and ultimately build into a Docker image.
        1. Right click in the TradesAppCloud_withLogTrace application, and select "Build"
            - Monitor the console output until the "Successfully build the application" message is displayed
        1. Right click in the TradesAppCloud_withLogTrace application, and select "Build Edge Application Image"
            - When prompted, select the base image that contains "streams-edge-base-application", and enter "tradesappcloud-withlogtrace" for image name, and "1.0" for image tag
            - Invoke "Build image"
            - Monitor the console output until "Successfully built the edge application image", and take note of the imagePrefix from the Image Details.
            
1. Develop and publish service for the application

1. Deploy the service into a Edge node

1. View the runtime logs


* Outline major steps to complete the task, e.g. They must use the X operator with parameters a,b, and c. State that early and repeat it a couple of times. 
* Discuss details about each step
   * Keep the steps to the point and concise.
   * Make sure there is validation at the end of each step ... so the user knows that they have completed the steps successfully.  i.e. what should the user see at the end of each major step?

Avoid discussing information that is interesting/cool but that a user, especially a novice, does not need to know to complete the task.

## Additional Resources / What's Next?

* List of resources to help the user learn more about the task?
* What can they do next?

* For more information on how to install and setup Visual Studio Code for use in this sample, see:  
<http://ibmstreams.github.io/streamsx.documentation/docs/spl/quick-start/qs-1b/>

* SPL reference



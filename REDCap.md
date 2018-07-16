---
layout: page
title: REDCap
permalink: /redcap/
---

This page is for REDCap resources.

## The Center for Research Informatics

The *Center for Research Informatics* at the University of Chicago has a fantasticly thorough site helping one getting into REDCap. I highly recommend visiting [their top-notch site](http://cri.uchicago.edu/redcap-training/#manuals). I believe this is probably the most thorough collection of REDCap manuals, tutorials, and FAQs that is available. You'll find manuals (20 of them) that are specific to many common REDCap tasks. They also have several FAQs, ways that HTML code can be used, among many other things. 

## Short Presentation Regarding Secure Data Collection

[Secure Data Collection](https://tysonstanley.github.io/Workshops/2018WebConference.pdf)

<br>

# REDCap at Utah State University
## Getting An Account

To obtain a REDCap account at Utah State University, click [here](https://redcap.cehs.usu.edu/surveys/index.php?s=MDNHMDKPNM) to access the form. You may request an account for colleagues as well, as long as you are connected to Utah State University (preferrably in the College of Education and Human Services).

To sign in once you have an account, visit [https://redcap.cehs.usu.edu](https://redcap.cehs.usu.edu).

## Slow Loading of REDCap at USU

Recently, we moved the servers that REDCap ran on to a new building and in the process the IP addresses changed. Because of this, your browser may be going very slowly when you try to pull up [https://redcap.cehs.usu.edu](https://redcap.cehs.usu.edu). For now, our best answer is to clear your DNS cache. This is different than clearing your browser history. Below, I highlight how you can do this for each system (assuming your computer is fairly up-to-date).

In addition to what is explained below, it may be good to clear the browsing history of your browser.

#### Mac Users

Quit all browser applications. Open the terminal app (in the Spotlight Search, search for "Terminal" and it should pull up there). Type the following command and then press enter.

{% highlight bash %}
sudo killall -HUP mDNSResponder
{% endhighlight %}

It will ask for the computer's password at this point. Enter the password and then press enter. If it ran correctly, it shouldn't say anything else. 

#### Windows Users

Close all browser programs. Press the Windows Key or hover your mouse over the bottom left corner and click the Windows Icon. Begin typing "Command Prompt". It should pull up for you. Right-click the application and select Run as Administrator. Once you are in the app, run the following command in the command line and hit enter:

{% highlight bash %}
ipconfig /flushdns
{% endhighlight %}

#### Linux Users

Open the terminal window and type the following command and then press enter:

{% highlight bash %}
sudo /etc/init.d/nscd restart
{% endhighlight %}

#### Conclusion

These should provide a temporary help. If it slows again, you can try doing this again. We are working on a more permanent fix for this.
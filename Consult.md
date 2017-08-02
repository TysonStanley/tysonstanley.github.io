---
layout: page
title: Thinking Stats
permalink: /thinkingstats/
---

![]({{ site.baseurl }}/assets/images/thinkingstats_logo.jpg)

My small consulting company is called *Thinking Stats*. It is based in Utah, but is available to serve throughout the United States.

I have consulted on projects in education, communication sciences, economics, psychology, and biology. Contact me for a free intake appointment.

The table below highlights the ways I can (and often have) contributed to a project.

<table>
 <thead>
  <tr>
   <th style="text-align:left;"> Project Type </th>
   <th style="text-align:left;"> Output Produced by<br>Thinking Stats </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Research <br> (Scientific or <br>Business Improvement)</td>
   <td style="text-align:left;"> Technical Reports<br>Published Papers<br>Data Management<br>Data Cleaning<br>R Code<br>Replicable Workflow </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Production <br> (Part of a larger system)</td>
   <td style="text-align:left;"> Production Level Code<br>Technical Reports<br>Data Cleaning </td>
  </tr>
</tbody>
</table>


## Contact Me

To contact me,

- Email me at <t.barrett@aggiemail.usu.edu>, or 
- Fill out the form below. 

I try to respond to either within 48 hours.

<div id="formdiv">
<form name="gform" id="gform" enctype="text/plain" action="https://docs.google.com/forms/d/e/1FAIpQLSeM_ttqtQXmCcawVZfYJ__3PqLt8LxPJClW5y_Rkp8kkV0mzQ/formResponse?" target="hidden_iframe" onclick="submitted=true;">
  <input type="text" name="entry.1906098226" id="entry.1906098226" placeholder="Name..." required><br>
  <input type="text" name="entry.815077072" id = "entry.815077072" placeholder="Email..." required><br>
  <input type="text" name="entry.1692136309" id = "entry.1692136309" placeholder="Daytime Phone Number..." ><br>
  <input type="text" name="entry.830671445" id = "entry.830671445" placeholder="Project Type (Production or Reseach)..." ><br>
  <input type="text" name="entry.126928977" id = "entry.126928977" placeholder="Company or Organization Name..."><br>
  <input type="text" name="entry.1522113980" id = "entry.1522113980" placeholder="Any additional comments..."><br>
  <input type="button" onclick="ReplaceForm()" value="Submit">
</form>
</div>

<iframe name="hidden_iframe" id="hidden_iframe" style="display:none;" onload="if(submitted) {}"></iframe>

<div id="for_replacement" style="display:none;">
<b>Your request has been processed and will be reviewed soon.</b><br>
</div>

<script type="text/javascript">
function ReplaceForm() 
{
var IDofForm = "gform";
var IDofDivWithForm = "formdiv";
var IDforReplacement = "for_replacement";
document.getElementById(IDofForm).submit();
document.getElementById(IDofDivWithForm).innerHTML = document.getElementById(IDforReplacement).innerHTML;
}
</script>

<style>
form {
  /* Just to center the form on the page */
  margin: 0 auto;
}

form div + div {
  margin-top: 1em;
}

label {
  /* To make sure that all labels have the same size and are properly aligned */
  display: inline-block;
  width: 90px;
  text-align: right;
}

input[type=text] {
    width: 80%;
    padding: 12px 20px;
    margin: 8px 0;
    box-sizing: border-box;
    -webkit-transition: width 0.4s ease-in-out;
    transition: width 0.4s ease-in-out;
    border: 2px solid #ccc;
    border-radius: 4px;
}

input[type=text]:focus {
    width: 100%;
}

textarea {
    width: 100%;
    height: 150px;
    padding: 12px 20px;
    box-sizing: border-box;
    border: 2px solid #ccc;
    border-radius: 4px;
    background-color: #f8f8f8;
    resize: none;
}

#button {
    display: block;
    width:150px;
    margin:10px auto;
    padding:7px 13px;
    text-align:center;
    background:#D35400;
    font-size:20px;
    font-family: 'Helvetica', serif;
    color:#ffffff;
    white-space: nowrap;
    box-sizing: border-box;
    -webkit-box-sizing: border-box;
    -moz-box-sizing: border-box;

}

#button:active {
    vertical-align: top;
    padding-top: 8px;
}

.one a {
    text-decoration: none;
}
</style>

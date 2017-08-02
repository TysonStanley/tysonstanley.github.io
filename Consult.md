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

Charges associated with each service depends on the amount of time necessary to complete the project. This often is related to the number of stakeholders, and so that will also be taken into account. Again, however, the in-take is free and is not part of the projects' bid. 

To contact me, email me at <t.barrett@aggiemail.usu.edu> or fill out the form below. I try to respond to either within 48 hours.

<div name="Form">
<form name="gform" id="gform" enctype="text/plain" action="https://docs.google.com/forms/d/e/1FAIpQLSeM_ttqtQXmCcawVZfYJ__3PqLt8LxPJClW5y_Rkp8kkV0mzQ/formResponse?" target="hidden_iframe" onclick="submitted=true;">
  <input type="text" name="entry.1906098226" id="entry.1906098226" placeholder="Name..." required><br>
  <input type="text" name="entry.815077072" id = "entry.815077072" placeholder="Email..." required><br>
  <input type="text" name="entry.1692136309" id = "entry.1692136309" placeholder="Daytime Phone Number..." ><br>
  <input type="text" name="entry.830671445" id = "entry.830671445" placeholder="Project Type (Production or Reseach)..." ><br>
  <input type="text" name="entry.126928977" id = "entry.126928977" placeholder="Company or Organization Name..."><br>
  <input type="text" name="entry.1522113980" id = "entry.1522113980" placeholder="Any additional comments..."><br><br>
  <input type="button" onclick="ReplaceForm()" value="Submit" style="width:300px;">
</form>
</div>

<iframe name="hidden_iframe" id="hidden_iframe" style="display:none;" onload="if(submitted) {}"></iframe>

<div id="for_replacement" style="display:none;">
<p>
<b>Your request has been processed.</b>
<br>Expect to hear from me within 48-72 hours.
</div>

<script type="text/javascript">
function ReplaceForm()
{
// Three places to customize:

// Specify the id of the form.
var IDofForm = "gform";

// Specify the id of the div containing the form.
var IDofDivWithForm = "Form";

// Specify the id of the div with the content to replace the form with.
var IDforReplacement = "for_replacement";

// End of customizations.

// This line submits the form. (If Ajax processed, call Ajax function, instead.)
document.getElementById(IDofForm).submit();

// This replaces the form with the replacement content.
document.getElementById(IDofDivWithForm).innerHTML = document.getElementById(IDforReplacement).innerHTML;
}
</script>




<style>
form {
  /* Just to center the form on the page */
  margin: 0 auto;
  width: 400px;
  /* To see the outline of the form */
  padding: 1em;
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
    width: 70%;
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

input[type=submit] {
    padding:5px 15px; 
    background:#D35400; 
    margin: 4px 2px;
    cursor:pointer;
    font-family: Helvetica, serif;
    color: white;
}
</style>

Everfiler
=========

A zsh script to automate the filing of PDFs to Evernote via email, including Mac OS X tags.

## General Notes

- Designed to be used with [Hazel](http://www.noodlesoft.com/hazel.php) and/or Apple’s Automator
- [msmtp](http://msmtp.sourceforge.net) is used to send from Gmail (any mail service can be used, but Gmail will be easiest to use with this because the .msmtprc file is already set up for Gmail.)
- Credit to James Berry for [tag](https://github.com/jdberry) utility
- Credit to [Ryan Anderson](http://ryananderson.com.au/projects/everfiler/) for coming up with this. I just built on his idea.
- Thanks to [@KatieFloyd](https://twitter.com/katiefloyd) of [MacPowerUsers](http://www.macpowerusers.com) for bringing Ryan’s script to my attention.

## Installation

- Install [tag](https://github.com/jdberry/tag) (I use [Homebrew](http://mxcl.github.com/homebrew/))

- Install msmtp (http://msmtp.sourceforge.net)
	- Move `dot-mailrc.txt` file to ~/.mailrc
	- chmod 600 ~/.mailrc
	- Move `dot-msmtprc.txt` file to ~/.msmtprc
	- chmod 600 ~/.msmtprc
	- Edit ~/.msmtprc to use your Gmail account
	- NOTE: If you use 2-Factor Auth with Gmail (and you should!) you will need to make an app-specific password for `msmtp` at <https://security.google.com/settings/security/apppasswords>

- Open the script and edit the following:
  - The Notebook you’d like the document to be filed to (must already exist in Evernote)
  - Your private Evernote email address (look for the `enemail="YOUR EVERNOTE EMAIL ADDRESS HERE"` line :-)
  - Optional: Your [Pushover](https://pushover.net) credentials

- Create a "SendToEvernote" folder (you can call it whatever you want)
	- Add "SendToEvernote" folder to Hazel
	- import `SendToEvernote.hazelrules` to Hazel for that folder
	- After the file is processed by Hazel, it will be moved to your ~/Desktop/. If you'd like it to be moved somewhere else, change the last line of the Hazel rule.

## There are a few provisos, a couple of *quid pro quos*.

1.	The script (and the Hazel rule) will only work on PDFs (which is to say, files which end with ".pdf"). Additional filetypes could be added by editing `everfiler.sh` to send the proper MIME type, etc., but this seems like a lot of effort since making any file into a PDF on OS X is so easy. Plus, most of the files I want to send to Evernote are already PDFs.

2.	The Hazel rule assumes that `everfiler.sh` will be installed to `/usr/local/bin/everfiler.sh`. If you put it somewhere else, you'll have to change the Hazel rule to get it to work.


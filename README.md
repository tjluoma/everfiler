Everfiler
=========

A bash script to automate the filing of documents to Evernote via email including Mac OS X tags.

## General Notes

- I'm a scripting novice. This is the result of **days** of googling + trial and error.
- Designed to be used with [Hazel](http://www.noodlesoft.com/hazel.php) and/or Apple's Automator
- [msmtp](http://msmtp.sourceforge.net) is used to send from Gmail to avoid ISP issues with port 25
- Credit to James Berry for Tag utility (https://github.com/jdberry)


## Installation

- Install [Tag](https://github.com/jdberry/tag) (I use [Homebrew](http://mxcl.github.com/homebrew/))

- Install msmtp (http://msmtp.sourceforge.net)
	- Move `dot-mailrc.txt` file to ~/.mailrc
	- chmod 600 ~/.mailrc
	- Move `dot-msmtprc.txt` file to ~/.msmtprc
	- chmod 600 ~/.msmtprc
	- Edit ~/.msmtprc to use your Gmail account
	- NOTE: If you use 2-Factor Auth with Gmail (and you should!) you will need to make an app-specific password for msmtp at <https://security.google.com/settings/security/apppasswords>

- Open the script and edit the following:
  - The Notebook you'd like the document to be filed to
  - Your private Evernote email address
  - Your Pushover credentials (optional)

- Create a "SendToEvernote" folder (you can call it whatever you want)
	- Add "SendToEvernote" folder to Hazel
	- import `SendToEvernote.hazelrules` to Hazel for that folder
	- After the file is processed by Hazel, it will be moved to your ~/Desktop/. If you'd like it to be moved somewhere else, change the last line of the Hazel rule.

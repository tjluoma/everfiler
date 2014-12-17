#!/bin/zsh
#Everfiler: Hazel to Evernote w/ OS X tags
#Hacked together by Ryan Anderson (http://ryananderson.com.au)
#Ensure Mutt & Tag (https://github.com/jdberry/tag) are installed (I used Homebrew)
#Setup Mutt to send from gmail to avoid ISP issues with port 25
#Credit to James Berry for Tag utility (https://github.com/jdberry)


#Set the name of the destination Evernote notebook
notebook="NOTEBOOK NAME HERE"

#Set the name of the destination Evernote notebook
enemail="YOUR EVERNOTE EMAIL ADDRESS HERE"


if ((! $+commands[tag] ))
then
		# if 'tag' isn't found, complain, tell user how to fix, and quit
	echo "$NAME: 'tag' is required but not found in $PATH."
	echo "$NAME: Easiest fix: 'brew install tag'
	exit 1

fi

#Grab the file tags (using 'Tags') and store them in variable 'mavtags'
mavtags=$(tag --no-name * "$1")

#Manipulate $mavtags var to create hashtags
hashtags=$(echo -n "${mavtags}" | tr ',' '\n' | sed -e 's/^/#/')

#convert multiline $hashtags to single line var $entags
entags=$(echo -n "${hashtags}" | sed ':a;N;$!ba;s/\n/ /g')

#creating the name of the note
#remove the filepath
filename=$(basename "$1")
extension="${filename##*.}"
filename="${filename%.*}"

#Compose and send email using Mutt
/usr/local/bin/mutt -s "$filename @$notebook $entags" $enemail -a "$1" < /dev/null

#Send Notification to Pushover (optional)
curl -s \
  -F "token=YOUR TOKEN HERE" \
  -F "user=YOUR USER ID STRING HERE" \
  -F "message=$filename filed to @$notebook with tags: $entags" \
  https://api.pushover.net/1/messages.json

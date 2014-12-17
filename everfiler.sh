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

	# zsh: this gives you the name of the script without the path or extension
NAME="$0:t:r"

if ((! $+commands[tag] ))
then
		# zsh: 	if 'tag' isn't found anywhere in $PATH, then
		# 		complain, tell user how to fix, and quit.
	echo "$NAME: 'tag' is required but not found in $PATH."
	echo "$NAME: Easiest fix: 'brew install tag'"
	exit 1
fi

if ((! $+commands[msmtp] ))
then
	echo "$NAME: msmtp is required but not found in $PATH"
	echo "$NAME: Easiest fix: 'brew install mstmp' (however it also requires customization after install)"
	exit 1
fi


if [[ ! -f "$1" ]]
then
		# Does the arg exist as a file?
		if [[ ! -e "$1" ]]
		then
			echo "$NAME: $1 does not exist"
			exit 1
		else
			echo "$NAME: $1 is not a regular file."
			exit 1
		fi

fi

#Grab the file tags (using 'Tags') and store them in variable 'mavtags'
mavtags=$(tag --no-name * "$1")

#Manipulate $mavtags var to create hashtags
hashtags=$(echo -n "${mavtags}" | tr ',' '\n' | sed -e 's/^/#/')

#convert multiline $hashtags to single line var $entags
entags=$(echo -n "${hashtags}" | sed ':a;N;$!ba;s/\n/ /g')

#creating the name of the note
#remove the filepath
# in Zsh, $foo:t = 'the "tail" of $foo' i.e. the filename without the path
filename="$1:t"
# in Zsh, $foo:e = 'the extension of $foo'
extension="$1:e"

if [ "$extension:l" != "pdf" ]
then
	echo "$NAME only works with PDFs. Sorry"
	exit 1
fi


echo "To: $enemail
Mime-Version: 1.0
Subject: $1 @${notebook} ${entags}
X-Mailer: everfiler.sh
Content-Type: application/pdf; name=\"$1\"
Content-Transfer-Encoding: base64
Content-Disposition: inline; filename=\"$1\"

`base64 $1`" | msmtp --read-recipients


#Compose and send email using Mutt
# /usr/local/bin/mutt -s "$filename @$notebook $entags" $enemail -a "$1" < /dev/null

#Send Notification to Pushover (optional)
# PUSHOVER_TOKEN and PUSHOVER_USERNAME must be defined in ~/.zshenv

if [ "$PUSHOVER_USERNAME" != "" -a "$PUSHOVER_TOKEN" != "" ]
then
	curl -s \
		-F "token=$PUSHOVER_TOKEN" \
		-F "user=$PUSHOVER_USERNAME" \
		-F "message=$filename filed to @$notebook with tags: $entags" \
		https://api.pushover.net/1/messages.json

fi

exit 0
# EOF

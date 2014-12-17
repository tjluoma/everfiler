#!/bin/zsh
#Everfiler: Hazel to Evernote w/ OS X tags
#Hacked together by Ryan Anderson (http://ryananderson.com.au)
#Ensure Mutt & Tag (https://github.com/jdberry/tag) are installed (I used Homebrew)
#Setup Mutt to send from gmail to avoid ISP issues with port 25
#Credit to James Berry for Tag utility (https://github.com/jdberry)


	# zsh: this gives you the name of the script without the path or extension
NAME="$0:t:r"

#Set the name of the destination Evernote notebook (must already exist!)
notebook="Everfiler"


if [[ "$EVERNOTE_MAILTO" == "" ]]
then
		#Your Evernote mailto address
	enemail="YOUR EVERNOTE EMAIL ADDRESS HERE"
else
	enemail="$EVERNOTE_MAILTO"
fi

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
mavtags=$(tag --no-name "$1")

#Manipulate $mavtags var to create hashtags
hashtags=$(echo -n "${mavtags}" | tr ',' '\n' | sed -e 's/^/#/')

#convert multiline $hashtags to single line var $entags
entags=$(echo -n "${hashtags}" | tr '\n' ' ')

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
Subject: $filename @${notebook} ${entags}
X-Mailer: everfiler.sh
Content-Type: application/pdf; name=\"$1\"
Content-Transfer-Encoding: base64
Content-Disposition: inline; filename=\"$1\"

`base64 ${1}`" | msmtp --read-recipients

EXIT="$?"

if [ "$EXIT" = "0" ]
then
	MSG="$NAME: $filename filed to @$notebook with tags: $entags"

	echo "$MSG"

		#Send Notification to Pushover (optional)
		# PUSHOVER_TOKEN and PUSHOVER_USERNAME must be defined in ~/.zshenv

	if [ "$PUSHOVER_USERKEY" != "" -a "$PUSHOVER_TOKEN" != "" ]
	then
		curl -s \
			-F "token=$PUSHOVER_TOKEN" \
			-F "user=$PUSHOVER_USERKEY" \
			-F "message=$MSG" \
			'https://api.pushover.net/1/messages.json' 2>&1 >/dev/null
	fi
else
	msg "$NAME: Failed to send $filename (msmtp \$EXIT = $EXIT)"

	echo "$MSG"

	if [ "$PUSHOVER_USERKEY" != "" -a "$PUSHOVER_TOKEN" != "" ]
	then
		curl -s \
			-F "token=$PUSHOVER_TOKEN" \
			-F "user=$PUSHOVER_USERKEY" \
			-F "message=$MSG" \
			'https://api.pushover.net/1/messages.json' 2>&1 >/dev/null
	fi

	exit 1
fi



exit 0
# EOF

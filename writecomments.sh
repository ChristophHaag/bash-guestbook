#!/bin/sh

function cgi_decodevar()
{
   [ $# -ne 1 ] && return
   local v t h
   # replace all + with whitespace and append %%
   t="${1//+/ }%%"
   while [ ${#t} -gt 0 -a "${t}" != "%" ];
   do
      v="${v}${t%%\%*}" # digest up to the first %
      t="${t#*%}" # remove digested part
      # decode if there is anything to decode and if not at end of string
      if [ ${#t} -gt 0 -a "${t}" != "%" ]
         then h=${t:0:2} # save first two chars
         t="${t:2}" # remove these
         v="${v}"`echo -e \\\\x${h}` # convert hex to special char
      fi
   done
   # return decoded string
   echo "${v}"
   return
}

echo "Content-type: text/html"
echo
echo "<HTML><HEAD>"
echo "<TITLE>Comment written</TITLE></HEAD>"
echo "<body><h1>Comment hopefully written</h1>"

NICKU=$(echo "$QUERY_STRING" | sed -n 's/^.*nickname=\([^&]*\).*$/\1/p' | sed "s/%20/ /g" | sed "s/+/ /g")
MSGU=$(echo "$QUERY_STRING" | sed -n 's/^.*msg=\([^&]*\).*$/\1/p' | sed "s/%20/ /g" | sed "s/+/ /g")
WWWU=$(echo "$QUERY_STRING" | sed -n 's/^.*WWW=\([^&]*\).*$/\1/p' | sed "s/%20/ /g" | sed "s/+/ /g")
ADDRESSU=$(echo "$QUERY_STRING" | sed -n 's/^.*address=\([^&]*\).*$/\1/p' | sed "s/%20/ /g" | sed "s/+/ /g")

NICK=$(cgi_decodevar "$NICKU" | recode -pf ..html)
MSG=$(cgi_decodevar "$MSGU" | recode -pf ..html)
WWW=$(cgi_decodevar "$WWWU" | recode -pf ..html)
ADDRESS=$(cgi_decodevar "$ADDRESSU" | recode -pf ..html)
DATE=$(date +%s)

echo "$NICK|$DATE|$WWW|$ADDRESS|$MSG" >> "comments.txt"
echo "<div><u>I wrote</u><br>"
echo "<b>Nick:</b> $NICK<br>"
echo "<b>Date:</b> "$(date --date="@$DATE" +"%T %D")"<br>"
echo "<b>WWW:</b> $WWW<br>"
echo "<b>Address:</b> $ADDRESS<br>"
echo "<b>Message:</b> <pre>$MSG</pre></div>"
echo "<br>"
echo "<a href=""comments.sh"">back</a>"
echo "</body></html>"
exit 0

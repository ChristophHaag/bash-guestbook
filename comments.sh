#!/bin/sh
# (internal) routine to decode urlencoded strings

echo "Content-type: text/html"
echo
echo '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
       "http://www.w3.org/TR/html4/loose.dtd">'
echo "<HTML><HEAD>"
echo "<TITLE>Comments</TITLE>"
echo '<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />'
echo "</HEAD>"
echo "<body><h1>Comments</h1>"
echo '<div><u>Write comment (all fields optional)</u>:
<br><br><form action="writecomments.sh" method="GET">
   Nickname: <input type="text" name="nickname"><br>
   WWW: <input type="text" name="WWW"><br>
   contact address: <input type="text" name="address"><br><br>
   Text:<br>
   <textarea rows=10 cols=50 name="msg"></textarea><br>
   <input type="submit" value="Submit!">
</form></div>'
echo "<br><br>"
echo "<h3>Former Comments</h3>"
tac comments.txt | while read I
do
   NICK=$(echo "$I" | cut -f 1 -d "|")
   if [ ! -n "$NICK" ]
   then
      NICK="<i>an anonymous user</i>"
   fi
   DATE=$(date --date="@$(echo $I | cut -f 2 -d "|")" +"%T %D")
   WWW=$(echo $I | cut -f 3 -d "|" | grep -Eo "\b(https?|ftp|file)://[-A-Za-z0-9+&@#/%?=~_|!:,.;]*[-A-Za-z0-9+&@#/%=~_|]")
   ADDRESS=$(echo "$I" | cut -f 4 -d "|")
   MSG=$(echo "$I" | cut --complement -f 1-4 -d "|" | sed "s/&#13;/<br>/g" | recode html/..)
   echo '<div style="border:solid 1px; width:50em; padding: 1em">'
   echo "<p><b>$NICK</b> said at <b>$DATE</b></p><hr>"
   echo "<div><p>$MSG</p></div>"
   if [ -n "$WWW" ] || [ -n "$ADDRESS" ]
   then
      echo "<hr />"
   fi
   if [ -n "$WWW" ]
   then
      echo "<p>WWW: <a href=\"$WWW\">$WWW</a></p>"
   fi
   if [ -n "$ADDRESS" ]
   then
      echo "<p>Address: $ADDRESS</p>"
   fi
   echo "</div><br>"
done
echo "</body></html>"
exit 0

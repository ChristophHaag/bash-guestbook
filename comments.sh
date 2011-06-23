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
   eepsite: <input type="text" name="eepsite"><br><br>
   Text:<br>
   <textarea rows=10 cols=50 name="msg"></textarea><br>
   <input type="submit" value="Submit!">
</form></div>'
echo "<br><br>"
echo "<h3>Former Comments</h3>"
tac comments.txt | while read I
do
   NICK=$(echo "$I" | cut -f 1 -d "|")
   DATE=$(date --date="@$(echo $I | cut -f 2 -d "|")" +"%T %D")
   EEPSITE=$(echo $(echo $I | cut -f 3 -d "|") | grep -Eo "http://[a-z0-9/-_\.]*")
   MSG=$(echo "$I" | cut --complement -f 1-3 -d "|" | sed "s/&#13;/<br>/g")
   echo '<div style="border:solid 1px; width:50em; padding: 1em">'
   echo "<p>$NICK said at $DATE</p><hr>"
   echo "<div>$MSG</div>"
   if [ -n "$EEPSITE" ]
   then
      echo "<a href=\"$EEPSITE\">$EEPSITE</a>"
   fi
   echo "</div><br>"
done
echo "</body></html>"

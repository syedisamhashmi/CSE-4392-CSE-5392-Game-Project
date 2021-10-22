import re
import meetings_and_attendance_calculator

text2 = meetings_and_attendance_calculator.printStats()

filehandle = open('README.md', 'r')
readmeContent = str(filehandle.read())
filehandle.close()

newReadmeContent = re.sub(r'<div>.*</div>', "<div>\n\n" + text2 + "\n</div>" , readmeContent, flags= re.MULTILINE | re.DOTALL)

filehandle = open('README.md', 'w')
filehandle.write(newReadmeContent)
filehandle.close()

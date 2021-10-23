import os


def printStats():
    statsString = ""
    scriptDir = os.path.dirname(os.path.realpath(__file__))
    print(scriptDir)
    meeting_dir = os.path.join(scriptDir, 'Meetings_And_Attendance')
    print(meeting_dir)

    groupMembers = {
        'Hashmi, Syed Isam': {"count": 0, "dot": ''},
        'Kressler, Edward': {"count": 0, "dot": ''},
        'Hullikunte, Natraj': {"count": 0, "dot": ''},
        'Balusamy Siva, Balamurale': {"count": 0, "dot": ''},
        'Gurrapusala, Sundeep Kumar': {"count": 0, "dot": ''},
    }
    meetingCount = 0
    files = os.listdir(meeting_dir)
    files.sort()
    for filename in files:
        if filename.endswith(".csv"):
            print(filename)
            meetingCount += 1
            filename = os.path.join(meeting_dir, filename)
            filehandle = open(filename, 'r')
            text = filehandle.read()
            filehandle.close()

            for member in groupMembers:
                if member in text:
                    groupMembers[member]["count"] += 1
                    groupMembers[member]["dot"] += '✅'
                else:
                    groupMembers[member]["dot"] += '❌'

    print()

    formatted = "%-{count}s".format(count = meetingCount * 2)
    header = "|%-30s| {formatted} | %s|".format(formatted=formatted) % (" Name", "Attendance", "Percentage")
    headerLines = "|%s|-%s-|-%s|".format(formatted=formatted) % ("-"*30, "-" * meetingCount , '-' * len("Percentage"))
    statsString += header + '\n'
    statsString += headerLines + '\n'
    for member in groupMembers:
        statsString += "|%-30s| %s |  %6s%%  |" % (member, 
                    str(groupMembers[member]["dot"]), 
                    "%3.2f" % ((groupMembers[member]["count"] / meetingCount) * 100)
                ) + '\n'
    return statsString
if __name__ == '__main__':
    print(printStats())
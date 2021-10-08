import os

scriptDir = os.path.dirname(os.path.realpath(__file__))
print(scriptDir)
meeting_dir = os.path.join(scriptDir, 'Meetings_And_Attendance')
print(meeting_dir)

groupMembers = {
    'Hashmi, Syed Isam': 0,
    'Kressler, Edward': 0,
    'Hullikunte, Natraj': 0,
    'Balusamy Siva, Balamurale': 0,
    'Gurrapusala, Sundeep Kumar': 0,
    
}

meetingCount = 0
for filename in os.listdir(meeting_dir):
    if filename.endswith(".csv"):
        meetingCount += 1
        filename = os.path.join(meeting_dir, filename)
        filehandle = open(filename, 'r')
        text = filehandle.read()
        filehandle.close()

        for member in groupMembers:
            if member in text:
                groupMembers[member] += 1
    #     print(os.path.join(directory, filename))
    # else:
    #     continue

print("Total Meetings: " + str(meetingCount))
for member in groupMembers:
    print(member + ": " + str(groupMembers[member]))
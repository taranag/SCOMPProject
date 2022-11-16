# Convert sheet music to asm file



def noteToPattern(note, octave, sharp=0):
    octave = octave - 2
    
    if note == 'C':
        noteString = "0010000"

    elif note == 'D':
        noteString = "0001000"

    elif note == 'E':
        noteString = "0000100"

    elif note == 'F':
        noteString = "0000010"

    elif note == 'G':
        noteString = "0000001"

    elif note == 'A':
        octave = octave + 1
        noteString = "1000000"

    elif note == 'B':
        octave = octave + 1
        noteString = "0100000"
    
    else:
        return 0

    octaveString = '{0:03b}'.format(octave)
    return str(sharp) + "00000" + octaveString + noteString


def getNoteTuple(note, octave):
    if len(note) == 1:
        return noteToPattern(note, octave, 0)
    elif len(note) == 2:
        if note[1] == '#':
            return noteToPattern(note[0], octave, 1)
        else:
            return noteToPattern(note[1], octave, 0)
    else:
        return noteToPattern(note[0], octave, 0)


def getNoteDictionary(askOctave=True):
    # take user input and convert to list of notes
    noteList = []
    while True:
        note = input("Enter note: ")
        if note == "end":
            break
        if askOctave:
            octave = int(input("Enter octave: "))
        else:
            octave = 4
        beats = int(input("Enter beats: "))
        noteList.append((getNoteTuple(note, octave), beats))

    return noteList


    

print(getNoteDictionary())
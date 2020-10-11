import numpy as np
import cv2
import time
import serial

#serialSetup and seriaCom are functions to set up the robotic 
#arm and commands
def serialSetup():
    robot = serial.Serial()
    robot.baudrate = 9600
    robot.port = 'COM11'
    robot.open()
    robot.write(b'#0P1614T2000#1P1560#2P1458#3P1500#4P1500\r')
    return robot

#helper function to send a command
#parameters are channel(joint), frequency, and speed of movement
def serialCom(robot, channel, pulseWidth, speed):
    output = "#" + channel +"P" + pulseWidth + "T" + speed + "\r"
    output = output.encode('utf-8')
    robot.write(output)
    
#checkColor detects colors' pixel counts and returns color if above certain threshhold
#function checks for red, blue, and yellow
def checkColor(rd, bl, yl):
    if rd > 1500:
        return 'red'
    
    elif bl > 8500:
        return 'blue'
    
    elif yl > 8000:
        return 'yellow'

#function to change positions for all chanels in one command 
def go(arr):
    for i in range(5):
        var = str(i)
        serialCom(robot, var, arr[i], "1500")
        time.sleep(1)
def goRest(arr):
    for i in range(5):
        var = str(i)
        serialCom(robot, var, arr[i], "1500")

#calling serialSetup function        
robot = serialSetup()

#opening the camera
cap = cv2.VideoCapture(0)

#intializing colors array for sorting
colorArr = ['na', 'na', 'na']


##these array are preset locations of where the robot will check for colored objects 
##and sort them to their initial positions for scanning objects' colors
positions = ['1808' , '1379', '984']

#a list of lists for positions of the three initial positions with the gripper at
#750 in first array to reach each position with the gripper open and 2000 in the second array to pick objects from each position
chgo = [['1960', '1610', '1190'], ['1760', '1650', '1655'], ['2027','1960','1950'], ['960','950', '940'],['750', '750', '750']]
chpi = ch = [['1960', '1610', '1190'], ['1760', '1650', '1655'], ['2030','1960','1950'], ['960','950', '940'],['2000', '2000', '2000']]

#arrays for positions of sorted objects. 
#Each with two arrays to move to position in the first array and close gripper 
#in the second array
redSort = ['1600', '1456','1740','940','2000']
redDrop = ['1600', '1456','1740','940','750']
blueSort = ['1290', '1490', '1780', '1010', '2000']
blueDrop = ['1290', '1490', '1780', '1010', '750']
yellowSort = ['1825', '1380', '1610', '940', '2000']
yellowDrop = ['1825', '1380', '1610', '940', '750']

#arrays to go to rest with gripper open and gripper closer, respectively 
rest = ['1614', '1560', '1458', '940', '750']
restP = ['1614', '1560', '1458', '1500', '2000']

go(rest)

time.sleep(1)

#loop to read from camera, move the robotic arm to detect objects' colors, and return an array of the colors of the objects
for i in range(3):
    string = str(0)
    serialCom(robot, string, positions[i], "1000")
    time.sleep(2)
    _, frame = cap.read()
    hsv_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
    
    #red color
    low_red = np.array([161, 155, 84])
    high_red = np.array([179, 255, 255])
    red_mask = cv2.inRange(hsv_frame, low_red, high_red)
    red = cv2.bitwise_and(frame, frame, mask=red_mask)
    #blue color
    low_blue = np.array([100, 150, 2])
    high_blue = np.array([140, 255, 255])
    blue_mask = cv2.inRange(hsv_frame, low_blue, high_blue)
    blue = cv2.bitwise_and(frame, frame, mask=blue_mask)
    
    
    #yellow color
    low_yellow = np.array([20, 100, 100])
    high_yellow = np.array([30, 255, 255])
    yellow_mask = cv2.inRange(hsv_frame, low_yellow, high_yellow)
    yellow= cv2.bitwise_and(frame, frame, mask=yellow_mask)
        
    #every color except white
    low = np.array([0, 42, 0])
    high = np.array([179, 255, 255])
    mask = cv2.inRange(hsv_frame, low, high)
    result = cv2.bitwise_and(frame, frame, mask=mask)
        
        
    rd = cv2.countNonZero(red_mask)
    bl = cv2.countNonZero(blue_mask)
    yl = cv2.countNonZero(yellow_mask)
    
    colorArr[i] = checkColor(rd, bl ,yl)
    
go(rest)
print('The order of colors is: ', colorArr)
time.sleep(1)

#loop to pick up objects from initial positions and sort them by color
for i in range(3):
    time.sleep(1)
    #move robotic arm to position i
    for j in range(5):
        var = str(j)
        variable = 'chanel_'+ var
        serialCom(robot, var, chgo[j][i], "1000")
        time.sleep(1)
    
    #pick up from position i
    for k in range(5):
        var = str(j)
        variable = 'chanel_'+ var
        serialCom(robot, var, chpi[j][i], "1000")
    time.sleep(1)  
        
    
    goRest(restP)
    time.sleep(2)
    #sort object in position i based on its color
    if colorArr[i] == 'red':
        go(redSort)
        go(redDrop)
        time.sleep(1)
        goRest(rest)

    elif colorArr[i] == 'blue':
        go(blueSort)
        time.sleep(1)
        go(blueDrop)
        goRest(rest)

    elif colorArr[i] == 'yellow':
        go(yellowSort)
        go(yellowDrop)
        time.sleep(1)
        goRest(rest)
    #if color is not found drop object around the edge of the workspace  
    else:
        for i in range(5):
            var2 = str(i)
            serialCom(robot, var2, rest[i], "10")

   
go(rest)
   
robot.close()
cap.release()
cv2.destroyAllWindows()


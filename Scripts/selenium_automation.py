#For proper Utilization of this Script, you need to provide 3 parameters from Qualtrics survey end

#1) URL or Name of Platform
#2) Unique_ID
#3) Marg_ID

import mysql.connector
import time
from selenium import webdriver
from selenium.common.exceptions import NoSuchWindowException
from datetime import datetime
 

#This is for my Database in MYSQL , you can replace with other database

mydb = mysql.connector.connect(
  host="localhost",
  user="root",
  password="Vaibhav@2003",
  database="r_shiny"
)

#Community Guidelines Dictionary
social_media= {
    "Facebook": "https://www.facebook.com/communitystandards/",
    "Twitter": "https://help.twitter.com/en/rules-and-policies/twitter-rules",
    "Instagram": "https://help.instagram.com/477434105621119/",
    "LinkedIn": "https://www.linkedin.com/help/linkedin/answer/34593/",
    "YouTube": "https://www.youtube.com/yt/about/policies/",
    "Snapchat": "https://www.snapchat.com/communityguidelines",
    "Pinterest": "https://policy.pinterest.com/en/community-guidelines",
    "TikTok": "https://www.tiktok.com/community-guidelines/",
    "Reddit": "https://www.redditinc.com/policies/content-policy",
    "Tumblr": "https://www.tumblr.com/policy/en/community",
    "WhatsApp": "https://www.whatsapp.com/legal/community-guidelines/",
    "Discord": "https://discord.com/guidelines",
    "Twitch": "https://www.twitch.tv/p/legal/community-guidelines/",
    "Quora": "https://www.quora.com/about/tos",
    "Medium": "https://help.medium.com/hc/en-us/articles/360043088532-Community-Guidelines"
}

# Declaring Unique ID and Marg_ID
unique_id = 63
marg_id = 'marg_1'
website="Facebook"

# checking for connection from Database
if mydb.is_connected():
    db_Info = mydb.get_server_info()
    print("Connected to MySQL Server version ", db_Info)
    mycursor = mydb.cursor()
    mycursor.execute("select database();")
    record = mycursor.fetchone()
    print("You're connected to database: ", record)

#Initialising webdriver
driver = webdriver.Chrome()
# Get screen width and height
screen_width = driver.execute_script("return window.screen.availWidth;")
screen_height = driver.execute_script("return window.screen.availHeight;")

# Calculate new window size and position
new_width = screen_width // 2  # Take half of the screen width
new_height = screen_height  # Take full screen height
new_x = 0  # Start from the left edge of the screen
new_y = 0  # Start from the top of the screen

# Set the window size and position
driver.set_window_size(new_width, new_height)
driver.set_window_position(new_x, new_y)


url=social_media[website]
driver.get(url)

#setting current url and title
current_url = driver.current_url
current_title = driver.title




#Adding initial entry to Database before going to loop
sql = """INSERT INTO browserhistory (Unique_ID, Marg_ID, time, title, url) VALUES (%s, %s, %s, %s, %s)"""
formatted_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
val = (unique_id, marg_id, formatted_datetime, current_title,current_url)
mycursor.execute(sql, val)
mydb.commit()


#Now this look will terminate once you will close the chrome window, that means till then all the links and entries will be inserted into Database
while True:
    # Check if URL or title has changed
    new_url = driver.current_url
    new_title = driver.title
    
    if new_url != current_url or new_title != current_title:
        print("URL:", new_url)
        print("Title:", new_title)
        
        current_url = new_url
        current_title = new_title
        sql = """INSERT INTO browserhistory (Unique_ID, Marg_ID, time, title, url) VALUES (%s, %s, %s, %s, %s)"""
        formatted_datetime = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        val = (unique_id, marg_id, formatted_datetime, new_title,new_url)
        mycursor.execute(sql, val)
        mydb.commit()
        print("Record Updated Succesfully")
        
    try:
        driver.title
    except NoSuchWindowException:
        print("Browser window closed by user. Exiting the script.")
        break
    # Wait for a short period
    time.sleep(1)
    
    
#Comment this section if you dont want to see the table
mycursor.execute("SELECT * FROM browserhistory")
result=mycursor.fetchall()
for row in result: 
    print(row) 
    print("\n")
    
# Closing Database and Browser
driver.close()
mycursor.close()
if mydb.is_connected():
    print("Closing the Database")
    mydb.close()
#End of Code
    


# d_zoneeee

A Flutter project.


The whole Intention of this app is to map deadzones and create a report. So whats the use? Yup to answer that , its an attempt to create an report showing all the deadzones mapped, so ISPs can use this data if required for better implementation of their network towers.

How does it work?
A basic signin procedure  with a home page (which uses Firebase to collect data like email and user name) and then we mainly have 4 Categories 
i) Map- integrating Google maps with help of flutter console to get realtime map and loaction tracking. Here the interface has a "Report Location" option which marks the currect location of user as an deadzone . Note that I can't map my clg as a deadzone while sitting at home, it only marks current loaction. All users can see the dead zones reported by any other user on the map with a red mapping.

ii) Weekly reports- This is the interface to show users how many DeadZones were mapped in that particular month in a weekly category (bargraph).

iii) DeadZones- Lists all the DeadZones with exact lat,lng and approximate Place name.

iv) Streak - An attempt to improvise user interaction by providing a streak medal based on the no of zones they mapped.

Home page also has a profile page with users email username ans signout as options with Random Gravatars assigned to their profile on their first signin. It also has a feed back floating incon in the bottom right os screen and thats also to improve user interaction.




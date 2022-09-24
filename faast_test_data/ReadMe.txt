1. data from FAST
It's raw data, and we store the 256 complex channelized data in the file. 
Each channel data consists fo a int8 real part and a int8 imaginary part.
The file format is re0, im0, re1, im1...re255, im255.
We do 64K channelization, and we store the data from channel 27392.

From the filename, we can get some information: 
(1) m14--the data file is generated on m14;
(2) 10.5G01.45G--the frequency range is from 1.05GHz to 1.45GHz;
(3) MB--the receiver is a multi-beam receiver;
(4) 02--beam number is 02;
(5) 00-- the data is from polization0
(6) 20220434--the data file was created on 04/23/2022;
(7) 113945--the data file was created at 11:39:45
(8) 326128005--this is the nanosecond value.

2. redis information
We get the postion information from the redis database very second.
The first key-"time" is the unix time from the compute node, other keys are read from the redis database.

3. the matlab code I used for processing the data

4. the processed result
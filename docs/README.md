# getprocess
[![GitHub license](https://img.shields.io/badge/license-Apache%202.0%20License-green?style=flat)](https://github.com/CastellaniDavide/cpp-getprocess/blob/master/LICENSE) ![Author](https://img.shields.io/badge/author-Castellani%20Davide-green?style=flat) ![Version](https://img.shields.io/badge/version-v01.03-blue?style=flat) ![Language Python](https://img.shields.io/badge/language-Python-yellowgreen?style=flat) ![sys.platform supported](https://img.shields.io/badge/OS%20platform%20supported-All-blue?style=flat) [![On GitHub](https://img.shields.io/badge/on%20GitHub-True-green?style=flat&logo=github)](https://github.com/CastellaniDavide/getprocess) 

## Description
This code is made to make easier for you take some info about every thread on your PC.
You can run this code in two modalities:
 - GUI mode: user-friendly and easy to use
   - Follow the options on the screen
 - CLI mode: this is the pro mode, I suggest this if you want to use this into a PIPE of programs, or other advanced uses
   - ```-flussiFolder``` : Set the csv file(s) 
   - ```-logFile``` : Set the log position
   - ```-harperLink``` :  Set the HarperDB link
   - ```-harperToken``` : Set the HarperDB Token
   - ```-harperTable``` : Set the HarperDB Table
   - ```-harper``` :  Enable/ Disable HarperDB
   - ```-GUI``` : Enable/ Disable GUI
   - ```-booldebug``` : Enable/ Disable verbose

An example of GUI:
![Example GUI](https://raw.githubusercontent.com/CastellaniDavide/getprocess/v01.03/docs/example.png)

## Required
![](http://jeffnielsen.com/wp-content/uploads/2014/06/required-cropped.png)
 - Windows (v10 or more)

## Directories structure
![](https://cdn.analyticsvidhya.com/wp-content/uploads/2019/05/data-science-framework.png)
 - .gitignore
 - LICENSE.md
 - .github
   - ISSUE_TEMPLATE
     - bug_report.md
     - feature-request.md
 - docs
   - \*.md
 - flussi (example output)
   - getprocess.csv
 - log (example log)
   - trace.log
 - getprocess
   - src
     - getprocess.ps1
   
### Execution examples  
![](https://blog.toadworld.com/hs-fs/hubfs/SQL_tools-8_ways_large.jpg?width=3248&name=SQL_tools-8_ways_large.jpg)
 - Go into the powershell code folder
 - Write on the shell: ```powershell .\getprocess.ps1``` (by defaults it runs int GUI mode)
 - Some parameters (usable only if you disable GUi mode):
   - ```-flussiFolder```: set the folder where save CSV file, by default "..\\flussi"
   - ```-logFile```: set the folder where save log info, by default "..\\..\\log\\trace.log"
   - ```-GUI```: enable or disable GUI mode (only 0 or 1 accepted), by default 1
   - ```-booldebug```: enable or disable debug mode (only 0 or 1 accepted), by default 0
   
### Output location
![](https://www.macroeconomia.it/wp-content/uploads/2018/03/input-output-650x364.png)
 - *.csv (if enabled) in the location where the code was lauched
 - *.log
   - C:/Program Files/getprocess/* on Windows
   - ~/* on linux
   - current location (if you didn't lauch the code with the correct rights)

---
Made by Castellani Davide 
If you have any problem please contact me:
- help@castellanidavide.it
- [Issue](https://github.com/CastellaniDavide/getprocess/issues)

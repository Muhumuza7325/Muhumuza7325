# About the Developer

- Hi, I’m @Muhumuza7325
- A passionate scientist currently exploring Bioinformatics.
- Driven by the vision to contribute to the transformation of education in Uganda and globally.
- You can connect to me via email: muhumuzaomega@gmail.com

## Installation Instructions for MacOS and Linux

1.  **Create the Omd directory:**
    Open your file manager. Navigate to your home directory (usually represented by a house icon or your username). If a directory named `Omd` does not exist, create a new directory and name it `Omd`. Make sure only "O" is uppercase.

2.  **Extract and Make Executable the Scripts:**
    Open the downloaded ZIP archive and locate the files ending with `_tutorial.sh`. Extract these files into the `Omd` directory you just created in your home directory. Choose files bearing the names of the subjects you are interested in.

    Next, you need to make these files executable. Type `sudo chown -R omd:omd ~/Omd` (Remember to change omd to your user name e.g., `sudo chown -R irene:irene ~/Omd`) in the terminal and press Enter (if you don't know what and where the terminal is, search for it from the Apps on your computer). Also type `sudo chomd -R 777 ~/Omd` in the terminal and press Enter. These two commands give the scripts permission to run.

3.  **Extract the Desktop Shortcuts:**
    Locate the files ending with `_tutorial.desktop` in the downloaded ZIP archive. Extract these files to your Desktop. Equally choose files bearing the names of the subjects you are interested in.
    
4.  **Extract and Rename the Logo:**
    From the downloaded ZIP archive, find the file named `logo.jpeg`. Extract this file into the `Omd` directory in your home directory. This will allow the desktop shortcut to have our logo. Once it's there, rename the file to `.logo.jpeg` (note the dot at the beginning). This often makes the file hidden in some file managers. 

5.  **Delete the downloaded Zip archive (Optional):**
    At this stage (After extracting all the necessary files). You are free to delete the downloaded ZIP archive.

6.  **Allow Launching the Shortcuts:**
    Go to your Desktop and find the desktop files ending with `_tutorial.desktop`. Right-click on each. Look for an option that allows you to trust or allow launching the application. This might be in a "Permissions" tab or a context menu option like "Allow Launching" or similar. Enable this for each.

7.  **Start Learning:**
    Thank you for installing the Educational Pipeline. To begin your learning journey, simply double-click on any of the shortcuts. Please note that content for some subjects is still under development. We wish you all the best in your studies and look forward to your continued cooperation. If you have any questions or run into any difficulties, please feel free to contact us. Also remember to contact us for details on how to integrate AI (Artificial intelligence) for free into the pipeline.


## Installation Instructions for Windows (10 & above) users

1.  **Install Ubuntu 24.04.1 LTS from the microsoft store:**
    Open your microsoft store. Copy and paste "Ubuntu 24.04.1 LTS" into the search bar. Click on it and then get it by clicking the get option... You will require a minimum of 400MB for the download.

2.  **Update the windows subsystem of linux:**
    Search for "Windows PowerShell" using the computer search bar or icon, and then choose the option to Run as Administrator. On the terminal that opens, copy and paste the command "wsl --update"... Don't include the quotation marks and then press enter. Leave the update to complete. This too will require some internet.

3.  **Allow windows to detect the Windows Subsystem for Linux:**
    Search for "Control Panel" using the computer search bar or icon, and then click it. Choose Programs. Then under Programs and Features, click on "Turn Windows features on or off. From the opened tab, scroll down and check the box behind Windows Subsystem for Linux. Then press OK. Wait on as the features are being incorporated and click on the restart option provided. This will restart your computer and its only after restarting that you can be able to use the application.

4.  **Set up Ubuntu:**
    After restarting, search for "Ubuntu 24.04.1 LTS" using the computer search bar or icon, and then click it. It should open without any errors, if it doesn't, please contact us via our contacts. If it does, set your username using lowercase letters, keep it as short as possible... Then also set your password... I would request you use your name as your password because we may need it to trouble shoot some things one day and if you forgot it, we will have to repeat all the above steps. The password isn't shown as you type it, so don't get worried... Enter it and press enter, then confirm it by re-entering it again and pressing enter.

5.  **Create the Omd folder:**
    Open your file manager. Copy and paste "\\wsl.localhost\Ubuntu-24.04\home". Don't include the quotation marks and then press enter. A folder labelled with the username you provided will be present. Open that folder and create a new folder in it and name that new folder `Omd`. Make sure only "O" is uppercase. 

6.  **Extract and Make Executable the Scripts:**
    Open the downloaded ZIP archive and locate the files ending with `_tutorial_wsl.sh`. Extract these files into the `Omd` folder you just created in the step above. Choose files bearing the names of the subjects you are interested in.

    Next, you need to make these files executable. Open your Ubuntu application again (you can refer to step 4). Type `sudo chown -R omd:omd ~/Omd` (Remember to change omd to your user name e.g., `sudo chown -R irene:irene ~/Omd`) in the terminal and press Enter. Also type `sudo chomd -R 777 ~/Omd` in the terminal and press Enter. These two commands give the scripts permission to run.

7.  **Extract the Desktop Shortcuts:**
    Locate the files ending with `.Ink` in the downloaded ZIP archive. Extract these files to your Desktop (You could later move them to any other location). Equally choose files bearing the names of the subjects you are interested in.

8.  **Extract and Rename the Logo:**
    From the downloaded ZIP archive, find the file named `logo.ico`. Extract this file into the Pictures folder on your PC (You can extract it to any other folder you want). Once it's there, rename the file to `.logo.ico` (note the dot at the beginning). This often makes the file hidden in some file managers.

9.  **Modify the target and icon of each Shortcut:**
    NOTE carefully that you have to individually edit the target and icon of each shortcut. You will have to go where you extracted your shortcuts to, right click each shortcut, choose properties, and look at the target. In the case of say chemistry, (C:\Windows\System32\bash.exe -c '/home/omd/Omd/chemistry_tutorial_wsl.sh') will be the target. Make sure to replace the word `omd` in the target to your username e.g., to (C:\Windows\System32\bash.exe -c '/home/irene/Omd/chemistry_tutorial_wsl.sh'). Jumping this step will not allow you to run the pipeline using the shorcut. After changing the target, also change the icon [Right below the target of each icon, click on the change Icon tab and select the icon right from the folder you placed it in]. This will allow each shortcut to have our logo. 

10.  **Delete the downloaded Zip archive (Optional):**
    At this stage (After extracting all the necessary files). You are free to delete the downloaded ZIP archive.

11.  **Launch the application and start learning:**
    Thank you for installing the Educational Pipeline. To begin your learning journey, simply double-click on any of the shortcuts. Please note that content for some subjects is still under development. We wish you all the best in your studies and look forward to your continued cooperation. If you have any questions or run into any difficulties, please feel free to contact us. Also remember to contact us for details on how to integrate AI (Artificial intelligence) for free into the pipeline.


## License

All work in this repository is licensed under the Creative Commons Attribution-NonCommercial (CC BY-NC) license. This license allows others to share and adapt the material for non-commercial purposes, as long as they give appropriate credit and do not apply additional restrictions.

### Attribution Requirements

If you use or adapt any files from this repository, you must give appropriate credit. Please provide a link to the license and indicate if changes were made. You can include the following attribution statement in your work:

"[File Name] from [Muhumuza7325] by @Muhumuza7325 is licensed under CC BY-NC 4.0. To view a copy of this license, visit [https://github.com/Muhumuza7325/Muhumuza7325/blob/main/LICENSE.txt]."

### License Information

To view a copy of the CC BY-NC license, see the [LICENSE.txt](LICENSE.txt) file.

Please note that this license may not provide all the permissions necessary for your intended use. Other rights, such as publicity, privacy, or moral rights, may limit how you use the material.


## License

All work in this repository is licensed under the Creative Commons Attribution-NonCommercial (CC BY-NC) license. This license allows others to share and adapt the material for non-commercial purposes, as long as they give appropriate credit and do not apply additional restrictions.

### Attribution Requirements

If you use or adapt any files from this repository, you must give appropriate credit. Please provide a link to the license and indicate if changes were made. You can include the following attribution statement in your work:

"[File Name] from [Muhumuza7325] by @Muhumuza7325 is licensed under CC BY-NC 4.0. To view a copy of this license, visit [https://github.com/Muhumuza7325/Muhumuza7325/blob/main/LICENSE.txt]."

### License Information

To view a copy of the CC BY-NC license, see the [LICENSE.txt](LICENSE.txt) file.

Please note that this license may not provide all the permissions necessary for your intended use. Other rights, such as publicity, privacy, or moral rights, may limit how you use the material.
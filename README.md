# BethDdsScale-Ps

### STATUS: DEVELOPMENT
Still being created, not even done the basic testing, most of it is figured out and implemented...
- Test out the new blinging pre-processing configuration menu, fix issues..
- Make the program actually, point to and work from, the data folder, instead of fallout 4/game folder or whatever is current, this way compatible with other games with dds/ba2 data folder.
- Check if the program works from the, data or game, folder, it should work from the data folder, not just textures folder, then compatible with other games.
- Do a once over on all the scripts, make sure everything is seemingly ok, then try do some improvements. 
- Setup fake data dir etc, Test, Testing results into updates for scripts, complete scripts.
- add centering on the data folder location line, as the whopping steam line, is not how it will look for people whom have a separate large programs drive.

### DESCRIPTION
DdsBethScale-Ps, designed for Fallout 4, epitomizes efficiency and user-friendliness in Fallout 4 texture processing. It processes both loose and BA2 textures, optimizing them with DX1 or DX7 compression for non-transparent and transparent textures, respectively. DdsBethScale-Ps adjusts resolutions to user selection of, 2048x* or 1024x* or 512x*, maintaining aspect ratios. Its interface is intuitive, and it provides detailed output, including texture names and resolutions. DdsBethScale-Ps is optimized for speed, extracting files from Ba2, then updating the textures folder only back to the original Ba2, instead of re-compressing ba2 files. There are indeed other DDS conversion tools for Fallout 4, but the standout features will be:
1. the GPU selection, if you have multiple graphics card, specify your GPUs of choice to accelerate processing
2. additionally DdsBethScale-Ps will be processing all the textures, loose and in ba2 files, at the same time, it will be a "fire em off and make yourself a cup of tea" kind of tool, instead of, complex configuration or time wasted processing individual Ba2'2 files. 

### FEATURES
- **Resolution Adjustment**: Dynamically scales textures exceeding a target resolution, maintaining aspect ratio.
- **Format Conversion**: Intelligently converts textures to DirectX formats, considering transparency.
- **BA2 Archive Compatibility**: Processes textures within `.ba2` files, extracting, converting, and repacking efficiently.
- **GPU Selection**: Leverages the power of specified GPUs, enhancing processing speed and efficiency.
- **User-Friendly Interface**: Offers an easy-to-navigate menu system, simplifying the texture processing workflow.
- **Detailed Output**: Provides comprehensive feedback during processing, including texture names and resolutions.

### PREVIEW
```
   ____      _     ____        ____  ____           _
  |  _ \  __| |___| __ )  ____|___ \|  _ \ ___  ___(_)_______
  | | | |/ _  / __|  _ \ / _  \ __) | |_) / _ \/ __| |_  / _ \
  | |_| | (_| \__ \ |_) | (_| |/ __/|  _ <  __/\__ \ |/ /  __/
  |____/ \__,_|___/____/ \__,_|_____|_| \_\___||___/_/___\___|

======================( DdsBethScale-Ps )======================

             ---( Pre-Processing Configuration )---



                    1. Data Folder Location
  C:\Program Files (x86)\Steam\steamapps\common\Fallout 4\data

                 2. textures\Actors\Character
                           Process

                    3. Max Image Resolution
                           RATIOx1024

                     4. Graphics Processor
                  Radeon (TM) RX 470 Graphics




---------------------------------------------------------------
Select, Menu Options=1-3, Begin Resizing=B, Exit Program=X:

```
```
18:45: Texture Processing Started...

Loose Texture Processing...
Image1.dds: Resized 1024x512-BC3.
...Loose Textures Processed.

Ba2 Texture Processling...
TexturesArchive1.ba2: Unpacking Contents.
Image4.dds: Dimensions Compliant.
Image5.dds: Resized 1024x1024-BC3.
TexturesArchive1.ba2: Contents RePackaged.
...Ba2 Files Processed.

18:50: ...Texture Processing Completed.
```
```
   ____      _     ____        ____  ____           _
  |  _ \  __| |___| __ )  ____|___ \|  _ \ ___  ___(_)_______
  | | | |/ _  / __|  _ \ / _  \ __) | |_) / _ \/ __| |_  / _ \
  | |_| | (_| \__ \ |_) | (_| |/ __/|  _ <  __/\__ \ |/ /  __/
  |____/ \__,_|___/____/ \__,_|_____|_| \_\___||___/_/___\___|

======================( DdsBethScale-Ps )======================

               ---( Post-Processing Summary )---

                       Processing Stats:
                 Start: 22:33, Duration: 03:13
                   Processed: 57, Passed: 23  
                 Saved: 14.2 MB, Reduction: 9%                  

                        Resulting Scores: 
	          Current: 6.67, Previous: 5.50
                   Highest: 8.20, Lowest: 4.75
              
                           Verdict: 
                      Average Score! (o_o)

---------------------------------------------------------------
Select, Error Log=E, Exit Program=X:

````

### USAGE
1. Run `Setup-Install.Bat` to, install required libraries and create program folders.
2. Run `AllTexConFO4.Bat` to start the script.
3. Select the desired maximum resolution for textures from menu.
4. Choose the GPU for processing textures.
5. Let the script process the textures in your Fallout 4 directory.
6. Upon completion, processed textures are saved, and the script reports the status.

### REQUIREMENTS
- PowerShell =>4.0 (Win =>8.1, or get 5.1 Update) or Powershell Core =>7.
- Installed Fallout 4 game, any, version and mods, will be fine.
- Library Requirements installed by `Setup-Installer.Bat`.
- Git, required by installer for, "7za" and "DirectXTex".

### POSSIBILITIES
- get user to select game folder, then search list for names of common games known to have dds textures...can 7za also do ba1 files? If so widen the horizons of the project. additionally incorporate further decompression libraries, gotta catch em all, though I would be happy stopping at, all, elderscrolls and fallout and starfield, as they are games of interest, and the folder structures wll be the same, ie character folder toggle will apply.
- Use up-to-date libraries for downscaling... For AMD GPUs: Compressonator is a robust choice, offering fast, GPU-accelerated compression and a range of advanced encoding options. For NVIDIA GPUs: NVIDIA's Texture Tools Exporter is the go-to tool, leveraging CUDA acceleration for efficient texture compression. ^_^
- Mutli-Thread, Upon detect GPUs, have option for select ALL, this would result in workload being split into 2 lists, then individually processed by GPUs at same time in parrallel, additionally, detect how many cores each GPU has, and devide the work further that way, example, RX 470 is 2 core while HD 7850 is 1 core, hence, 3 lists, 2/3 of the work to the RX 470 and 1/3 of the work to the HD 7850.

### NOTATION
- The "Brown faces" bug in Fallout 4 can occur without resizing textures, possibly due to changes in, makeup and face, bc compression. DdsBethScale preserves the original compression, however, this is why the option exists to bypass character textures.
- To get 7zr to install I had to run "Set-ExecutionPolicy RemoteSigned" for some reason...

### CREDITS
- Credit to, 7-Zip Team and Microsoft, for relevantly, 7za abd DirectXTex.

### DISCLAIMER
This program is provided "as is" without warranties or support. Users are responsible for the content they, download and use, as well as, any resulting damage to, hardware or sanity.

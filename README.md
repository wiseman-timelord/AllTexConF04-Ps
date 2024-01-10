# BethDdsScale-Ps

### STATUS: DEVELOPMENT
Still being created, not even done the basic testing, most of it is figured out and implemented...
- Test out the new blinging pre-processing configuration menu, fix issues..
- Check code relating to operations is being centered around examplegame\data folder, and not, examplegame\ or examplegame\data\textures\.
- Setup fake data dir etc, Test, Testing results into updates for scripts, complete scripts.
- add centering on the data folder location line, as the whopping steam line, is not how it will look for people whom have a separate large programs drive.
- Do a once over on all the scripts, make sure everything is seemingly ok, then try do some improvements.
- option on main config menu to use or not use -mt command in handling of unpacking/packing archives, currently it should be hardcoded to be used.
- Mutli-Thread, Upon detect GPUs, if there is more than 1 graphics card, that is not the default MS renderer, then on the option to set GPU have option to select "Multi-Gpu Dds Processing", this would result in workload being split into multiple lists, then individually processed by GPUs at same time in parrallel.
  

### DESCRIPTION
BethDdsScale-Ps, designed for Modern Bethesda games for, Textures and Archives, processing. It processes both, loose and Ba/Ba2 packed, textures, optimizing to user specified limits in size, for, non-transparent and transparent textures, respectively preserving the original formats of compression. BethDdsScale-Ps adjusts resolutions to, RATIOx4096, RATIOx2048 or RATIOx1024 or RATIOx512 or RATIOx256 (even Quake1 fans are catered for), somewhat maintaining wider images used for skies etc. Its interface is intuitive, and it provides detailed output, including texture names and resolutions. BethDdsScale-Ps is optimized for speed, extracting files from Ba2, then updating the textures folder only back to the original Ba2, and also, processing image files where they stand, instead of relevantly, re-compressing ba2 files and moving images. There are indeed other DDS conversion tools, but the standout features will be, support for any Bethesda game from Oldrim to Starfield:
- Non-complicated configuration, at least the least complicated I've seen.
- The GPU selection for processing.
- processing all the textures, in loose and packed in ba2, files, in one action.

### FEATURES
- **Resolution Adjustment**: Dynamically scales textures exceeding a target resolution, maintaining aspect ratio.
- **Format Conversion**: Intelligently converts textures to DirectX formats, considering transparency.
- **BSArch Archive Compatibility**: Processes textures within, `.ba` and `.ba2`, files, extracting, converting, and repacking efficiently.
- **GPU Selection**: Leverages the power of specified GPUs, enhancing processing speed and efficiency.
- **User-Friendly Interface**: Offers an easy-to-navigate menu system, simplifying the texture processing workflow.
- **Detailed Output**: Provides comprehensive feedback during processing, including texture names and resolutions.
- **Brown Faces Fix**: A comprihensive character assets avoidance option, that will bypass processing on troublesome items.

### PREVIEW
```
  ____       _   _     ____      _     ____            _      
 | __ )  ___| |_| |__ |  _ \  __| |___/ ___|  ___ __ _| | ___ 
 |  _ \ / _ \ __| '_ \| | | |/ _` / __\___ \ / __/ _` | |/ _ \
 | |_) |  __/ |_| | | | |_| | (_| \__ \___) | (_| (_| | |  __/
 |____/ \___|\__|_| |_|____/ \__,_|___/____/ \___\__,_|_|\___|

======================( BethDdsScale-Ps )======================

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
  ____       _   _     ____      _     ____            _      
 | __ )  ___| |_| |__ |  _ \  __| |___/ ___|  ___ __ _| | ___ 
 |  _ \ / _ \ __| '_ \| | | |/ _` / __\___ \ / __/ _` | |/ _ \
 | |_) |  __/ |_| | | | |_| | (_| \__ \___) | (_| (_| | |  __/
 |____/ \___|\__|_| |_|____/ \__,_|___/____/ \___\__,_|_|\___|

======================( BethDdsScale-Ps )======================

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
1. Run `Setup-Install.Bat` to, install required libraries and create program folders, this is a web-install, so ensure to allow `Setup-Install.Bat` through firewall first, or you may have to run it again if you have popups for rules.
2. Run `DdsBethScale.Bat` to start the script.
3. Select your preferences, game\data location, character assets, desired max resolution, GPU processor.
4. Press `b` to Begin, and set the scripts process the textures in your `Data` directory.
5. Upon completion, processed textures are saved, and the script reports the status.

### REQUIREMENTS
- PowerShell =>4.0 (Win =>8.1, or get 5.1 Update) or Powershell Core =>7.
- Installed Bethesda game, Skyrim (32), Skyrim SE, Fallout NV, Fallout 3, Fallout 4, StarField, any, version and mods, will be fine.
- Library Requirements installed by `Setup-Installer.Bat`, this includes currently, 7zr, BSArch, DirectXTex.
- Git, required by installer for, "7za" and "DirectXTex".

### POSSIBILITIES
- Use up-to-date libraries for downscaling... For AMD GPUs: Compressonator is a robust choice, offering fast, GPU-accelerated compression and a range of advanced encoding options. For NVIDIA GPUs: NVIDIA's Texture Tools Exporter is the go-to tool, leveraging CUDA acceleration for efficient texture compression. ^_^


### NOTATION
- The "Brown faces" bug in Fallout 4 can occur without resizing textures, possibly due to changes in, makeup and face, bc compression. BethDdsScale preserves the original compression, however, this is why the option exists to bypass character textures.
- If you have problems with the Setup-Install.Bat, after sorting out firewall stuff, try typing "Set-ExecutionPolicy RemoteSigned" in a powershell console that has admin, to enable downloading from digitally signed servers.

### CREDITS
- Credit to, 7-Zip and Microsoft and TES5Edit, teams for relevantly, 7za abd DirectXTex and BSArch.

### DISCLAIMER
This program is provided "as is" without warranties or support. Users are responsible for the content they, download and use, as well as, any resulting damage to, hardware or sanity.

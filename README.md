# AllTexConF04-Ps

### STATUS: DEVELOPMENT
Still being created, not even done the basic testing, most of it is figured out and implemented...
- Setup fake data dir etc, Test, Testing results into updates for scripts, complete scripts.
- Mutli-Thread, Upon detect GPUs, have option for select ALL, this would result in workload being split into 2 lists, then individually processed by GPUs at same time in parrallel, additionally, detect how many cores each GPU has, and devide the work further that way, example, RX 470 is 2 core while HD 7850 is 1 core, hence, 3 lists, 2/3 of the work to the RX 470 and 1/3 of the work to the HD 7850.

### DESCRIPTION
AllTexConF04-Ps, designed for Fallout 4, epitomizes efficiency and user-friendliness in Fallout 4 texture processing. It processes both loose and BA2 textures, optimizing them with DX1 or DX7 compression for non-transparent and transparent textures, respectively. AllTexConF04-Ps adjusts resolutions to user selection of, 2048x* or 1024x* or 512x*, maintaining aspect ratios. Its interface is intuitive, and it provides detailed output, including texture names and resolutions. AllTexConF04-Ps is optimized for speed, extracting files from Ba2, then updating the textures folder only back to the original Ba2, instead of re-compressing ba2 files. There are indeed other DDS conversion tools for Fallout 4, but the standout features will be:
1. the GPU selection, if you have multiple graphics card, specify your GPUs of choice to accelerate processing
2. additionally AllTexConF04-Ps will be processing all the textures, loose and in ba2 files, at the same time, it will be a "fire em off and make yourself a cup of tea" kind of tool, instead of, complex configuration or time wasted processing individual Ba2'2 files. 

### FEATURES
- **Resolution Adjustment**: Dynamically scales textures exceeding a target resolution, maintaining aspect ratio.
- **Format Conversion**: Intelligently converts textures to DirectX formats, considering transparency.
- **BA2 Archive Compatibility**: Processes textures within `.ba2` files, extracting, converting, and repacking efficiently.
- **GPU Selection**: Leverages the power of specified GPUs, enhancing processing speed and efficiency.
- **User-Friendly Interface**: Offers an easy-to-navigate menu system, simplifying the texture processing workflow.
- **Detailed Output**: Provides comprehensive feedback during processing, including texture names and resolutions.

### PREVIEW
```
==================( AllTexConFO4-Ps )==================




              1. Set Data Folder Location,
              2. Set Max Image Resolution,
              3. Set GPU Processor To Use,
              0. Begin Image Processing...



Select, Settings=1-3, Begin=0, Exit=X:

```
```
18:45: Texture Processing Started...

Loose Texture Processing...
Image1.dds: Analyzing Image Size.
Image1.dds: Resized 1024x512-BC3.
...Loose Textures Processed.

Ba2 Texture Processling...
TexturesArchive1.ba2: Unpacking Contents.
Image4.dds: Analyzing Image Size.
Image4.dds: Dimensions Compliant.
Image5.dds: Analyzing Image Size.
Image5.dds: Resized 1024x1024-BC3.
TexturesArchive1.ba2: Contents RePackaged.
...Ba2 Files Processed.

18:50: ...Texture Processing Completed.
```
```
==================( AllTexConFO4-Ps )==================

                   Processing Stats:
             Start: 22:33, Duration: 03:13
               Processed: 57, Passed: 23  
             Saved: 14.2 MB, Reduction: 9%                  

                    Resulting Scores: 
	      Current: 6.67, Previous: 5.50
               Highest: 8.20, Lowest: 4.75
              
                       Verdict: 
                  Average Score! (o_o)

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
- Windows PowerShell 5.1 or higher.
- Installed Fallout 4 game, any, version and mods, will be fine.
- Library Requirements installed by `Setup-Installer.Bat`.
- Git, required by installer for, "7za" and "DirectXTex".

### FUTURE
- 7za is only available on websites in, 7z and msi, format, must compile 7za into a portable single executable, and host on github, then include in Setup-Install.Bat, to be able to upload project to Nexus.
- Compiling TexConv.exe with additonal argument -null or something, to bypass, checking and writing, a file, when given the "texconv.exe filename.dds" command, and instead print default image info, thus removing the requirement of texdiag.exe

### CREDITS
- Credit to, 7-Zip Team and Microsoft, for relevantly, 7za abd DirectXTex.

### DISCLAIMER
This program is provided "as is" without warranties or support. Users are responsible for the content they, download and use, as well as, any resulting damage to, hardware or sanity.

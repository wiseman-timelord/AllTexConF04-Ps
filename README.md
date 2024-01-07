# AllTexConF04-Ps

### STATUS: DEVELOPMENT
Still being created, not even done the basic testing, most of it is figured out and implemented...
- REad up on current stage, and progress, main.ps1 and processor.ps1 are mostly complete.
- check and enhance, psd1 integration optimally to assist the recording of progress, listing of files etc.
- Setup fake data dir etc, Test, Testing results into updates for scripts, complete scripts.
- Compile 7za into a portable single executable, and host on github, then include in downloader, to be able to upload project to Nexus.
- Look into possibilities of multi-gpu processing, utilizing psd1 for splitting file lists.
- possibilities of timing card(s) to determine effectiveness of each card, even a scoring system like average textures per second x 100, or something.

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

### NOTATION
- 7za is only available on websites in, 7z and msi, format, must compile 7za into a portable single executable, and host on github, then include in Setup-Install.Bat, to be able to upload project to Nexus.
- Credit to - 7-Zip Team and Microsoft, for relevantly, 7za abd DirectXTex.

### DISCLAIMER
This program is provided "as is" without warranties or support. Users are responsible for the content they, download and use, as well as, any resulting damage to, hardware or sanity.

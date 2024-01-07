# AllTexConF04-Ps

## STATUS: WORKING
Still being created, not even done the basic testing...
- REad up on current stage, and progress.
- Testing will have to be done at some point (make sure to backup entire FO4 folder).
- Get up-to-date versions of third party binaries supplied.

## DESCRIPTION
AllTexConF04-Ps is a sophisticated PowerShell script tailored for Fallout 4 enthusiasts and modders. It's designed to automate the process of conforming game textures to specific resolutions and formats. Whether dealing with vanilla or modded textures, AllTexConF04-Ps streamlines the task, enhancing game performance and visual fidelity. Its ability to handle `.dds` textures and `.ba2` archives makes it an invaluable tool for improving gaming experience.

## FEATURES
- **Resolution Adjustment**: Dynamically scales textures exceeding a target resolution, maintaining aspect ratio.
- **Format Conversion**: Intelligently converts textures to DirectX formats, considering transparency.
- **BA2 Archive Compatibility**: Processes textures within `.ba2` files, extracting, converting, and repacking efficiently.
- **GPU Selection**: Leverages the power of specified GPUs, enhancing processing speed and efficiency.
- **User-Friendly Interface**: Offers an easy-to-navigate menu system, simplifying the texture processing workflow.
- **Detailed Output**: Provides comprehensive feedback during processing, including texture names and resolutions.

## USAGE
1. Ensure all required tools (`texconv.exe`, `texdiag.exe`, `7za.exe`) are placed in the `BinDirectory`.
2. Run `main.ps1` to start the script.
3. Select the desired resolution for texture processing.
4. Choose the GPU for processing (if available).
5. Let the script process the textures in your Fallout 4 directory.
6. Upon completion, processed textures are saved, and the script reports the status.

## REQUIREMENTS
- Windows PowerShell 5.1 or higher.
- Installed Fallout 4 game with accessible texture files and `.ba2` archives.
- Required external tools: `texconv.exe`, `texdiag.exe`, and `7za.exe` in the specified `BinDirectory`.

## NOTATION
- Credit 1 (Microsoft DirectX): This project uses `texconv.exe` and `texdiag.exe` from the DirectXTex library, a part of Microsoft DirectX. For more information, visit [Microsoft's DirectXTex repository](https://github.com/microsoft/DirectXTex).
- Credit 2 (7-Zip Team): The project incorporates `7za.dll`, `7za.exe`, and `7zxa.dll` from 7-Zip. 7-Zip is licensed under the GNU LGPL. More details are available on the [7-Zip website](http://www.7-zip.org/).

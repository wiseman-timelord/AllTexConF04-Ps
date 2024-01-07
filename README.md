# AllTexConF04-Ps

## STATUS: WORKING
Still being created, not even done the basic testing...
- REad up on current stage, and progress.
- Testing will have to be done at some point (make sure to backup entire FO4 folder).
- Get up-to-date versions of third party binaries supplied.

## DESCRIPTION
AllTexConF04-Ps, designed for Fallout 4, epitomizes efficiency and user-friendliness in Fallout 4 texture processing. It processes both loose and BA2 textures, in batch and at the same time, optimizing them with DX1 or DX7 compression for non-transparent and transparent textures, respectively. AllTexConF04-Ps adjusts resolutions to user selection of, 2048x* or 1024x* or 512x*, maintaining aspect ratios. If you have multiple graphics card, the standout feature is the GPU selection capability, which leverages the power of specified GPUs of choice to accelerate processing. Its interface is intuitive, and it provides detailed output, including texture names and resolutions. AllTexConF04-Ps is optimized for speed, extracting files from Ba2, then updating the textures folder only back to the original Ba2, instead of re-compressing ba2 files.

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

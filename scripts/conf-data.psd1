@{

    # Paths
    RootDirectory = "..\"
    ToolsDirectory = ".\AllTexConform-Ps"
    BinDirectory = ".\AllTexConform-Ps\binaries"
    CacheDirectory = ".\AllTexConform-Ps\cache"
    DataDirectory = ".\Data"
    TexturesDirectory = ".\Data\Textures"
    ExcludeDirectory = ".\AllTexConform-Ps\Cache\Data\Textures\actors\character"

    # Binaries
    TexConvExecutable = ".\AllTexConform-Ps\binaries\texconv.exe"
    TexDiagExecutable = ".\AllTexConform-Ps\binaries\texdiag.exe"
    SevenZipExecutable = ".\AllTexConform-Ps\binaries\7za.exe"

    # File Patterns
    Ba2FilePattern = "*textures.ba2"
    DdsFilePattern = "*.dds"

    # Size and Time Records (initially empty, to be filled by the script)
    Ba2FilesSizeBefore = 0
    Ba2FilesSizeAfter = 0
    Ba2FilesTimeTaken = 0

    LooseFilesSizeBefore = 0
    LooseFilesSizeAfter = 0
    LooseFilesTimeTaken = 0

    # Other settings can be added as needed
}

function ConvertTo-AsciiArt {
    param (
        [string]$ImagePath,
        [int]$Width
    )

    # Create a new bitmap with the specified width
    $bitmap = [System.Drawing.Bitmap]::FromFile($ImagePath)
    $height = [int]($bitmap.Height * ($Width / $bitmap.Width))
    $newBitmap = New-Object System.Drawing.Bitmap $bitmap, $Width, $height

    # Create the character set
    $characters = " .,:;i1tfL@".ToCharArray()
    $charSetLength = $characters.Length

    # Create the ascii art string
    $asciiArt = ""
    for ($y = 0; $y -lt $height; $y++) {
        for ($x = 0; $x -lt $Width; $x++) {
            # Get the color of the pixel at the current position
            $color = $newBitmap.GetPixel($x, $y)

            # Calculate the gray scale value
            $grayScale = [int](($color.R*0.3) + ($color.G*0.59) + ($color.B*0.11))

            # Map the gray scale to a character in the character set
            $index = [int]($grayScale / 255 * ($charSetLength - 1))
            $asciiArt += $characters[$index]
        }
        $asciiArt += "`n"
    }

    # Return the ascii art string
    return $asciiArt
}

# Call the function
$asciiArt = ConvertTo-AsciiArt -ImagePath "path/to/image.png" -Width 80

# Print the ascii art
$asciiArt


Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing


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


# Genarate ASCII
function ConvertToAscii($imagePath) {
	# Call the function
	$asciiArt = ConvertTo-AsciiArt -ImagePath $imagePath -Width 80
	return $asciiArt
}

# Main Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "ASCII Art Generator"
$form.Size = New-Object System.Drawing.Size(600,400)


# Button
$button = New-Object System.Windows.Forms.Button
$button.Text = "Choose Image"
$button.Width = 100
$button.Height = 30
$button.Location = New-Object System.Drawing.Point(230, 10)
$button.Add_Click({
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = "Images|*.jpg;*.png"
    if ($openFileDialog.ShowDialog() -eq "OK") {
        $imagePath = $openFileDialog.FileName
        $textBox.Text = ConvertToAscii -imagePath $imagePath
    }
})
$form.Controls.Add($button)

# Text Box
$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(10, 50)
$textBox.Width = 570
$textBox.Height = 300
$textBox.Multiline = $true
$textBox.ScrollBars = "Vertical"

# Fonts
$textBox.Font = New-Object System.Drawing.Font("MS ゴシック", 9)

$form.Controls.Add($textBox)

# Display the forms
$form.ShowDialog()


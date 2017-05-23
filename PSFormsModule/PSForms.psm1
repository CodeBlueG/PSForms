#region Header Information ###################################################################
#
#   Module: PSForms.psm1
#
#   Author: Gareth J. Edwards
#			GJ.Edwards@Datacom.com.au
#
#     Date: 21/03/2017
#
#    About: This module is to allow easier creation of PowerShell GUI applications using
#			WinForms
#
#    Usage: This module can be used to enable easy creation of PowerShell GUI applications
#			using WinForms and can be added to the default path or located in the same 
#			folder as the script that uses the functions.
#			The functions can be referenced by importing the module or 'dot-referencing'
#			the functions.
#
# Versions:
# 07/02/2017 - 0.1 - Initial Beta release for testing and approval
# 21/03/2017 - 1.0 - Initial release for use
# 30/04/2017 - 1.1 - Added $listFile to allow comboBox to use entries from text file, doesn't need to be a variable
# 30/05/2017 - 1.2 - Adding any location for butons
#
#
# Cmdlets available				:	Version introduced	:	Last Modified
# ==========================================================================
#   Add-FormButton				:		1.0
#   Add-FormObject				:		1.0
#   Add-FormPicture				:		1.0
#   Add-FormTitle				:		1.0
#   Add-RadioToPanel			:		1.0
#   Add-Row						:		1.0
#   Initialize-Form				:		1.0
#   New-Form					:		1.0
#	Redo-FormPicture			:		1.0
#   Reset-FormFields			:		1.0
#   Set-FormSizing				:		1.0
#   Set-ObjectLocation			:		1.0
#   Set-ObjectSize				:		1.0
#   Show-Form					:		1.0
# 
# 
#
#endregion Header Information ################################################################



<#
.SYNOPSIS
	Adds a button to a form

.DESCRIPTION
	Will add a button to the footer of a form.  The location of the button will be in the footer of the form
	and the buttonLocation will be an integer which will represent the button number, counting from right to 
	left, i.e., the right hand button will be "1", the one to it's left will be "2" etc.
	
.PARAMETER formObject
    This is the form object to which the button will be added.

.PARAMETER buttonText
    The text that will appear on the button.

.PARAMETER buttonFont
    The font that will be used for buttonText.  If no font is specified, the form font setting will be used.
	Note: The font must be installed and available on the running machine.

.PARAMETER buttonLocation
    The location of the button will be in the footer of the form
	and the buttonLocation will be an integer which will represent the button number, counting from right to 
	left, i.e., the right hand button will be "1", the one to it's left will be "2" etc.
	
.OUTPUTS
	System.Object
	An object representing the button will be returned.  This object will be used to assign actions to the button

.FUNCTIONALITY
	PSForms

.EXAMPLE
    $btnClose = Add-FormButton -formObject $mainform -buttonText "Close" -buttonLocation 1
    $btnSubmit = Add-FormButton -formObject $mainform -buttonText "Submit" -buttonLocation 2
	
	$btnClose.add_Click({fnClose})
	$btnSubmit.add_Click({fnSubmit})

	Will add two buttons to the bottom right of the form, the right-most button will be the "Close" button, with the
	"Submit" button to it's left.  Functions are then added to the buttons that will activate when the buttons are 
	pressed.

.EXAMPLE
    $btnClose = Add-FormButton -formObject $mainform -buttonText "Close" -buttonLocation 1 -buttonFont "Tahoma"

	Will add a button to a form that will have the text "Close" that will be written using the Tahoma font.
	

#>
Function Add-FormButton {
<## TO DO ##
	add button to any part of the form, not only footer
#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject,
		[parameter(Mandatory=$true)]
		[string]
		$buttonText,
		[parameter(Mandatory=$false)]
		[String]
		$buttonFont,
		[parameter(Mandatory=$false)]
		[int]
		$buttonLocation
	)
	
	[int]$FooterHeight = $FormObject.footerHeight
	[int]$FormInternalWidth = $FormObject.clientSize.width
	[int]$FormInternalHeight = $FormObject.clientSize.height
	[int]$ButtonWidth = $FormObject.buttonWidth
	[int]$ButtonHeight = $FormObject.buttonHeight
	[int]$HorizSpace = $FormObject.horizSpace

	$object = New-Object System.Windows.Forms.Button
	$object.text = $buttonText
	
	If($buttonLocation){
		$object.Size = New-Object System.Drawing.Size($FormObject.buttonWidth, $FormObject.buttonHeight)
		$LocationX = $FormInternalWidth - ($ButtonWidth + $HorizSpace) * $buttonLocation
		$LocationY = $FormInternalHeight - $FooterHeight/2 - $ButtonHeight/2
		$object.Location = New-Object System.Drawing.Size($LocationX,$LocationY)
	}
	Else{
		Add-Member -InputObject $object -MemberType NoteProperty -Name cellSize -Value $cellSize
		Add-Member -InputObject $object -MemberType NoteProperty -Name cellRow -Value $FormObject.CurrentRow
		Add-Member -InputObject $object -MemberType NoteProperty -Name cellColumn -Value $FormObject.CurrentColumn
		Add-Member -InputObject $object -MemberType NoteProperty -Name rowHigh -Value $FormObject.CurrentRowHigh
		$object.size = Set-ObjectSize $FormObject $object
		$object.location = Set-ObjectLocation $formObject $object
		
		Write-Host ($object.location)
		Write-Host ($object.size)
	}


	If($buttonFont){
		$object.Font = $buttonFont
	}
	Else{
		$object.Font = $FormObject.formFont
	}

	$FormObject.Controls.Add($object)
	return $object
}

<#.
.SYNOPSIS
	Adds an object to a form.  This object will be a field or label that will make up the content of the form.

.DESCRIPTION
	The objects that are added to the form make up the layout and content of the form and allow information to
	be gathered from the user or to display output.  The following objects can be added to the form;
	
	CheckBox,
	CheckedListBox,
	ComboBox,
	DateTimePicker,
	GroupBox,
	Label,
	LinkLabel,
	NumericUpDown,
	Panel,
	ProgressBar,
	RadioButton,
	RichTextBox,
	TextBox
	
.PARAMETER formObject
    This is the form object to which the object will be added.

.PARAMETER objectType
    The type of object that will be added, the list of available object types is shown in the Description of the cmdlet

.PARAMETER cellSize
    The size of the object when it is added.  The available sizes are shown below;
	Full      - will fill one column.  This is the default size,
	HalfLeft  - will fill the left half of a column,
	HalfRight - will fill the right half of a column,
				these two sizes can be used together to place two fields in one column.
	1QLeft    - will fill the left quarter of a column,
	3QRight   - will fill the right 3 quarters of a column,
				these two sizes can be used together to place two fields in one column.
	Double    - will cover an odd and even column, a double-width field.
	
.PARAMETER cellFont
    The font that will be used for cellText.  If no font is specified, the form font setting will be used.
	Note: The font must be installed and available on the running machine.
	
.PARAMETER cellText
    Text that will be added to an object.  This will only apply to object that contain a ".text" parameter, such as a label 
	or a textBox, it will be ignored for other objects.
	
.PARAMETER textAlign
    Set text alignment of the object.  This is an optional parameter, the default value will be applied if this is omitted.  
	The value will be different for different objects, for example, a textbox can have values of "left", "center" or "right", but 
	a label can have values of "topLeft", "topCenter", "topRight", "middleLeft", "middleCenter", "middleRight", "bottomLeft", 
	"bottomCenter" or "bottomRight".  Incorrect values will produce errors.
	
.PARAMETER list
    For items which contain lists, such as a comboBox or checkedListBox, this parameter will containg the list of items that
	will be added to the field.
	
.PARAMETER dropDown
    If this switch is added, the format of a comboBox will be changed so that items can be added to the list by the user.  
	This will be ignored for objects other than a comboBox
	
.PARAMETER hidden
    If this switch is added, the object will be hidden when added, it must be made visible using commands within the form.
	
.PARAMETER disabled
    If this switch is added, the object will be disabled when added, it must be enabled using commands within the form.
	
.PARAMETER readonly
    If this switch is added, the object will be read only when added.
	
.PARAMETER border
    If this switch is added, the object will have a border added around.
	
.PARAMETER mandatory
    If this switch is added, the object will have a border added around.
	
.OUTPUTS
	System.Object
	An object representing the added field will be returned.  This object will be used to assign actions to the field

.FUNCTIONALITY
	PSForms

.EXAMPLE
    $lblUserName = Add-FormObject -formObject $mainForm -objectType Label -cellText "Enter User Name" -border
	
	This will create a new Label object called $lblUserName that will contain the text "Enter User Name" and will have a border
	around it.  The label will cover one column, the default width.

.EXAMPLE
	$txtUserName = Add-FormObject -formObject $mainForm -objectType TextBox
	
	This will create a new textBox object called $txtUserName.  The label will cover one column, the default width.

.EXAMPLE
	$txtDataEntryL = Add-FormObject -formObject $mainForm -objectType TextBox -cellSize "HalfLeft"
	$txtDataEntryR = Add-FormObject -formObject $mainForm -objectType TextBox -cellSize "HalfRight"

	This will create two new textBoxes which will each fit in half of a normal column width, one on the left and one on the right.

.EXAMPLE
	$chkDateRequired = Add-FormObject -formObject $mainForm -objectType CheckBox -cellText "Select box to show date picker"
		$chkDateRequired.add_CheckedChanged({fnShowdatRequiredDate})
	$MainForm = Add-Row -formObject $mainform -rowHigh 1
	$datRequiredDate = Add-FormObject -formObject $mainForm -objectType DateTimePicker -hidden

	This will create a new checkBox which will ask the user if a date is required, add a new row and add a dateTimePicker that will 
	be hidden when the form is opened.  Checking the box will run the function,	fnShowdatRequiredDate, which will change the display 
	status of the dateTimePicker object.



#>
Function Add-FormObject {
<## TO DO ##
	add tab index, use 'currenttab' attribute on form (?)
	add error markers on form, apply them in here(?)
	add size options - quarters of width, 1q, 2q, 3q, full?
	checkedlistbox formating - checkOnClick, ThreeD etc...
#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject,
		[parameter(Mandatory=$true)]
		[ValidateSet("CheckBox","CheckedListBox","ComboBox","DateTimePicker","GroupBox","Label","LinkLabel","NumericUpDown","Panel","ProgressBar","RadioButton","RichTextBox","TextBox")]
		[String]
		$objectType,
		[parameter(Mandatory=$false)]
		[ValidateSet("Full","HalfLeft","HalfRight","1QLeft","3QRight","Double")]
		[String]
		$cellSize = "Full",
		[parameter(Mandatory=$false)]
		[String]
		$cellFont,
		[parameter(Mandatory=$false)]
		[Int]
		$cellFontSize,
		[parameter(Mandatory=$false)]
		[String]
		$cellText,
		[parameter(Mandatory=$false)]
		[String]
		$textAlign,
		[parameter(Mandatory=$false)]
		[object]
		$list,
		[parameter(Mandatory=$false)]
		[string]
		$listFile,
		[parameter(Mandatory=$false)]
		[switch]
		$dropDown,
		[parameter(Mandatory=$false)]
		[switch]
		$hidden,
		[parameter(Mandatory=$false)]
		[switch]
		$disabled,
		[parameter(Mandatory=$false)]
		[switch]
		$readOnly,
		[parameter(Mandatory=$false)]
		[switch]
		$border,
		[parameter(Mandatory=$false)]
		[switch]
		$mandatory,
		[parameter(Mandatory=$false)]
		[switch]
		$previousColumn,
		[parameter(Mandatory=$false)]
		[switch]
		$bold,
		[parameter(Mandatory=$false)]
		[switch]
		$italic,
		[parameter(Mandatory=$false)]
		[switch]
		$underline,
		[parameter(Mandatory=$false)]
		[string]
		$objectGroup
	)

# Create object and add size and location details to the object
	$object = New-Object System.Windows.Forms.$objectType
	Add-Member -InputObject $object -MemberType NoteProperty -Name cellSize -Value $cellSize
	Add-Member -InputObject $object -MemberType NoteProperty -Name cellRow -Value $FormObject.CurrentRow
	Add-Member -InputObject $object -MemberType NoteProperty -Name cellColumn -Value $FormObject.CurrentColumn
	Add-Member -InputObject $object -MemberType NoteProperty -Name rowHigh -Value $FormObject.CurrentRowHigh

	$object.size = Set-ObjectSize $FormObject $object
	If($previousColumn){
		$FormObject.currentColumn = $FormObject.currentColumn - 1
		$object.location = Set-ObjectLocation $formObject $object
		$FormObject.currentColumn = $FormObject.currentColumn + 1
	}
	Else{
		$object.location = Set-ObjectLocation $formObject $object
	}
	$EditableField = $false


# Set various object settings
	Switch ($objectType) {
		CheckBox {
			$object.Text = $CellText
			$object.textAlign = "MiddleRight"
			$EditableField = $true
		}
		CheckedListBox {
			$EditableField = $true
		}
		ComboBox {
			$object.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
			$object.Sorted = $True
			$EditableField = $true
			If($DropDown){
				$object.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDown
				$object.AutoCompleteCustomSource.Add("System.Windows.Forms");
				$object.AutoCompleteCustomSource.AddRange(("System.Data", "Microsoft"));
				$object.AutoCompleteMode = [System.Windows.Forms.AutoCompleteMode]::SuggestAppend;
				$object.AutoCompleteSource = [System.Windows.Forms.AutoCompleteSource]::ListItems;
			}
		}
		DateTimePicker {
			$object.Format = 'Short'
			If($Text -eq "Hidden"){$Object.Visible = $False}
			$EditableField = $true
		}
		GroupBox {

		}
		Label {
			$object.Text = $CellText
			$object.TextAlign = 'TopLeft'
		}
		LinkLabel {
			$object.Text = $CellText
			$object.TextAlign = 'MiddleCenter'
		}
		NumericUpDown {
			$EditableField = $true
		}
		Panel {
		}
		ProgressBar {
			$object.Style="Continuous"
		}
		RadioButton {
			$EditableField = $true	
		}
		RichTextBox {
			If($RowHigh -gt 1){$object.Multiline = $true}
			If($CellText -eq "Hidden"){$Object.Visible = $False}
			Else{$object.Text = $CellText}
			$EditableField = $true

		}
		TextBox {
			$object.TextAlign = 'Left'
			If($RowHigh -gt 1){$object.Multiline = $true}
			If($CellText -eq "Hidden"){$Object.Visible = $False}
			Else{$object.Text = $CellText}
			$EditableField = $true
		}
	}

# build up font style command
	$fontStyle = $null
	If($bold){$fontStyle += [System.Drawing.FontStyle]::Bold}
	If($italic){$fontStyle += [System.Drawing.FontStyle]::Italic}
	If($underline){$fontStyle += [System.Drawing.FontStyle]::Underline}
	If(-not $fontStyle){$fontStyle = [System.Drawing.FontStyle]::Regular}
	
	If($cellFont){$chosenFont = $cellFont}
	Else{$chosenFont = $FormObject.formFont}
	If($cellFontSize){$chosenFontSize = $cellFontSize}
	Else{$chosenFontSize = $FormObject.formFontSize}

	$object.Font = New-Object System.Drawing.Font($chosenFont, $chosenFontSize, $fontStyle)

	If($EditableField){
		$FormObject.EditedFieldList += $object
		If(-not $FormObject.FirstField){$FormObject.FirstField = $object}
	}
	If($mandatory){
		$FormObject.mandatoryFields += $object
	}

# Add settings for switch parameters
	If($Hidden){$object.visible = $false}
	If($disabled){$object.enabled = $false}
	If($readOnly){$object.readOnly = $true}
	If($textAlign){$object.textAlign = $textAlign}
	If($border){$object.BorderStyle = [System.Windows.Forms.BorderStyle]::FixedSingle}

	If($objectType -like "comboBox" -or $objectType -like "CheckedListBox"){
		If($list){
			ForEach($entry in $list){
				$object.Items.Add($entry)
			}
		}
		ElseIf($listFile){
			ForEach($entry in Get-Content $listFile){
				$object.Items.Add($entry)
			}
		}
	}

# Identify current row and column and compare to current highest values - used in form sizing
	$CurrentRowCount = [int]$object.cellRow + [int]$object.rowHigh
	If($FormObject.TotalRowCount -lt $CurrentRowCount){
		$FormObject.TotalRowCount = $CurrentRowCount
	}
	If($FormObject.TotalColumnCount -lt $FormObject.CurrentColumn){
		$FormObject.TotalColumnCount = $FormObject.CurrentColumn
	}

# If objectGroup is specified, add a field to the object
	If($objectGroup){
		Add-Member -InputObject $object -MemberType NoteProperty -Name objectGroup -Value $objectGroup
	}

# Add object to form and return object to calling script
	$FormObject.Controls.Add($object)
	return $object
}

<#
.SYNOPSIS
	Places a picture on a form

.DESCRIPTION
	Places a picture in the header or footer of a form.  In the header, the picture will be in the right of the form, 
	in the footer, the picture is on the left of the form.
	
.PARAMETER formObject
    This is the form object to which the picture will be added.

.PARAMETER pictureImage
    The image that will be added to the form.  This input will be an encoded string that represents the image.

.PARAMETER pictureLocation
    Where on the form the picture will be added, either header or footer.
	
.OUTPUTS
	System.Object
	An object representing the image will be returned.

.FUNCTIONALITY
	PSForms

.EXAMPLE
    Add-FormPicture -formObject $mainform -pictureImage $CustomerLogo -pictureLocation "Header" 
	Will add the image contained in the customerLogo variable to the header of the mainForm form.

#>
Function Add-FormPicture {
<## TO DO ##
	Add ability to place image in any part of the form
#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject,
		[parameter(Mandatory=$true)]
		[string]
		$pictureImage,
		[parameter(Mandatory=$true)]
		[ValidateSet("Header","Footer")]
		[string]
		$pictureLocation
	)

	[int]$FormInternalHeight = $FormObject.clientSize.Height
	[int]$FooterHeight = $FormObject.footerHeight
	[int]$HorizSpace = $FormObject.horizSpace


	$object = New-Object System.Windows.Forms.PictureBox
	$object.Image = ([System.Drawing.Image]([System.Drawing.Image]::`
		FromStream((New-Object System.IO.MemoryStream(($$ = [System.Convert]::FromBase64String($pictureImage)),0,$$.Length)))))
	$object.Width = $object.Image.Width
	$object.Height = $object.Image.Height

	
	If($pictureLocation -eq "Footer"){
		$LocationX = $HorizSpace
		$LocationY = [int](($FormInternalHeight - ($FooterHeight) / 2) - ($object.Height / 2))
	}
	ElseIf($pictureLocation -eq "Header"){
		$LocationX = ($FormObject.ClientSize.Width) - $object.width - $FormObject.horizSpace
		$LocationY = [int](($FormObject.headerHeight / 2) - ($object.height / 2))
	}
	
	Add-Member -InputObject $object -MemberType NoteProperty -Name PictureLocation -Value $pictureLocation

	$object.Location = New-Object System.Drawing.Size("$LocationX,$LocationY")
	$FormObject.Controls.Add($object)
	return $object

}

<#
.SYNOPSIS
	Adds a title to a form

.DESCRIPTION
	Adds a title to a form header
	
.PARAMETER formObject
    This is the form object to which the title will be added.

.PARAMETER titleText
    The text that will appear on the title.

.PARAMETER titleFont
    The font used for the title.  Note that the chosen font must be available on the host machine.
	If omitted, the default form font will be used.

.PARAMETER titleFontSize
    The font size of the title.  If omitted, the default font size is 18px

.PARAMETER bold
    Use this switch to make the title appear in bold font.  This can be combined with the italic and underline switches

.PARAMETER italic
    Use this switch to make the title appear in italics.  This can be combined with the bold and underline switches

.PARAMETER underline
    Use this switch to make the title appear underlined.  This can be combined with the italic and bold switches
	
.OUTPUTS
	System.Object
	An object representing the title object will be returned.

.FUNCTIONALITY
	PSForms

.EXAMPLE
    $lblMainFormTitle = Add-FormTitle -formObject $mainForm -titleText "User Admin" -titleFontSize 24 -bold -underline

	Will add a title to the form with a bold, underlined font with a size of 24px.
	Be aware when increasing the font size that the text may be too large to fit in the header area.

#>
Function Add-FormTitle {
<## TO DO ##

#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject,
		[parameter(Mandatory=$false)]
		[String]
		$titleText,
		[parameter(Mandatory=$false)]
		[string]
		$titleFont,
		[parameter(Mandatory=$false)]
		[int]
		$titleFontSize = 18,
		[parameter(Mandatory=$false)]
		[switch]
		$bold,
		[parameter(Mandatory=$false)]
		[switch]
		$italic,
		[parameter(Mandatory=$false)]
		[switch]
		$underline
	)

	$headerHeight = $FormObject.headerHeight

	If($titleFont){$titleFontUsed = $titleFont}
	Else{$titleFontUsed = $FormObject.formFont}
	If($titleText){$titleTextUsed = $titleText}
	Else{$titleTextUsed = $FormObject.formTitle}

# build up font style command
	$fontStyle = $null
	If($bold){$fontStyle += [System.Drawing.FontStyle]::Bold}
	If($italic){$fontStyle += [System.Drawing.FontStyle]::Italic}
	If($underline){$fontStyle += [System.Drawing.FontStyle]::Underline}
	If(-not $fontStyle){$fontStyle += [System.Drawing.FontStyle]::Regular}

	$object = New-Object System.Windows.Forms.Label
	$object.Font = New-Object System.Drawing.Font($titleFontUsed, $titleFontSize,$fontStyle)
	$object.Text = $titleTextUsed
	$object.AutoSize = $true
	$FormObject.Controls.Add($object)
	
# Title height needs to be even for next calculations...
	[int]$objectHeight = $object.height
	If([bool](($ObjectHeight)%2)){
		$Object.Height = $ObjectHeight + 1
	}

# Set header height to be title size + 2 if it is not already larger
	If($headerHeight - $object.height -lt 2){
		$Formobject.headerHeight = $object.height + 4
	}

# LocationY is forced as an [int] to ensure it is a whole number - this will round down
	$LocationX = $FormObject.HorizSpace
	$LocationY = [int]($Formobject.headerHeight/2 - ($object.height + 1)/2)
	$object.location = "$LocationX,$LocationY"

	return $object
}

<#
.SYNOPSIS
    Adds a radio button to a panel

.DESCRIPTION
    Adds a radio button to a panel so that they are grouped together.  Grouped buttons allow only one of the 
	radio buttons to be selected at a time.

.PARAMETER panelObject
    The parent panel object that the radio button will be added to.  Note that this must be created first using the
	add-formObject cmdlet and will need to be sized correctly.

.PARAMETER text
    The text that wil be written to the right of the radio button showing the option

.PARAMETER optionNumber
    The number of the radio button being added - 1 is the first radio button added at the top of the panel, 2 will
	be added below that etc.
		
.OUTPUTS
	System.Object
	An object representing the radio button will be returned.

.FUNCTIONALITY
	PSForms

.EXAMPLE
	$panOptions = Add-FormObject -formObject $mainForm -objectType Panel -border -cellSize Double
	$radOption1 = Add-RadioToPanel -panelObject $panOptions -text "Option 1 - Add User" -optionNumber 1
		$radOption1.add_MouseClick({Option1_MouseClick})
	$radOption2 = Add-RadioToPanel -panelObject $panOptions -text "Option 2 - Edit User" -optionNumber 2
		$radOption2.add_MouseClick({Option2_MouseClick})

	A panel object is created in the first line, and two radio buttons are added to the panel.  Following that,
	a MouseClick action is added that will run a function.

#>
Function Add-RadioToPanel {
<## TO DO ##
	
#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$PanelObject,
		[parameter(Mandatory=$false)]
		[string]
		$text,
		[parameter(Mandatory=$false)]
		[int]
		$optionNumber
	)

	$object = New-Object System.Windows.Forms.radioButton
	$object.Width = $PanelObject.width
	$LocationX = 10
	$LocationY = ($optionNumber - 1) * 20
	$object.Location = New-Object System.Drawing.Point($LocationX,$LocationY)
	$object.Text = $text
	$PanelObject.Controls.Add($object)

	return $object
}

<#
.SYNOPSIS
	Adds a row to a form, used before adding a new field.

.DESCRIPTION
	Add a new row to a form to ensure that a new field is placed in the correct position on the form.  Using two 
	add-Row cmdlets together can produce different results, for example using the cmdlet to add 3 rows will create 
	a new field that is three rows high, whereas using two cmdlets, the first to add 2 rows and the second to add 
	1 row will create a new field that is one row high with a gap of two rows above it.
	
.PARAMETER formObject
    This is the form object that will be modified.

.PARAMETER rowsHigh
    The number of rows that will be added, this will take account of fields that are larger than a single row high
	
.PARAMETER newColumn
    Used to add a new row at the start of a new column.

.OUTPUTS
	System.Object
	An object representing the form.

.FUNCTIONALITY
	PSForms

.EXAMPLE
	$mainform = Add-Row -formObject $mainform -rowsHigh 1 -newColumn

	Will add a single height row to the mainForm object and start a new column

.EXAMPLE
	$mainform = Add-Row -formObject $mainform -rowsHigh 2

	Will add a double height row to the mainForm object.

#>
Function Add-Row {
<## TO DO ##
	
#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject,
		[parameter(Mandatory=$false)]
		[int]
		$rowsHigh = 1,
		[parameter(Mandatory=$false)]
		[switch]
		$newColumn,
		[parameter(Mandatory=$false)]
		[int]
		$forceColumn
	)
	
	If($forceColumn){
		$FormObject.currentColumn = $forceColumn - 1
	}

	If($newColumn){
		$FormObject.previousRow = $FormObject.StartingRow - 1
		$FormObject.previousRowHigh = 1
		[int]$CurrentColumn = $FormObject.CurrentColumn
		$FormObject.currentColumn = $CurrentColumn + 1
		$FormObject.currentRow = $FormObject.StartingRow
		$FormObject.currentRowHigh = $rowsHigh
	}
	Else{
# make 'current row' (from previous iteration) into 'previous row'
		[int]$PreviousRow = $FormObject.currentRow
		[int]$PreviousRowHigh = $FormObject.currentRowHigh
		$FormObject.previousRow = $PreviousRow
		$FormObject.previousRowHigh = $PreviousRowHigh

# set current row and current row high
		$FormObject.CurrentRow = $PreviousRow + $PreviousRowHigh
		$FormObject.CurrentRowHigh = $rowsHigh
	}
	return $FormObject
}

<#
.SYNOPSIS
	Initialises the form settings.

.DESCRIPTION
	Initialises the form object and loads any required assemblies so that the powershell session is 
	correctly configured.  No parameters are required for this cmdlet, but the form object is returned.
	
.OUTPUTS
	System.Object
	An object representing the form.

.FUNCTIONALITY
	PSForms

.EXAMPLE
	$mainform = Initialize-form

	Initialses the mainForm object.

#>
Function Initialize-Form {
<# TO DO

#>
	
	# Import graphics assemblies to be used to generate the form
	[void][reflection.assembly]::Load("System.DirectoryServices, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Xml, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Drawing, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("mscorlib, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
	[void][reflection.assembly]::Load("System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
	[Void][reflection.assembly]::LoadWithPartialName("System.Web")
	[System.Windows.Forms.Application]::EnableVisualStyles()

# Create new form object and add required values 
	$formObject = New-Object System.Windows.Forms.Form
	
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name HeaderHeight -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name FooterHeight -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name CurrentTab -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name CurrentColumn -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name CurrentRow -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name PreviousRow -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name StartingRow -Value 1
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name CurrentRowHigh -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name PreviousRowHigh -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name TotalRowCount -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name TotalColumnCount -Value 0
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name FormTitle -Value "Windows Form"
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name FormVersion -Value "1.0"
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name ColWidthOdd -Value 150
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name ColWidthEven -Value 200
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name VertSpace -Value 5
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name HorizSpace -Value 16
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name RowHeight -Value 20
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name ButtonWidth -Value 90
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name ButtonHeight -Value 20
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name CompanyLogo -Value $null
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name CustomerLogo -Value $null
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name EditedFieldList -Value @()
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name FirstField -Value $null
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name mandatoryFields -Value @()
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name formFont -Value SystemFonts.MessageBoxFont 
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name formFontSize -Value 8

	return $formObject
}

<#
.SYNOPSIS
	Completes the creation of the form, used after Initialize-Form is run and the size parameters are set.

.DESCRIPTION
	Completes the creation of the form, used after Initialize-Form is run and the size parameters are set.
	
.PARAMETER formObject
    This is the form object that will be modified.
	
.PARAMETER escapeToClose
    Using this switch will allow users to press the "Escape" key to close the form.
	
.PARAMETER maximizeBox
    If this switch is used, the minimize / maximize box will be added to the form with the maximize box enabled.
	
.PARAMETER minimizeBox
    If this switch is used, the minimize / maximize box will be added to the form with the minimize box enabled.
	
.PARAMETER psIcon
    Using the switch will assign the PowerShell logo as the form icon.
	
.PARAMETER iconFile
    Adding the path to a file with an icon will allow the form to use that icon.  This may be an icon file (.ico) 
	or a file with an embedded icon, such as an executable file.  Cannot be used if the -psIcon switch is used.
	
.OUTPUTS
	System.Object
	An object representing the form.  This will be used in other cmdlets to pass in the form object.

.FUNCTIONALITY
	PSForms

.EXAMPLE
	$mainform = New-Form -formObject $MainForm

	Will initialize a basic form $MainForm so it is ready to have objects added

.EXAMPLE
	$mainform = New-Form -formObject $MainForm -minimizeBox -escapeToClose

	Will initialize the form $MainForm with the minimze box visible and allowing the Escape key to 
	close the form.

#>
Function New-Form  {
<## TO DO ##
	add error markers(?)
	change style of form?  Fixed3D etc.
#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$formObject,
		[parameter(Mandatory=$false)]
		[switch]
		$escapeToClose,
		[parameter(Mandatory=$false)]
		[switch]
		$minimizeBox,
		[parameter(Mandatory=$false)]
		[switch]
		$maximizeBox,
		[parameter(Mandatory=$false)]
		[switch]
		$PSIcon,
		[parameter(Mandatory=$false)]
		[string]
		$iconFile,
		[parameter(Mandatory=$false)]
		[string]
		$iconEncode
	)

# Create new form object and add text to the form - used as the title bar of the form
#	$formObject = New-Object System.Windows.Forms.Form
	$formObject.Text = $formObject.FormTitle + " " + $formObject.FormVersion

# Set icon for the form and default options available and form border style
	If($PSIcon){$formObject.Icon = [system.drawing.icon]::ExtractAssociatedIcon($PSHOME + "\powershell.exe")}
	ElseIf($iconFile){
		$formObject.Icon = [system.drawing.icon]::ExtractAssociatedIcon($iconFile)
	}
	ElseIf($iconEncode){
		$iconimageBytes = [Convert]::FromBase64String($iconEncode)
		$ims = New-Object IO.MemoryStream($iconimageBytes, 0, $iconimageBytes.Length)
		$ims.Write($iconimageBytes, 0, $iconimageBytes.Length);
		$alkIcon = [System.Drawing.Image]::FromStream($ims, $true)
		$formObject.Icon = [System.Drawing.Icon]::FromHandle((new-object System.Drawing.Bitmap -argument $ims).GetHIcon())
	}
	$formObject.KeyPreview = $True
	If($escapeToClose){
		$formObject.Add_KeyDown({If($_.KeyCode -eq "Escape"){$formObject.Close()}})
	}
	If($MinimizeBox){
		$formObject.MinimizeBox = $true
	}
	Else{
		$formObject.MinimizeBox = $false
	}
	If($MaximizeBox){
		$formObject.MaximizeBox = $true
	}
	Else{
		$formObject.MaximizeBox = $false
	}

	If($FormName){
		$formObject.name = $FormName
	}
	$formObject.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D

	If($escapeToClose){
		$formObject.Add_KeyDown({If($_.KeyCode -eq "Escape"){$formObject.Close()}})
	}

# Add additional attributes to the form object for use in later functions
	[int]$ColWidthOdd = $formObject.colWidthOdd
	[int]$ColWidthEven = $formObject.colWidthEven
	[int]$HorizSpace = $formObject.HorizSpace
	$FullColWidth = $ColWidthOdd + $ColWidthEven + ($HorizSpace * 2)
	Add-Member -InputObject $FormObject -MemberType NoteProperty -Name FullColWidth -Value $FullColWidth

# Calculate header height based on Customer logo height - this might be over-ridden based on title height (calculated in Add-FormTitle)
	$CustomerLogo = $formObject.customerLogo
	If($CustomerLogo){
		$CustomerImage = ([System.Drawing.Image]([System.Drawing.Image]::`
			FromStream((New-Object System.IO.MemoryStream(($$ = [System.Convert]::FromBase64String($CustomerLogo)),0,$$.Length)))))
		If($formObject.headerHeight -lt $CustomerImage.height){
			$formObject.headerHeight = $CustomerImage.height + 10
		}
	}
	If([bool](($formObject.headerHeight)%2)){
		$formObject.headerHeight = $formObject.headerHeight + 1
	}

# Calculate footer height based on height of the company logo or button height, whichever is larger	
	$CompanyLogo = $formObject.CompanyLogo
	If($CompanyLogo){
		$CompanyImage = ([System.Drawing.Image]([System.Drawing.Image]::`
			FromStream((New-Object System.IO.MemoryStream(($$ = [System.Convert]::FromBase64String($CompanyLogo)),0,$$.Length)))))
		If($formObject.footerHeight -lt $CompanyImage.Height + 10){
			$formObject.footerHeight = $CompanyImage.Height + 10
		}
	}
	Else{
		$formObject.footerHeight = [int]($formObject.buttonHeight) + 10
	}

	return $formObject
}

<#
.SYNOPSIS
    Clears any fields that have been created as "editable" fields

.DESCRIPTION
    Clears any fields that have been created as "editable" fields.  This function can be added to a button to allow all 
	fields on a form to be cleared and a form reset.

.PARAMETER formObject
    This is the form that will be reset.
		
.OUTPUTS
	None

.FUNCTIONALITY
	PSForms

.EXAMPLE
    Reset-FormFields -formObject $mainForm 
	This will set all fields on the form "$mainForm" to be cleared and the form reset.

#>	
Function Redo-FormPicture {
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject,
		[parameter(Mandatory=$true)]
		[Object]
		$pictureObject
	)
	[int]$FormInternalHeight = $FormObject.clientSize.Height
	[int]$FooterHeight = $FormObject.footerHeight
	[int]$HorizSpace = $FormObject.horizSpace
	$pictureLocation = $pictureObject.pictureLocation

	If($pictureLocation -eq "Footer"){
		$LocationX = $HorizSpace
		$LocationY = [int](($FormInternalHeight - ($FooterHeight) / 2) - ($pictureObject.Height / 2))
	}

	$pictureObject.Location = New-Object System.Drawing.Size("$LocationX,$LocationY")
	return $pictureObject
}

<#
.SYNOPSIS
    Clears any fields that have been created as "editable" fields

.DESCRIPTION
    Clears any fields that have been created as "editable" fields.  This function can be added to a button to allow all 
	fields on a form to be cleared and a form reset.

.PARAMETER formObject
    This is the form that will be reset.
		
.OUTPUTS
	None

.FUNCTIONALITY
	PSForms

.EXAMPLE
    Reset-FormFields -formObject $mainForm 
	This will set all fields on the form "$mainForm" to be cleared and the form reset.

#>
Function Reset-FormFields {
<## TO DO ##
	add error markers to form, reset them in here
#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject
	)
	ForEach ($Field in $FormObject.EditedFieldList) {
		$FieldType = $Field.GetType().Name
		Switch($FieldType) {
			CheckBox {$Field.Checked = $False}
			CheckedListBox{
				$CurrentItems = @($Field.items)
# Removes all entries and recreates them - simpler than clearing each field within the checklist box!
				$Field.Items.Clear()
				ForEach($entry in $CurrentItems){
					$Field.Items.Add($entry)
				}
			}
			ComboBox {$Field.SelectedIndex = -1}
			DateTimePicker {$Field.Text = ""}
			NumericUpDown {$Field.Value = 0}
			RadioButton {$Field.Checked = $false}
			RichTextBox{$Field.text = ""}
			TextBox {$Field.Text = ""}
		}
#		$ErrorProvider.Clear()
	}
	
# Go to first field in form
	$FormObject.FirstField.focus()
}

<#
.SYNOPSIS
    Calculates the required size of the form.

.DESCRIPTION
	The Set-FormSizing cmdlet examines the contents of the form and calculates the size of the form.  This cmdlet should
	be used after all fields have been added to a form, but before the buttons and images are added to the footer and
	header sections.

.PARAMETER formObject
    This is the form that will be sized.
	
.OUTPUTS
	System.Object
	The form with the calculated size will be returned

.FUNCTIONALITY
	PSForms

.EXAMPLE
    Set-FormSizing -formObject $Form
	Gets the size for a label object that will be placed on $Form.  All of the details used to calculate the size of the object 
	are found in the two objects.

#>
Function Set-FormSizing {
<## TO DO ##

#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject
	)

	[int]$RowHeight = $FormObject.rowHeight
	[int]$TotalRowCount = $FormObject.totalRowCount - 1
	[int]$VertSpace = $FormObject.vertSpace
	[int]$ColWidthEven = $FormObject.ColWidthEven
	[int]$ColWidthOdd = $FormObject.ColWidthOdd
	[int]$HorizSpace = $FormObject.HorizSpace
	[int]$TotalColumnCount = $FormObject.totalColumnCount
	[int]$HeaderHeight = $FormObject.headerHeight
	[int]$FooterHeight = $FormObject.footerHeight

	$FormInternalHeight = ($RowHeight * $TotalRowCount) + ($VertSpace * ($TotalRowCount))  + $HeaderHeight + $FooterHeight
	$FormInternalWidth = ($ColWidthEven * ($TotalColumnCount/2)) + ($ColWidthOdd * ($TotalColumnCount/2)) + ($HorizSpace * ($TotalColumnCount + 1))
	$FormInternalSize = "$FormInternalWidth,$FormInternalHeight"
	$FormObject.ClientSize = New-Object System.Drawing.Size($FormInternalSize)

	return $FormObject
}

<#
.SYNOPSIS
    Calculates the location details used to place an object on a form

.DESCRIPTION
	The Set-ObjectLocatoin caldulates where on a form that an object will be placed..  This uses details that are passed in
	and then returns a value that can be used.  This function is used by other funstions withiin the module

.PARAMETER formObject
    This is the form on which the object will be placed.  Details used to calculate the location are contained in this object

.PARAMETER object
    The object that is being sized.  This will also contain details of the object that are used in calculating the location.
	
.OUTPUTS
	System.String
	A string object is returned that represents the calculated location of the object.

.FUNCTIONALITY
	PSForms

.EXAMPLE
    Set-ObjectSize -formObject $Form -object $labelObject
	Calculates the locaion for a label object that will be placed on $Form.  All of the details used to calculate the size of 
	the object are found in the two objects.

#>
Function Set-ObjectLocation {
<## TO DO ##

#>
	Param(
		[parameter(Mandatory=$true)]
		[Object[]]
		$formObject,
		[parameter(Mandatory=$true)]
		[Object[]]
		$object
	)

	[int]$RowHeight = $formObject.rowHeight
	[int]$VertSpace = $formObject.vertSpace
	[int]$HorizSpace = $formObject.HorizSpace
	[int]$ColWidthEven = $formObject.ColWidthEven
	[int]$ColWidthOdd = $formObject.ColWidthOdd
	[int]$FullColWidth = $formObject.FullColWidth
	[int]$headerHeight = $formObject.headerHeight
	[int]$Col = $Object.cellColumn
	[int]$Row = $Object.cellRow
	[int]$objectWidth = $object.size.width
	[string]$cellSize = $object.cellSize


	If(![bool]!($Col%2)){
		Switch($CellSize){
			3QRight {$LocationX = ($FullColWidth * ($Col/2)) - $objectWidth}
			HalfRight {$LocationX = ($FullColWidth * ($Col/2)) - ($ColWidthOdd/2 - $HorizSpace/4)}
			default {$LocationX = $HorizSpace + ($FullColWidth * ((($Col + 1)/2)-1))}
		}
	}
	Else{
		Switch ($CellSize){
			HalfRight {$LocationX = ($FullColWidth * ($Col/2)) - ($ColWidthEven/2 - $HorizSpace/4)}
			3QRight {$LocationX = ($FullColWidth * ($Col/2)) - $ObjectWidth}
			Double {$LocationX = $HorizSpace + ($FullColWidth * (($Col/2)-1))}
			default {$LocationX = ($HorizSpace * 2 + $ColWidthOdd) + ($FullColWidth * (($Col/2)-1))}
		}
	}

	$LocationY = $VertSpace + (($VertSpace + $RowHeight) * ($Row - 1)) + $headerHeight
	$ObjectLocation = "$LocationX,$LocationY"
	Return $ObjectLocation
}

<#
.SYNOPSIS
    Sets the size of an object that will be placed on the form

.DESCRIPTION
	The Set-ObjectSize funstion calculates the size of an object that will be placed on the form.  This uses details that are passed in
	and then returns a value that can be used.  This function is used by other funstions withiin the module

.PARAMETER formObject
    This is the form on which the object will be placed.  Details used to size the object are contained in this object

.PARAMETER object
    The object that is being sized.  This will also contain details of the object that are used in the sizing
	
.OUTPUTS
	System.Drawing.size
	A size object that is returned that can be applied to the object

.FUNCTIONALITY
	PSForms

.EXAMPLE
    Set-ObjectSize -formObject $Form -object $labelObject
	Gets the size for a label object that will be placed on $Form.  All of the details used to calculate the size of the object 
	are found in the two objects.

#>
Function Set-ObjectSize {
<## TO DO ##

#>
	Param(
		[parameter(Mandatory=$true)]
		[Object[]]
		$formObject,
		[parameter(Mandatory=$true)]
		[object]
		$object
	)

	[int]$RowHeight = $formObject.rowHeight
	[int]$VertSpace = $formObject.vertSpace
	[int]$col = $formObject.CurrentColumn
	[int]$ColWidthEven = $formObject.ColWidthEven
	[int]$ColWidthOdd = $formObject.ColWidthOdd
	[int]$RowHigh = $object.rowHigh
	[int]$HorizSpace = $formObject.horizSpace
	[string]$cellSize = $object.cellSize

	$CellHeight = $null
	$CellHeight = (($RowHeight + $VertSpace) * $RowHigh) - $VertSpace

# Different calculations for odd and even columns - values takes from user entered variables
	If([bool]!($Col%2)){$ColWidth = $ColWidthEven}
	Else{$ColWidth = $ColWidthOdd}

# Allow different options for object width. "Full" is the usual size, filling one column.
	Switch($cellSize)
	{
		Full {$CellWidth = $ColWidth}
		HalfLeft {$CellWidth = $ColWidth/2 - $HorizSpace/4}
		1QLeft {$CellWidth = $ColWidth/8 - $HorizSpace/4}
		HalfRight {$CellWidth = $ColWidth/2 - $HorizSpace/4}
		3QRight {$CellWidth = ((3 * $ColWidth)/4) - $HorizSpace/4}
		Double {$CellWidth = $ColWidthOdd + $ColWidthEven + $HorizSpace}
		default {$CellWidth = $ColWidth}
	}

	$ObjectSize = "$CellWidth,$CellHeight"
	Return new-object System.Drawing.Size($ObjectSize)
}

<#
.SYNOPSIS
    Shows the form on the screen

.DESCRIPTION
	This cmdlet will show the form on the screen and should be used at the end of a script.  This will allow the user to see
	the form and interact with it.

.PARAMETER formObject
    This is the form that will be shown on the screen
	
.OUTPUTS
	None

.FUNCTIONALITY
	PSForms

.EXAMPLE
    Show-Form -formObject $mainForm
	Shows the form $mainForm on the window

#>
Function Show-Form {
<## TO DO ##

#>
	Param(
		[parameter(Mandatory=$true)]
		[Object]
		$FormObject
	)
# Show form on screen
	$FormObject.ShowDialog()
}
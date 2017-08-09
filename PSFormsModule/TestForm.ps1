Get-Module pSforms | Remove-Module

#Import-Module PSForms -MinimumVersion 1.4 -MaximumVersion 2.0
#Import-Module C:\Users\garet\Source\Repos\PSForms\PSFormsModule\PSForms -MinimumVersion 1.4 -MaximumVersion 2.0

Import-Module C:\Users\garethj.edwards\Source\Repos\PSForms\PSFormsModule\PSForms -MinimumVersion 1.4 -MaximumVersion 2.0


#region User Entered Variables
# Set values used to create form
	$MainForm = $null
	$MainForm = Initialize-Form
	$MainForm.FormTitle = "Test Form Script"
	$MainForm.FormVersion = "1.0"
	$MainForm.ColWidthOdd = 100
	$MainForm.ColWidthEven = 200
	$MainForm.VertSpace = 5
	$MainForm.HorizSpace = 8
	$MainForm.RowHeight = 20
	$MainForm.ButtonWidth = 90
	$MainForm.ButtonHeight = 20
	$MainForm.formFont = "Helvetica"
	
# Add lists that can be used in Comboboxes etc.
	$cboSampleText23_List = @("List Sample 1","List Sample 2","List Sample 3","List Sample 4")
	
#endregion

#region Form Functions
function Test {
	$txtSampleText24.Text = $cboSampleText23.text

}

Function chkSampleText28_CheckChanged {
    $datSampleText29.Visible = $chkSampleText28.Checked
	If($datSampleText29.Visible -eq $false){$datSampleText29.Text = ""}
	Else{$datSampleText29.text = (Get-Date ((Get-Date).AddMonths(3)) -Format "dd/MM/yyyy")}
}
#endregion Form Functions

$CompanyLogo = "/9j/4AAQSkZJRgABAQEAYABgAAD/4QAiRXhpZgAATU0AKgAAAAgAAQESAAMAAAABAAEAAAAAAAD/7AARRHVja3kAAQAEAAAAZAAA
	/9sAQwACAQECAQECAgICAgICAgMFAwMDAwMGBAQDBQcGBwcHBgcHCAkLCQgICggHBwoNCgoLDAwMDAcJDg8NDA4LDAwM/9sAQwEC
	AgIDAwMGAwMGDAgHCAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwM/8AAEQgAHgBFAwEi
	AAIRAQMRAf/EAB8AAAEFAQEBAQEBAAAAAAAAAAABAgMEBQYHCAkKC//EALUQAAIBAwMCBAMFBQQEAAABfQECAwAEEQUSITFBBhNR
	YQcicRQygZGhCCNCscEVUtHwJDNicoIJChYXGBkaJSYnKCkqNDU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6
	g4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2drh4uPk5ebn6Onq8fLz9PX29/j5+v/E
	AB8BAAMBAQEBAQEBAQEAAAAAAAABAgMEBQYHCAkKC//EALURAAIBAgQEAwQHBQQEAAECdwABAgMRBAUhMQYSQVEHYXETIjKBCBRC
	kaGxwQkjM1LwFWJy0QoWJDThJfEXGBkaJicoKSo1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoKDhIWGh4iJ
	ipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uLj5OXm5+jp6vLz9PX29/j5+v/aAAwDAQACEQMR
	AD8A/fwnFNWTNeEfGn9unTfAfjG88J+D/C/iT4m+MNNH+nWOhxD7JpJIyFvLxv3VudvO05YAjIGVzzGiftJ/HXxrua3+H/wm8MoE
	aUpq3j/7ZMiKNzMy20BGAOvzDGK82Wa4fndOF5Nb8sZSS8m0mr+V7ntU+H8XKkq0+WEXquecItruoykpNdnazPpySTD8V5v42/a1
	8A+CPFEmgPrM2seIoTtk0nQbC41i+hOOkkVqkhi+sm0cjJGa8t8S+KPjN8QdCm0m7uPgakd6ViaKx8V6lbzT5P8AqxJEiyLuOB8h
	BPToSDc8ED4s/CzwX5XhrwH+z/pXh+33Nt0zxDc2NpGVYh2O2y2ZBByTzkHPNZ1cfUbtThJebhJ/grfn8jXD5TTSbrTjJ9EqkF97
	d/uS+Z6Jb/HXxFqlsJrL4T/ECS3k+49zPpVmzj18uS8Ei/R1U+1Y/iT9qnVvA8Xna58HvitbW3UzWNtYasPf5LS7lkH4oPbNchqf
	x2+O+nSmNvB/wREiorgN4/nVsMMqQDZDqCCDkZBFY9/8XP2mdSsBdWum/s+6NZyyGJLifxFd3aq45K7lVFLY5wK56mOko+77S/8A
	17f6xX5nXh8pi5fvPY8v/X5J/hJ6/wDbr9DrfCv/AAUx+C/iLV/7OuPFz+HdTQ4ks/EGl3ekyQn0YzxIgPtur2vw34u0nxppMeoa
	Pqen6tYTcx3NlcJcQuD6OhIP518daj+w14w/aE1S88WfEbxd8Eo55dq3V3o3ga01KRlRQo33l4zbdq4GNp4A5rc8Df8ABP69+AF0
	viDwP8VvDPhV7xVBvJPAmkeVco3IXfF5JKsPRskdDXPg8bm3NfEUU4dLWjK3nFyav80dmaZXw8oKODxLjOyunzThfS9pRpxdt7e6
	z68VxRXK/CO91K58MeTrHijQPFmqW74mvNIsvscOD90GLz5tp4PO/n0FFfSRbau1b+vmfF1IqMmk7+avZ/fZ/ej4X/4Lgfs/654n
	s/g/c2vgfxf42+Bei+Ib7UfiV4P8Dq8epauZUVra5eKBkknjWbzWl2sG+cnIYiSP8+vg58I9a8OxfHLQfBfwT1LT9G8V/BvxJBNq
	R+GGt6PqDXIh3Q2Fuby+vSVc7ThCrSlVBB8sV/QzXFfHbwh4k8b+CvsPhfWP7G1L7TFK0nnvb+bCp+ePzUVmjzx8wUnjHQmlOapw
	bS26GlGDq1FGT36vU/ED/glN+zlp3gv9rr4O6hqHwj8Uw65YXkLTyyfCDV4Pstz5DBppL+81U2cYjYmQz/ZAfkzFGkhTbi/C/wDZ
	S/aW/Z5/4I7axfeF9H8SeKPh/wDFnQ9S0rxr8PdR0u4j1fwpefaZYIdWsbfZ5rIyRwtKgXkMWZWXEsP7ef8ACv8A4kN8Q7fUf+Ev
	006DHoB0iTTfsrBpLwpuOoeZ2kEwVQmCvllj97Aqx8HPhn408C/CK80XxF4wbxJ4hlEgttVaMqYS0KKvBJb5ZQ7ck8N2GFGEcZJz
	ceR9e3S3n1udE8HGMb+0V9NLPrfy6dfXS+p+D/7Tf7LOqXn7WmqXHiz4XeLb6xTwP4OtLaWT4caz4gjW4h8P2Ec8Y+x3ll5boylG
	3PJhkK7VKnPuXjP9nTWvjx4O/Zy+Evhz9mXSfFWl2nhDUtStLjxrb+IvBWmaTcG+uDPut7O8mSB5liRka5d7mUMrOw31+oei/BL4
	qWWjeFYbrx4JJNK15b/U0+1Sv9qsRHGpt/NMYaTLpJJhgo/e7M4UE7S/D74pRXnjC4bxZo90urapaX+iWhikgj0qGG4XzLRnAYtH
	NbRoGbbkSyTEDayhc446T3g/w7X7/L/gG0stSelRfdLul2+fot7n4y+FP2NPHHwf1b9qvw5dfC3UPhXdf8KmudHsPCHhO31rXNA8
	aXDypN9ut765eUSzRx7VEKlXxu2opWcN00n7OUegeLPhVqv7TnwR+NnxZ+Ep+C/hLS/BWn+F7S+uIfCd/DpVot/b3lrbzQSQ3DTJ
	Kfn6hgCG2fuf1u8TfCj4ka/4r8WXlr4xh0mz1zRI7LS7eGWR00e8xF5kqrtG4ZWUhtwb5wMDqO7+EnhrWPCHgaz03XtYbX9Us2lW
	S/ZNrToZXaLIOTlYyinJJJXlmPzHaniZTny8rW+unR27313OethY06anzpvTTXqr9VbTZ677aHgf/BKXSPhXoX7PmpQfB/4P+N/g
	74T/ALZmd7PxXpsthfapclE8y4AnmlnkQDbGHkIA2bV4XAK+ohRXQcZ//9k="
	$mainform.CompanyLogo = $CompanyLogo
$CustomerLogo = "/9j/4AAQSkZJRgABAQEASABIAAD/4QAiRXhpZgAATU0AKgAAAAgAAQESAAMAAAABAAEAAAAAAAD/2wBDAAIBAQIBAQICAgICAgIC
				AwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwM
				DAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAyAFIDASIAAhEBAxEB/8QAHwAAAQUBAQEB
				AQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAk
				M2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKj
				pKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAA
				AAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl
				8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmq
				srO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9/KKKKACvmr9q/wDbG1rw
				/wCLtQ+H/wAM10f/AISbS4IrjxJ4k1dXk0jwVBMN0Qkjj+e5vpl5htU5OVdyI/vex/tEfFuH4CfAbxl42mg+1J4U0W71UW+dpuWh
				hZ1iB9XYBR7sK/FH/goX8f8A4i+Ip7r9lj9nO4j174naLbSal8VPHcVysFhomuXqmW/Y3ajb/aEsmbeMDL20cRRMOjNb447GfU8K
				8VZN3tHm0inu5Tf8sVrb7TaXWxzqjPGYqOChJxVuaTj8Vr2UY9pTd9fspN6OzXt3x51Hwbo3gnXfGfxh8WeLvHWk6Pbtf6tq3i/x
				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"
	$mainForm.CustomerLogo = $CustomerLogo


#region Form Details
	$iconFile = "C:\Windows\SysWOW64\cmd.exe"
	$mainform = New-Form -formObject $MainForm -escapeToClose -iconFile $iconFile
	$lblMainFormTitle = Add-FormTitle -formObject $mainForm -titleText "Some Title Text" -titleFont Tahoma -bold

#region Column 1
	$MainForm = Add-Row -formObject $mainform -rowsHigh 1 -newColumn
	$lblSampleLabel11 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Label 11"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel12 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Label 12"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel13 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Label 13"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel14 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Label 14"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel15 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Label 15"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel17 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Label 17"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel18 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Check 18"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel19 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Date 19"
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel110 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Panel Radio 19"
	$MainForm = Add-Row $mainform 2
	$MainForm = Add-Row $mainform 1
	$lblSampleLabel111 = Add-FormObject -formObject $mainForm -objectType Label -cellText "Checked List 20"
#endregion Column 1

#region Column 2
#	$mainform = Add-Column -formObject $mainform
	$MainForm = Add-Row -formObject $mainform 1 -newColumn
	$txtSampleText21 = Add-FormObject -formObject $mainForm -objectType TextBox
	$MainForm = Add-Row -formObject $mainform 1
	$txtSampleText22L = Add-FormObject -formObject $mainForm -objectType TextBox -cellSize "HalfLeft"
	$txtSampleText22R = Add-FormObject -formObject $mainForm -objectType TextBox -cellSize "HalfRight"
	$MainForm = Add-Row -formObject $mainform 1
	$cboSampleText23 = Add-FormObject -formObject $mainForm -objectType ComboBox -List $cboSampleText23_List
		$cboSampleText23.add_LostFocus({Test})
	$MainForm = Add-Row -formObject $mainform 1
	$txtSampleText24 = Add-FormObject -formObject $mainForm -objectType TextBox
	$MainForm = Add-Row -formObject $mainform 1
	$rtbSampleText25 = Add-FormObject -formObject $mainForm -objectType RichTextBox
	$MainForm = Add-Row -formObject $mainform 1
	$nudSampleText27 = Add-FormObject -formObject $mainForm -objectType NumericUpDown
	$MainForm = Add-Row -formObject $mainform 1
	$chkSampleText28 = Add-FormObject -formObject $mainForm -objectType CheckBox -cellText "Select box to show date picker"
		$chkSampleText28.add_CheckedChanged({chkSampleText28_CheckChanged})
	$MainForm = Add-Row -formObject $mainform 1
	$datSampleText29 = Add-FormObject -formObject $mainForm -objectType DateTimePicker -hidden
	$MainForm = Add-Row -formObject $mainform 3
	$panSampleText211 = Add-FormObject -formObject $mainForm -objectType Panel -border
	$MainForm = Add-Row -formObject $mainform 3
	$cklSampleText212 = Add-FormObject -formObject $mainForm -objectType CheckedListBox -List $cboSampleText23_List
	

	$radSample210d = New-Object System.Windows.Forms.radioButton
	$radSample210d.Location = New-Object System.Drawing.Point(10,0)
	$radSample210d.Text = "Option 1"
	$panSampleText211.Controls.Add($radSample210d)

	$radSample210e = New-Object System.Windows.Forms.radioButton
	$radSample210e.Location = New-Object System.Drawing.Point(10,20)
	$radSample210e.Text = "Option 2"
	$panSampleText211.Controls.Add($radSample210e)
	
	$radSample210f = New-Object System.Windows.Forms.radioButton
	$radSample210f.Location = New-Object System.Drawing.Point(10,40)
	$radSample210f.Text = "Option 3"
	$panSampleText211.Controls.Add($radSample210f)

#endregion column 2
	
#region Column 3
#	$mainform = Add-Column $mainform
	$MainForm = Add-Row $mainform 1 -newColumn
	$lblLabel3 = Add-FormObject -formObject $mainForm -objectType Label -border
	$MainForm = Add-Row $mainform 1
	$btnTest1 = Add-FormButton -FormObject $MainForm -buttonText "Test" -buttonSize "Full"

#endregion column 3

#region Column 4
#	$mainform = Add-Column $mainform
	$MainForm = Add-Row $mainform 1 -newColumn
	$lblLabel5 = Add-FormObject -formObject $mainForm -objectType Label -border
	$MainForm = Add-Row $mainform 1
	$btnTest2 = Add-FormButton -FormObject $MainForm -buttonText "Test2" -buttonSize "1QLeft"
	$btnTest3 = Add-FormButton -FormObject $MainForm -buttonText "Test3" -buttonSize "3QRight"

#endregion column 4

# Calculate form size
	$MainForm = Set-FormSizing -formObject $MainForm
	
#region buttons and pictures
# Add buttons to footer, number is button number counting from right to left
	$btnButton1 = Add-formbutton -formObject $mainform -buttonText "Test Button 1" -buttonLocation 1
		$btnButton1.add_Click({Reset-FormFields -formObject $mainform})
	$btnButton2 = Add-formbutton -formObject $mainform -buttonText "Test Button 2" -buttonLocation 2
	
	$picCompanyLogo = Add-FormPicture -formObject $mainform -pictureImage $CompanyLogo -pictureLocation "Footer"
	$picCustomerLogo = Add-FormPicture -formObject $mainform -pictureImage $CustomerLogo -pictureLocation "Header" 
		
#endregion buttons and pictures


	$null = show-Form -formObject $mainForm




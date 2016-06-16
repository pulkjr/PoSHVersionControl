# PoSHVersionControl
This PowerShell Module is being developed to automate the PowerShell development process. It uses a workflow to create, test, deploy, and update scripts all while maintaining version control. It is meant to assist organizations unable to purchase or utilize larger centralized management frameworks while allowing for collaborative maintenenance of scripts.

#Workflow
1. Create a command -  _New-Command_
  1. This cmdlet will generate a .ps1 in the Testing/Functions directory with the name that you specify using the NewCommandTemplate.conf template file found in the resources directory.
  2. By default the date and serial of the script will be generated.
2. Commit the command to the share.
  1. The commit will copy the files to the share and update the file.changelog.xml 
3. Test the local commands functionality and validate it is working as desired. This can be done by a peer. The script will automatically be downloaded from the share and placed into the Testing/Functions directory.
4. Approve the command for release to desired PowerShell module.
5. Pull and checkout command for update. Start process over again.

#Initial Setup
1. Create an SMB share to use as a repository
2. 
